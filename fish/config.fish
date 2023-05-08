source "$HOME/.config/fish/kanagawa.fish"

if status is-login
    # auto launch Hyprand after login
    exec Hyprland
end
