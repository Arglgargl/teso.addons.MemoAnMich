local MAM = MemoAnMich

if(not MAM.Memo) then MAM.Memo = ZO_Object:Subclass() end
local Memo = MAM.Memo

Memo.MEMO_STATUS_PENDING = 1
Memo.MEMO_STATUS_ANNOUNCED = 2

------- Reading / Writing to from save variable ---------------

function Memo:NewDataObject(charid, message)

return {
  charid = charid,
  message = message,
  status = Memo.MEMO_STATUS_PENDING,
  created = os.time()
}

end

function Memo:Read(data)
  return Memo:New( data )
end


------- Memo Class Methods

function Memo:New( data )

  local this = ZO_Object.New( self )

  this.data = data

  return this
end

function Memo:ToonId()
  return self.data.charid
end

function Memo:Message()
  return self.data.message
end

function Memo:Status()
  return self.data.status
end

function Memo:SetStatus(newStatus)
  self.data.status = newStatus
end


function Memo:Print()

    if not self.data.status then return end

    d("charid="..self.data.charid)
    d("message="..self.data.message)
    d("status="..self.data.status)
    d("created="..self.data.created)
end

function Memo:Process(currentToonId)

  local toonIndex = MAM.savedVars.toonIndex
  local currentToonName = toonIndex[currentToonId]

  local isPending = self:Status() == Memo.MEMO_STATUS_PENDING 
  local isCurrent = self:ToonId() == currentToonId 

  if isPending and isCurrent then
    d( "MemoAn "..currentToonName..": "..self:Message() )

    self:SetStatus( Memo.MEMO_STATUS_ANNOUNCED )
  end

end
