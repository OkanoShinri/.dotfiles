# zsh
sudo apt update
sudo apt install -y zsh lsd software-properties-common parrot-desktop-i3 rofi fonts-noto-cjk fonts-noto-color-emoji

ZSH_PATH=$(which zsh)
chsh -s "$ZSH_PATH"

# nerd-fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip
unzip -d FiraCode FiraCode.zip
sudo cp -r FiraCode /usr/share/fonts/truetype
fc-cache -fv

# keyd
git clone https://github.com/rvaiya/keyd
cd keyd
make && sudo make install
sudo systemctl enable --now keyd
cd ../
rm -rf keyd

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# sheldon
cargo install sheldon

# starship
curl -sS https://starship.rs/install.sh | sh

# yazi
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
rustup update
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked
