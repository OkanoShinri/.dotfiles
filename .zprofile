#if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
#  exec ls
#fi

export SUDO_EDITOR=rnano
export EDITOR=kak
export PATH="$PATH:$HOME/.cargo/bin"
export ELECTRON_OZONE_PLATFORM_HINT=auto
export QT_QPA_PLATFORM=""

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

