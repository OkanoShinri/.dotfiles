#if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
#  exec ls
#fi

export SUDO_EDITOR=rnano
export EDITOR=helix
export PATH="$PATH:$HOME/.cargo/bin"

# japanese input
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# electron
export ELECTRON_OZONE_PLATFORM_HINT=auto
# export QT_QPA_PLATFORM=""

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

