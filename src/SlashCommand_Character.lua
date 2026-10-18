local MAM = MemoAnMich

if(not MAM.SlashCommand_Character) then MAM.SlashCommand_Character = {} end
local SlashCommand_Character = MAM.SlashCommand_Character

function SlashCommand_Character:RegisterForCharacter(mainCmd, toonId, toonName)

  if(not SlashCommand_Character.chars) then SlashCommand_Character.chars = {} end

  if(SlashCommand_Character.chars[toonId]) then 
    d("command for character already registered")
    return 
  end

  SlashCommand_Character.chars[toonId] = MAM.SlashCommand:Subclass()

  local cmd = MAM.SlashCommand:Subclass()
  SlashCommand_Character.chars[toonId] = cmd

  cmd.Alias = function()
		return toonName:gsub("%s+", "")
  end

  cmd.Description = function()
	  return "Add memo for "..toonName
  end

  cmd.Execute = function(myself,message)
    -- todo open input dialog

    -- local mam = self.data

    --MAM.OpenPopup(text)
    MAM.AddMemo(toonId, message)
  end

  cmd:New(mainCmd, MAM):Register()

end
