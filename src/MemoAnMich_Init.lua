local ADDON_NAME = "MemoAnMich"

local MAM = {
	NAME = ADDON_NAME,
	DISPLAY_NAME = "MemoAnMich",
	AUTHOR = "Arglgargl",
	VERSION = "0.0.1",
	VARIABLES="MemoAnMich_Data",
	COLOR_GOLD = "d4af37",

    savedVars = {},
    internal = {
        gettext = LibGetText(ADDON_NAME).gettext
    }
}

_G[ADDON_NAME] = MAM
