# Parrot OS install guide

## NTP config

```shell
sudo timedatectl set-ntp true
timedatectl
```

## apt install

```shell
sudo apt install parrot-desktop-i3 t rofi polybar fonts-noto-cjk fonts-noto-color-emoji zsh
```

- yazi dependences

```shell
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
```

## manual install

- font(nerdfont)

  ```shell
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip
  unzip -d FiraCode FiraCode.zip
  sudo cp -r FiraCode /usr/share/fonts/truetype
  fc-cache -fv
  ```


- [typora](https://typora.io/#linux)

- [keyd](https://github.com/rvaiya/keyd?tab=readme-ov-file#sample-config)

  ```shell
  git clone https://github.com/rvaiya/keyd
  cd keyd
  make && sudo make install
  sudo systemctl enable --now keyd
  ```

  ```
  sudo systemctl restart keyd
  ```

  

- 

- [starship](https://starship.rs/guide/)

  ```shell
  curl -sS https://starship.rs/install.sh | sh
  ```

- [yazi](https://yazi-rs.github.io/docs/installation/#source)

  ```shell
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  rustup update
  git clone https://github.com/sxyazi/yazi.git
  cd yazi
  cargo build --release --locked
  ```
  
  ```toml
  # ~/.config/yazi/yazi.toml
  [manager]
  show_hidden = true
  ```
  
  

## Dotfiles

- keyd

  ```
  # /etc/keyd/default.conf
  [ids]
  
  *
  
  [main]
  
  shift = oneshot(shift)
  space = overload(shift, space)
  
  meta = oneshot(meta)
  control = oneshot(control)
  
  leftalt = oneshot(alt)
  rightalt = oneshot(altgr)
  
  capslock = overload(control, esc)
  insert = S-insert
  
  muhenkan = leftmeta
  
  ```

  

## Japanese key layout

- /etc/default/keyboard

```
# KEYBOARD CONFIGURATION FILE

# Consult the keyboard(5) manual page.

XKBMODEL="pc105"
- XKBLAYOUT="us"
+ XKBLAYOUT="jp"
XKBVARIANT=""
XKBOPTIONS=""

BACKSPACE="guess"
```

- timezone

```shell
sudo timedatectl set-timezone Asia/Tokyo
```

- display

```shell
sudo localectl set-locale ja_JP.UTF-8
# reboot
```

- input

```shell
sudo apt install fcitx5 fcitx5-mozc mozc-utils-gui
# reboot
```

```shell
mozc_tool --mode=config_dialog
```



