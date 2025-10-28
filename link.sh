#!/bin/bash
# ~/.dotfiles の内容にリンクを張り替えるスクリプト
# /etc/dotfiles → ~/.dotfiles に変更
# 既存ファイルは ~/.dotfiles_backup/ に退避
# Wayland 環境では systemd ユニットをリロード＆追加

SALTHOME="/home/salt"
DOTFILES="$SALTHOME/.dotfiles"
BACKUP="$SALTHOME/.dotfiles_backup"
TARGET="$SALTHOME/.config"

mkdir -p "$BACKUP"

# .config 以下
declare -A CONFIG_LINKS=(
  [foot]="$DOTFILES/.config/foot"
  [helix]="$DOTFILES/.config/helix"
  [kak]="$DOTFILES/.config/kak"
  [niri]="$DOTFILES/.config/niri"
  [sheldon]="$DOTFILES/.config/sheldon"
  [starship.toml]="$DOTFILES/.config/starship.toml"
  [swaylock]="$DOTFILES/.config/swaylock"
  [waybar]="$DOTFILES/.config/waybar"
  [wlogout]="$DOTFILES/.config/wlogout"
  [yazi]="$DOTFILES/.config/yazi"
  [systemd/user/swaybg.service]="$DOTFILES/.config/systemd/user/swaybg.service"
)

# ホーム直下
declare -A HOME_LINKS=(
  [.zshrc]="$DOTFILES/.zshrc"
  [.zprofile]="$DOTFILES/.zprofile"
)

# /etc 配下
declare -A ETC_LINKS=(
  [/etc/keyd/default.conf]="$DOTFILES/etc/keyd/default.conf"
  [/etc/greetd/config.toml]="$DOTFILES/etc/greetd/config.toml"
)

backup_and_link () {
  local dest="$1"
  local src="$2"

  #if [ -e "$dest" ] || [ -L "$dest" ]; then
  #  local base
  #  base=$(basename "$dest")
  #  echo "→ $dest をバックアップします"
  #  mv "$dest" "$BACKUP/${base}_$(date +%Y%m%d%H%M%S)"
  #fi

  # 既存のリンクやディレクトリを削除してから作り直す
  if [ -L "$dest" ] || [ -e "$dest" ]; then
    echo "→ $dest を削除します"
    rm -rf "$dest"
  fi

  echo "→ $dest → $src を作成します"
  ln -s "$src" "$dest"
}

# .config の処理
for name in "${!CONFIG_LINKS[@]}"; do
  backup_and_link "$TARGET/$name" "${CONFIG_LINKS[$name]}"
done

# ホーム直下の処理
for name in "${!HOME_LINKS[@]}"; do
  backup_and_link "$SALTHOME/$name" "${HOME_LINKS[$name]}"
done

# /etc 配下の処理（root 権限が必要）
for dest in "${!ETC_LINKS[@]}"; do
  backup_and_link "$dest" "${ETC_LINKS[$dest]}"
done

echo "完了しました！ バックアップは $BACKUP に保存されています。"

