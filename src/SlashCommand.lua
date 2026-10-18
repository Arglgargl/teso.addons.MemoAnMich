local MAM = MemoAnMich

if(not MAM.SlashCommand) then MAM.SlashCommand = ZO_Object:Subclass() end
local SlashCommand = MAM.SlashCommand

function SlashCommand:New(cmdParent, data)

  local this = ZO_Object.New(self)
	this.cmdParent = cmdParent
	this.data = data

  return this
end

function SlashCommand:Register()
	self.cmd = self.cmdParent:RegisterSubCommand()
	self.cmd:AddAlias(self:Alias())
	self.cmd:SetDescription(self.Description())
	self.cmd:SetCallback( function(...) self:Execute(...) end )
end

function SlashCommand:SetAutoComplete( table )
  self.cmd.SetAutoComplete( table )
end

-- abstract methods
SlashCommand.Alias = SlashCommand:MUST_IMPLEMENT()
SlashCommand.Description = SlashCommand:MUST_IMPLEMENT()
SlashCommand.Execute = SlashCommand:MUST_IMPLEMENT()
