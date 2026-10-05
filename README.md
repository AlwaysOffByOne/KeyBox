# KeyBox

## Simple AddOn
Some players have abilities tied to a keyboard modifier or another key, but sometimes it can be hard to tell if that input is coming through. This simple addon puts a box on screen while a configured key is pressed so you can make sure that the right ability will be used.

## Settings

Open the editor with `/keybox`. Settings are applied in this order:

1. Base settings.
2. Your account default.
3. The current character's saved override.

Click **Trigger key**, then press a keyboard key to choose when the box appears. Left and right Shift, Ctrl, and Alt are each treated as a single modifier. Press Escape while choosing a key to cancel the capture. Shift remains the default for existing users who have not saved another trigger.

Click the color swatch in the editor to open WoW's native color picker. Border opacity is controlled by the separate **Opacity (%)** field.
The editor uses fixed logical UI dimensions, relies on WoW's screen clamping and UI scale, and only scales down when the available UI area is too small.

The editor provides these persistence actions:

- **Save Character** saves the current settings only for the current character.
- **Save Account** saves the current settings as the default for characters without an override. Existing character overrides are preserved.
- The **Resets** tab contains the character reset, account reset, and base settings actions.
- The **Help** tab summarizes trigger behavior, save scopes, reset behavior, and closing without saving.
- **Reset Character** removes only the current character's override and loads the account default.
- **Reset Account** removes only the account default. Existing character overrides are preserved, while characters without overrides return to the base settings.
- **Load Base Settings** loads a clean starting configuration into the editor. Use **Save Character** or **Save Account** afterward to persist it.

Editor changes preview immediately. Closing with the title-bar **X** restores changes that have not been saved or applied through a reset action.

The trigger key, size, border, color, alpha, and dragged box position are included whenever character or account settings are saved.

## Code organization

- `KeyBox.lua` coordinates add-on events, slash commands, and box visibility.
- `KeyBox_Defaults.lua` defines base settings, constraints, and UI dimensions.
- `KeyBox_Settings.lua` owns settings precedence, persistence, and resets.
- `KeyBox_Box.lua` owns box rendering, positioning, color updates, and edit-mode dragging.
- `KeyBox_Input.lua` tracks keyboard state and captures a configured trigger key without consuming gameplay input.
- `KeyBox_Edit.lua` builds and manages the editor UI.
- `KeyBox_Utils.lua` contains small shared helpers for clamping and messages.