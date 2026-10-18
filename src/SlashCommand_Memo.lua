local MAM = MemoAnMich

if(not MAM.SlashCommand_Memo) then MAM.SlashCommand_Memo = MAM.SlashCommand:Subclass() end
local SlashCommand_Memo = MAM.SlashCommand_Memo

function SlashCommand_Memo:Alias()
	return "memo"
end

function SlashCommand_Memo:Description()
	return "Add memo for character"
end

function SlashCommand_Memo:Execute(args)


	--MAM.OpenPopup(text)
	d("test memo")
end
