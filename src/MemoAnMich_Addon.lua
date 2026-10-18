local MAM = MemoAnMich

-- Constant
local SLASH_MAM = "/mam"

function MAM.OutputInitMessage()
  MAM.msgGold( MAM.NAME .. " v" .. MAM.VERSION .. " initialized." )
  
  --MAM.RegisterSlashCommands()
end

function MAM.msgGold( text )
    d("|c" .. MAM.COLOR_GOLD .. text .. "|r")
end

function MAM.RegisterSlashCommands()

  local mainCmd = LibSlashCommander:Register( SLASH_MAM , function(args) MAM.OpenPopup("Please select a sub-command") end
            , "MemoAnMich")

  local toonIndex = MAM.savedVars.toonIndex

  for toonId, toonName in pairs(toonIndex) do
    MAM.SlashCommand_Character:RegisterForCharacter(mainCmd, toonId, toonName)
  end
end

function MAM.RegisterToonName()
    local unitName = GetUnitName("player")
    local toonName = zo_strformat(SI_UNIT_NAME, unitName)
    
    local toonId = GetCurrentCharacterId();
    
    local toonIndex = MAM.savedVars.toonIndex
    toonIndex[toonId] = toonName
end

function MAM.ShowMemos()

  local toonId = GetCurrentCharacterId();

  local memos = MAM.savedVars.memos

  for i,memoData in pairs(memos) do
    local memo = MAM.Memo:Read( memoData )
    --memo:Print()
    memo:Process( toonId )
  end

end

function MAM.OnAddonLoad(eventCode, name)

	if name ~= MAM.NAME then return end

  -- Unregister
  EVENT_MANAGER:UnregisterForEvent(MAM.NAME, EVENT_ADD_ON_LOADED)

  -- Init MAM
	MAM.savedVars = ZO_SavedVars:NewAccountWide(MAM.VARIABLES, 1, nil, nil, GetWorldName(), nil)
	MAM.savedVars.toonIndex = MAM.savedVars.toonIndex or {}
	MAM.savedVars.memos = MAM.savedVars.memos or {}

	MAM.RegisterToonName()
  MAM.RegisterSlashCommands()

	zo_callLater( MAM.OutputInitMessage, 1000 )

  -- TODO: load memos for this char and display
  zo_callLater( MAM.ShowMemos, 1000 )

end


EVENT_MANAGER:RegisterForEvent(MAM.NAME, EVENT_ADD_ON_LOADED, MAM.OnAddonLoad)


function MAM.AddMemo(charid, message)

	local newMemoData = MAM.Memo:NewDataObject(charid, message)
	
  local memos = MAM.savedVars.memos
	memos[#memos+1] = newMemoData

  local newMemo = MAM.Memo:Read(newMemoData)

  local toonIndex = MAM.savedVars.toonIndex
  local toonName = toonIndex[newMemo:ToonId()]
	d("Memo Saved for '"..toonName.."': "..newMemo:Message())
end

--------------------------------------------------------------

function MAM.OpenPopup(text)

    local hidden = MAM_ExportPopup:IsHidden()

    if not MAM.editbox then
        MAM.editbox = MAM.CreateEditBox()

	-- local lang = MAM.LANG[self.clientlang]["export"] or self.LANG["en"]["export"]
	-- HomeStationMarker_ExportUIWindowTitle:SetText(lang.WINDOW_TITLE)
    end

	MAM.editbox:SetText(text:sub(1,MYSTERY_LIMIT))
	-- Scroll to top. Doesn't work immediately, but
	-- there's nothing that a SLEEP 10 can't fix!
	zo_callLater(function() MAM.editbox:SetCursorPosition(0) end, 10)

    if hidden then
		MAM_ExportPopup:SetHidden(false)
		SetGameCameraUIMode(true)
	end

end

function MAM.Close_ExportRoosterPopup()
		MAM_ExportPopup:SetHidden(true)
end

-- REMARK: from Home-StationMarkers
function MAM.CreateEditBox()
    local container = MAM_ExportPopup

    local backdrop = WINDOW_MANAGER:CreateControlFromVirtual( nil, container, "ZO_EditBackdrop")
    backdrop:SetAnchor(TOPLEFT,     container, TOPLEFT,      5, 50)
    backdrop:SetAnchor(BOTTOMRIGHT, container, BOTTOMRIGHT, -5, -5)

    local editbox = WINDOW_MANAGER:CreateControlFromVirtual(nil, backdrop, "ZO_DefaultEditMultiLineForBackdrop")
    editbox:SetMaxInputChars(20000)

    return editbox
end