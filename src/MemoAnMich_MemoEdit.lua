local MAM = MemoAnMich

if(not MAM.MemoEdit) then 
  MAM.MemoEdit = {}
  
  SCENE_MANAGER:RegisterTopLevel(MAM_MemoEdit_Dialog, locksUIMode)
end

local MemoEdit = MAM.MemoEdit

function MemoEdit.Open(toonId, message)

  if MemoEdit.active then
    d("dialog active")
    return
  end
  
  MemoEdit.selectedToon = toonId
  MemoEdit.message  = message

  local toonIndex = MAM.savedVars.toonIndex

  -- select toon  
  local charlist = MemoEdit.CreateCharList()
  
  if toonId then
    charlist:SetSelectedItem(toonIndex[toonId])
  else
    local firstId, firstName = next(toonIndex)
    charlist:SetSelectedItem(firstName)
  end
  
  -- set text
  local textbox = MemoEdit.CreateTextBox()
  textbox:SetText(message)

  MemoEdit.ToggleWindow()
  
  textbox:TakeFocus()

end

function MemoEdit.ToggleWindow()
  SCENE_MANAGER:ToggleTopLevel(MAM_MemoEdit_Dialog)

end

function MemoEdit.WindowOK()
  MemoEdit.ToggleWindow()
  
  local message = MAM_MemoEdit_Dialog_Body_TextBox_Control:GetText()
  MemoEdit.message = message
  local isValid = MemoEdit.selectedToon and message and string.len(message) > 0
  
  if isValid then
    MAM.AddMemo(MemoEdit.selectedToon, MemoEdit.message)
  else
    d("invalid message")
  end
end

function MemoEdit.WindowCancel()
  MemoEdit.ToggleWindow()
end


function MemoEdit.CreateCharList()

  if MAM_MemoEdit_Dialog_Header_CharList.comboBox then return MAM_MemoEdit_Dialog_Header_CharList.comboBox end

  MAM_MemoEdit_Dialog_Header_CharList.data = {tooltipText = "Select a character to view. You must have logged in on the selected character with this addon active for information to populate."}
  MAM_MemoEdit_Dialog_Header_CharList.comboBox = ZO_ComboBox_ObjectFromContainer(MAM_MemoEdit_Dialog_Header_CharList)
  local charlist = MAM_MemoEdit_Dialog_Header_CharList.comboBox

  charlist:SetSortsItems(false)

  local toonByName = {}

  function OnItemSelect(_, choiceText, choice)
    MemoEdit.selectedToon = toonByName[choiceText]
    PlaySound(SOUNDS.POSITIVE_CLICK)
  end

  local toonIndex = MAM.savedVars.toonIndex
  for toonId,toonName in pairs(toonIndex) do
    toonByName[toonName] = toonId
    charlist:AddItem(charlist:CreateItemEntry(toonName, OnItemSelect))
  end

  return charlist
end

function MemoEdit.CreateTextBox()
  return MAM_MemoEdit_Dialog_Body_TextBox_Control
end

