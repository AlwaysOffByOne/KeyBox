-- English strings and fallback values for KeyBox

local _, KeyBox = ...

KeyBox.L = KeyBox.L or {}
local L = KeyBox.L

L.EDITOR_TITLE = "KeyBox Editor"
L.TAB_SETTINGS = "Settings"
L.TAB_RESETS = "Resets"
L.TAB_HELP = "Help"

L.TRIGGER_KEY = "Trigger key:"
L.PRESS_A_KEY = "Press a key..."
L.WIDTH_PIXELS = "Width (px):"
L.HEIGHT_PIXELS = "Height (px):"
L.BORDER_PIXELS = "Border (px):"
L.COLOR = "Color:"
L.OPACITY_PERCENT = "Opacity (%):"
L.NOT_SET = "Not set"
L.KEY_SHIFT = "Shift"
L.KEY_CTRL = "Ctrl"
L.KEY_ALT = "Alt"

L.SAVE_CHARACTER = "Save Character"
L.SAVE_ACCOUNT = "Save Account"
L.CHARACTER_SETTINGS_SAVED = "Character settings saved!"
L.ACCOUNT_DEFAULT_SAVED = "Account default saved; character overrides were preserved."

L.CHARACTER_OVERRIDE = "Character override"
L.CHARACTER_OVERRIDE_DESCRIPTION = "Return this character to the account default."
L.RESET_CHARACTER = "Reset Character"
L.CHARACTER_OVERRIDE_CLEARED = "Character override cleared; using the account default."

L.ACCOUNT_DEFAULT = "Account default"
L.ACCOUNT_DEFAULT_DESCRIPTION = "Remove the account default while preserving character overrides."
L.RESET_ACCOUNT = "Reset Account"
L.ACCOUNT_DEFAULT_CLEARED = "Account default cleared; character overrides were preserved."

L.BASE_SETTINGS = "Base settings"
L.BASE_SETTINGS_DESCRIPTION = "Load a clean starting configuration without saving it."
L.LOAD_BASE_SETTINGS = "Load Base Settings"
L.BASE_SETTINGS_LOADED = "Base settings loaded. Save them to the desired scope."

L.HELP_SHOWING_TITLE = "Showing and editing"
L.HELP_SHOWING_DESCRIPTION = "Hold the configured trigger key to show the box. Click Trigger key to choose a new key; Escape cancels key capture."
L.HELP_SAVING_TITLE = "Saving"
L.HELP_SAVING_DESCRIPTION = "Save Character creates an override for this character. Save Account sets the default for characters without an override."
L.HELP_RESETTING_TITLE = "Resetting"
L.HELP_RESETTING_DESCRIPTION = "Reset Character returns to the account default. Reset Account removes the shared default but preserves character overrides."
L.HELP_CLOSING_TITLE = "Closing"
L.HELP_CLOSING_DESCRIPTION = "The title-bar X discards previews made after the most recent save or reset action."

L.ADDON_LOADED = "Add-on loaded! Use |cff00FF00/keybox|r to open the editor."
