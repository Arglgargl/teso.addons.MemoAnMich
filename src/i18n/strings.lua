local strings = {
  MAM_MEMOEDIT_DIALOG_TITLE =    "MemoToMe",
	MAM_MEMOEDIT_MESSAGE		=      "Message:",
	MAM_MEMOEDIT_SENDMESSAGE =     "Send Message",
	MAM_MEMOEDIT_CANCEL =          "Cancel",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
