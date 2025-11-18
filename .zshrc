HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt inc_append_history
setopt share_history

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:$HOME/.cargo/bin"

eval "$(sheldon source)"
eval "$(starship init zsh)" 

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias la='lsd -la'
alias ..='cd ..'
alias sz='source ~/.zshrc'
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
alias sound=alsamixer
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 && upower -i /org/freedesktop/UPower/devices/battery_BAT1 '
alias connect-inet='nmcli device wifi connect inet6_a password "open inet"'
alias reconnect-inet='nmcli connection delete inet6_a && nmcli device wifi connect inet6_a password "open inet"'
alias reconnect-mm2020='nmcli connection delete mm2020 && nmcli device wifi connect mm2020 password "a3b7a2ede5bfb02fd5124b13f766f369"'
alias htb='sudo /usr/sbin/openvpn ~/workspace/htb/lab_5h1nr1.ovpn'
alias nc='ncat'
alias gc='git clone '
alias -g @c='| wl-copy'
alias pyven='python -m venv venv && source venv/bin/activate && pip install -U pip && pip install requests && echo -e "\n\e[1;32m=============================\e\n\e[1;32m  Virtual environment ready! \e[0m\n\e[1;32m=============================\e[0m\n"'
alias server='python -m http.server 8888'
alias sudo='sudo '
alias untar='tar xzvf'
alias pdf='zathura'
alias hl.='hl .'
alias wl='nmcli device wifi list'

if command -v hx >/dev/null 2>&1; then
    alias hl='hx'
elif command -v helix >/dev/null 2>&1; then
    alias hl='helix'
fi
