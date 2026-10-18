local MAM = MemoAnMich

if(not MAM.MemoEdit) then MAM.MemoEdit = ZO_Object:Subclass() end
local MemoEdit = MAM.MemoEdit

function MemoEdit:New( toonId, message )

  local this = ZO_Object.New(self)
  
  this.selectedToon = toonId
  this.message = message or ""
  
  self.editbox = nil

  return this
end

function MemoEdit:IsValid()
  return self.selectedToon and self.message and string.len(self.message) > 0
end

function MemoEdit:SelectedToon()
  return self.selectedToon
end

function MemoEdit:Message()
  return self.message
end

function MemoEdit:Open(callback)

  if self.editbox then
    d("called to open when box is open")
    return
  end

  self.editbox = self:CreateEditBox()
  MAM.MemoEdit.currentEditor = self

  self.callback = callback

  local hidden = MAM_MemoEdit:IsHidden()
  
  if self.message then
    self.editbox:SetText(self.message:sub(1,MYSTERY_LIMIT))
  end
  -- Scroll to top. Doesn't work immediately, but
  -- there's nothing that a SLEEP 10 can't fix!
  zo_callLater(function() self.editbox:SetCursorPosition(0) end, 10)

  if hidden then
    MAM_MemoEdit:SetHidden(false)
    SetGameCameraUIMode(true)
  end
end

-- REMARK: from Home-StationMarkers
function MemoEdit:CreateEditBox()
    local container = MAM_MemoEdit

    local backdrop = WINDOW_MANAGER:CreateControlFromVirtual( nil, container, "ZO_EditBackdrop")
    backdrop:SetAnchor(TOPLEFT,     container, TOPLEFT,      50, 100)
    backdrop:SetAnchor(BOTTOMRIGHT, container, BOTTOMRIGHT, -5, -5)

    local editbox = WINDOW_MANAGER:CreateControlFromVirtual(nil, backdrop, "ZO_DefaultEditMultiLineForBackdrop")
    editbox:SetMaxInputChars(250)

    return editbox
end

function MemoEdit.CloseCurrent()
  local MemoEdit = MAM.MemoEdit
  
  local memoEdit = MAM.MemoEdit.currentEditor
  if not memoEdit then d("no memoedit open during close") end

  memoEdit:Close()
end

function MemoEdit:Close()

  self.message = self.editbox:GetText()

  MAM_MemoEdit:SetHidden(true)
  
  self.editbox = nil
  
  MAM.MemoEdit.currentEditor = nil

  self.callback( self:IsValid(), self:SelectedToon(), self:Message() )
  self.callback = nil

end

