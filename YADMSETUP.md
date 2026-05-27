# dotfiles

## Manual steps
### 1Password
1. Follow steps to connect 1p cli to 1password: https://developer.1password.com/docs/cli/get-started
2. Click install ssh agent
3. Accept use of keynames
4. done

### PAC
1. Follow steps: https://hello.atlassian.net/wiki/spaces/RELENG/pages/677899738/HOWTO+-+Set+up+your+local+dev+environment+to+work+with+packages.atlassian.com

### Work
See: 
* https://hello.atlassian.net/wiki/spaces/ServiceMatrix/pages/1786601909/Laptop+setup
* https://hello.atlassian.net/wiki/spaces/RELENG/pages/1856294173/HOWTO+-+Install+the+local+software+needed+for+atlas+packages+secrets

### Future
1. 1 day setup 1password cli agent toml to store ssh keys in appropiate vaults

### tmux on macOS
1. Run `macos-privacy-preflight` locally from Alacritty and grant any macOS Privacy & Security prompts before relying on remote SSH attach.
2. Load the managed tmux service with `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.marcodejongh.tmux-main.plist`.
3. Use `tmux -L main ...` for direct commands against the managed session.
4. Use `yadm list -a` when you need the full dotfile inventory, including platform alternates.

