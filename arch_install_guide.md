# ArchLinuxインストール手順

基本的に[archwiki](https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89)に従っている

## 事前準備

- インストールメディアはddで作成
- インストールメディアから起動
- 有線ネットワーク疎通確認
  - `ping archlinux.jp`
  - `ip a`
- 時刻設定確認
  - `timedatectl status`
  - ntpがacvtiveになっていればOK

## ファイルシステム作成

- ディスク確認
  - `lsblk -l`
  - ディスク名を控える `nvme0n1`とか

- [レイアウトはarchwikiに従う](https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89#.E3.83.AC.E3.82.A4.E3.82.A2.E3.82.A6.E3.83.88.E4.BE.8B)

| マウントポイント | パーティション | [パーティションタイプ](https://wiki.archlinux.jp/index.php/GPT_fdisk#%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%BF%E3%82%A4%E3%83%97) | 容量 |
|------------------|----------------|----------------------|------|
| /mnt/boot1 | /dev/efi_system_partition | EFI システムパーティション(`ef00`) | 最低 300 MiB。複数のカーネルをインストールする場合は、最低 1 GiB。 |
| [スワップ] | /dev/swap_partition | Linux swap(`8200`) | 512 MiB 以上 |
| /mnt | /dev/root_partition | Linux x86-64 root (/)(`8304`) | デバイスの残り容量全て |

- `cgdisk /dev/nvme0n1`
  - TUIで操作できる
  - 必要に応じて既存のパーティションをDELETE
- efiパーティション
  - \<new\>
  - First sector: enter
  - Size in sectors: `+2G`
  - Hex code or GUID:ef00
  - Enter new partition name:arch efi
- swapパーティション
  - \<new\>
  - First sector: enter
  - Size in sectors: `+32G`
  - Hex code or GUID: 8200
  - Enter new partition name:swap
- rootパーティション
  - \<new\>
  - First sector: enter
  - Size in sectors: enter
  - Hex code or GUID: `8304`
  - Enter new partition name: arch root
- \<Write\>

- [ ] `ls /dev`でnvme0n1p1,p2,p3があればOK

## フォーマット

- [EFI システムパーティションを作成した場合、mkfs.fat(8) を使って FAT32 に フォーマット してください。(arch wiki)](https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89#:~:text=%E3%81%A6%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84%E3%80%82-,EFI%20%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E4%BD%9C%E6%88%90%E3%81%97%E3%81%9F%E5%A0%B4%E5%90%88%E3%80%81mkfs.fat(8)%20%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%20FAT32%20%E3%81%AB%20%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88%20%E3%81%97%E3%81%A6%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84%E3%80%82,-%E8%AD%A6%E5%91%8A:%20%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%8B%E3%83%B3%E3%82%B0%E3%81%AE)
  - `mkfs.fat -F 32 /dev/nvme0n1p1`
- [スワップ 用のパーティションを作成した場合は、mkswap(8) で初期化してください: ](https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89#.E3.83.AC.E3.82.A4.E3.82.A2.E3.82.A6.E3.83.88.E4.BE.8B:~:text=mkfs.ext4%20/dev/root_partition-,%E3%82%B9%E3%83%AF%E3%83%83%E3%83%97%20%E7%94%A8%E3%81%AE%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E4%BD%9C%E6%88%90%E3%81%97%E3%81%9F%E5%A0%B4%E5%90%88%E3%81%AF%E3%80%81mkswap(8)%20%E3%81%A7%E5%88%9D%E6%9C%9F%E5%8C%96%E3%81%97%E3%81%A6%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84:,-%23%20mkswap%20/dev/swap_partition)
  - `mkswap /dev/nvme0n1p2`
- [ext4 ファイルシステムを /dev/root_partition に作成するには、以下のコマンドを実行: ](https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89#.E3.83.AC.E3.82.A4.E3.82.A2.E3.82.A6.E3.83.88.E4.BE.8B:~:text=%E4%BE%8B%E3%81%88%E3%81%B0%E3%80%81-,ext4%20%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%82%92%20/dev/root_partition%20%E3%81%AB%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B%E3%81%AB%E3%81%AF%E3%80%81%E4%BB%A5%E4%B8%8B%E3%81%AE%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%82%92%E5%AE%9F%E8%A1%8C:,-%23%20mkfs.ext4%20/dev/root_partition)
  - `mkfs.ext4 /dev/nvme0n1p3`
  - 一瞬固まるからビビる

## マウント

- root
  - `mount /dev/nvme0n1p3 /mnt`
- efi
  - `mount --mkdir /dev/nvme0n1p1 /mnt/boot`
- swap
  - `swapon /dev/nvme0n1p2`

- [ ] `mount`でnvme0n1p1とnvme0n1p3がマウントされているか確認

## インストール

- ミラーの選択
  - `/etc/pacman.d/mirrorlist`を編集して
  `Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch`
  を追記

- パッケージインストール
  - `pacstrap -K /mnt base linux linux-firmware networkmanager helix vim zsh`

## システム設定

- fstabの生成
  - `genfstab -U /mnt >> /mnt/etc/fstab`

- chroot
  - `arch-chroot /mnt`
  - `zsh`

これ以降はpacmanが使える

- タイムゾーン
  - `ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime`
  - `hwclock --systohc`

- ローカリゼーション
  - `helix /etc/vconsole.conf`（新規作成）
    - 必要ならば`KEYMAP=jp106`
  - `helix /etc/locale.gen`
    - `en_US.UTF-8 UTF-8`と`ja_JP.UTF-8 UTF-8`をアンコメント
  - `locale-gen`
  - `helix /etc/locale.conf`（新規作成）
    - `LANG=en_US.UTF-8`を記入

- ホストネーム設定
  - `/etc/hostname`にお好きな名前を記入

- ブートローダー
  - 無難にGRUB
  - `pacman -S grub efibootmgr os-prober`
  - `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`
    - なんかエラー吐いたらmount周りでミスっている可能性。1からやり直した方が早い。
  - GRUBいじったら[メイン設定ファイルの生成](https://wiki.archlinux.jp/index.php/GRUB#.E3.83.A1.E3.82.A4.E3.83.B3.E8.A8.AD.E5.AE.9A.E3.83.95.E3.82.A1.E3.82.A4.E3.83.AB.E3.81.AE.E7.94.9F.E6.88.90)
    - `grub-mkconfig -o /boot/grub/grub.cfg`

- micro code
  - `pacman -S intel-ucode`
  - `grub-mkconfig -o /boot/grub/grub.cfg`

- root password
  - `passwd`
  - 大事

- user passwd
  - `pacman -S sudo`
  - 一応`/etc/shells`にzshがいるか確認
  - `useradd -m -G wheel -s /bin/zsh <USERNAME>`
  - `passwd <USERNAME>`
  - `visudo`
    - `%wheel ALL=(ALL:ALL) ALL`のコメントアウトを解除（結構下の方にある）

## 再起動

- `exit`
  - chroot環境から抜ける
  - zshで作業していた場合、2回打つ。`arch-chroot /mnt ...`が表示されたらOK
- `reboot`

***

ここまでが一般的なインストール手順

ここから個人環境設定

***

再起動後、saltでログインするとzshの初期設定が開く。後でdotfileを入れるので、ここは`0`を選択。
この時点ではまだネットワークには接続できない。

## ネットワーク設定

- 入れ忘れていたら`sudo pacman -S networkmanager`
- `sudo systemctl enable NetworkManager`
- `sudo systemctl start NetworkManager`
- `nmcli device status`で使用したいDEVICEのSTATEが`connected`になっていることを確認
  - もしなっていなければ`nmcli device connect enp...`
- `ping archlinux.jp`で疎通確認

## AUR
- rustの用意
  - `sudo pacman -S rustup`
  - `rustup default stable`
  - `rustup update`
- `sudo pacman -S --needed base-devel git`
- `git clone https://aur.archlinux.org/paru.git`
- `cd paru`
- `makepkg -si`

結構時間かかる

## wayland環境構築

ぶちこめー
- `paru -S niri foot swaybg swaylock-effects wlogout fuzzel firefox`
  - `xdg-desktop-portal`は`xdg-desktop-portal-wlr`を選択
  - `jack`を聞かれたら`pipewire-jack`を選択
- これで一旦niriは起動するはず

## いつもの

- AURで入るやつ一括
  - `paru -S getnf noto-fonts-cjk noto-fonts-emoji starship yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick openssh lsd mako libnotify waybar swayidle fcitx5-im fcitx5-mozc greetd greetd-tuigreet alsa-utils sof-firmware`
  - この段階まで来たら、このguideにブラウザからアクセスできているはず
  - `sof-firmware`はLet's noteでスピーカーを認識させるために必要

- keyd
  - `git clone https://github.com/rvaiya/keyd`
  - `cd keyd`
  - `make && sudo make install`
  - `sudo systemctl enable --now keyd`

- sheldon
  - `cargo install sheldon`

- [swaybg](https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup)
  - `systemctl --user add-wants niri.service mako.service`
  - `systemctl --user add-wants niri.service waybar.service`
  - `hl ~/.config/systemd/user/swaybg.service`
  ```
  [Unit]
  PartOf=graphical-session.target
  After=graphical-session.target
  Requisite=graphical-session.target
  
  [Service]
  ExecStart=/usr/bin/swaybg -m fill -i "%h/.dotfiles/wallpaper.jpg"
  Restart=on-failure
  ```
  - `systemctl --user daemon-reload`
  - `systemctl --user add-wants niri.service swaybg.service`

- greetd
  - `systemctl enable greetd`

- dotfiles
  - まずgit cloneのためにsshを入れる
    - `ssh-keygen -t ed25519 -C "n.salt2000@gmail.com"`
    - `eval "$(ssh-agent -s)"`
    - `ssh-add ~/.ssh/id_ed25519`
    - githubに追加
  - 満を持して./link.sh
  - だいたい入るので一旦`reboot`

## 日本語入力
- `paru -S fcitx5-im fcitx5-mozc`
- `fcitx5-configtool`でToggle Input Methodにinsertを追加、Temporarily Toggle Input MethodのLeft Shiftを削除
  - これやらないとスペースバー押すたびに日英切り替わる

## 完了！
お疲れ様！

他にいつも使っているもの：

- Audio: `paru -S alsa-utils pipewire pipewire-pulse wireplumber`
- IDE: `geany`
- PDF: `zathura`
- Discord: `vesktop`
- ftp: `vsftpd`
- paint: `pinta`
- Network Tools:
  - `paru -S wget mtr traceroute nmap whois`
- cursor: (everforest-cursor-light)[https://github.com/talwat/everforest-cursors]
  - `mkdir .local/share/icons && wget -cO- https://github.com/talwat/everforest-cursors/releases/latest/download/everforest-cursors-variants.tar.bz2 && tar xfj - -C ~/.local/share/icons`

- FireWall: `nftables`
  - systemdで有効化
あとは大体Firefoxで事足りる
