```sh
# create a user with sudo rights
adduser weasel
usermod -aG sudo weasel

# generate and install ssh key
ssh-keygen -t ed25519 -C dx-key
ssh-copy-id -i ~/.ssh/id_ed25519.pub weasel@teh.weasel.ai

# disable password login
# /etc/ssh/sshd_config
PasswordAutherntication no

# check disabled password login
sudo systemctl reload ssh
ssh weasel@teh.weasel.ai -o PubkeyAuthentication=no

# /etc/hosts
# ip fqdn hostname
hostnamectl set-hostname <hostname>
hostname --fqdn
dnsdomainname

# timezone
sudo timedatectl set-timezone Europe/Riga

# owner
sudo chown -cR weasel:weasel /opt/teh-lv

# login as root
sudo su -

# last login attempts
w
last -a
lastb -adF

# command history
su <user>
history

# services
journalctl

# processes and network
htop
top
ps -axu
iftop
netstat -la

# disk space
ncdu
dff
duu
t5
```

```sh
# apt
sudo apt update
sudo apt upgrade
sudo apt install \
  git zip unzip curl wget mosh tmux \
  tree lnav bat sqlite3 gettext \
  htop iftop ncdu psmisc \
  gcc python3-dev

# snap
sudo apt install snapd
sudo snap install core
sudo snap install --beta nvim --classic
snap install --classic helix

# config
git clone git@github.com:dv1x3r/config.git ~/source/config
git clone https://github.com/gpakosz/.tmux.git ~/.tmux

# bat
mkdir ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

# tmux
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.tmux/.tmux.conf.local ~/.tmux.conf.local

# nvim
mkdir -p ~/.config/nvim
ln -s ~/source/config/dotfiles/nvim.init.lua ~/.config/nvim/init.lua

# helix
mkdir -p ~/.config/helix
ln -s ~/source/config/dotfiles/helix.config.toml ~/.config/helix/config.toml
ln -s ~/source/config/dotfiles/helix.languages.toml ~/.config/helix/languages.toml
```

```sh
# poetry
curl -sSL https://install.python-poetry.org | python3 -

# nginx
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
# 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx
sudo apt update
sudo apt install nginx
sudo systemctl status nginx

# postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install postgresql-15
sudo systemctl status postgresql

# certbot
sudo apt install snapd && sudo snap install core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```
