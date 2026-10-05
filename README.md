# WowShiftBox
Sample Repo for attempted ShiftBox Addon

# Simple AddOn
Some players have their abilities tied to a shift button but sometimes it can be hard to tell if that input is coming through. This simple addon puts a box on screen when shift is pressed so you can make sure that the right ability will be used.

## Settings

Open the editor with `/shiftbox edit`. Settings are applied in this order:

1. Base settings.
2. Your account default.
3. The current character's saved override.

Click the color swatch in the editor to open WoW's native color picker. Border opacity is controlled by the separate **Opacity (%)** field.
The editor uses fixed logical UI dimensions, relies on WoW's screen clamping and UI scale, and only scales down when the available UI area is too small.

The editor provides these persistence actions:

- **Save Character** saves the current settings only for the current character.
- **Save Account** saves the current settings as the default for characters without an override. Existing character overrides are preserved.
- The **Resets** tab contains the character reset, account reset, and base settings actions.
- **Reset Character** removes only the current character's override and loads the account default.
- **Reset Account** removes only the account default. Existing character overrides are preserved, while characters without overrides return to the base settings.
- **Load Base Settings** loads a clean starting configuration into the editor. Use **Save Character** or **Save Account** afterward to persist it.

Settings saved by earlier versions are migrated to the account default automatically.
Size, border, color, alpha, and the dragged box position are included whenever character or account settings are saved.

## Code organization

- `ShiftBox.lua` coordinates add-on events, slash commands, and Shift-key visibility.
- `ShiftBox_Defaults.lua` defines base settings, constraints, and UI dimensions.
- `ShiftBox_Settings.lua` owns settings precedence, persistence, resets, and legacy migration.
- `ShiftBox_Box.lua` owns box rendering, positioning, color updates, and edit-mode dragging.
- `ShiftBox_Edit.lua` builds and manages the editor UI.
- `ShiftBox_Utils.lua` contains small shared helpers for clamping and messages.