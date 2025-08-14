# Export Instructions

Run the following commands to export GNOME keybinding settings to .dconf files:

```bash
dconf dump /org/gnome/desktop/wm/keybindings/ > gnome-wm-keybindings.dconf
dconf dump /org/gnome/mutter/keybindings/ > gnome-mutter-keybindings.dconf
dconf dump /org/gnome/shell/keybindings/ > gnome-shell-keybindings.dconf
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > gnome-media-keys.dconf
```

## Notes

- These commands output the current GNOME keybinding configuration in a text-based `.dconf` format.
- You can version-control these files as part of your dotfiles repository.
- To restore the settings on a new system, run:

```bash
dconf load /org/gnome/desktop/wm/keybindings/ < gnome-wm-keybindings.dconf
dconf load /org/gnome/mutter/keybindings/ < gnome-mutter-keybindings.dconf
dconf load /org/gnome/shell/keybindings/ < gnome-shell-keybindings.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-media-keys.dconf
```
