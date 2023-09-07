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
sudo apt update && sudo apt upgrade
sudo apt install \
  git zip unzip curl wget mosh tmux \
  tree lnav bat sqlite3 gettext \
  htop iftop ncdu psmisc \
  gcc python3-dev

# snap
sudo apt install snapd && sudo snap install core
sudo snap install --beta nvim --classic
sudo snap install --classic helix

# poetry
curl -sSL https://install.python-poetry.org | python3 -

# config
git clone git@github.com:dv1x3r/.dotconfig.git ~/.dotconfig
git clone https://github.com/gpakosz/.tmux.git ~/.tmux

# bat
mkdir ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

# tmux
ln -s ~/.tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.dotconfig/dotfiles/.tmux.conf.local ~/.tmux.conf.local

# nvim
mkdir -p ~/.config/nvim
ln -s ~/.dotconfig/dotfiles/nvim.init.lua ~/.config/nvim/init.lua

# helix
mkdir -p ~/.config/helix
ln -s ~/.dotconfig/dotfiles/helix.config.toml ~/.config/helix/config.toml
ln -s ~/.dotconfig/dotfiles/helix.languages.toml ~/.config/helix/languages.toml
```

```sh
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

# certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx
```

```sh
# postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update && sudo apt install postgresql-15
sudo systemctl status postgresql

# configure
sudo systemctl status postgresql
sudo systemctl start postgresql
sudo -u postgres psql

# \l  - list databases
# \c  - test switch database
# \dt - list tables

CREATE DATABASE teh_db TEMPLATE=template0 ENCODING 'UTF-8' LC_COLLATE 'ru_RU.UTF-8' LC_CTYPE 'ru_RU.UTF-8';
CREATE USER teh WITH PASSWORD 'password';
ALTER ROLE teh SET client_encoding TO 'utf8';
ALTER ROLE teh SET default_transaction_isolation TO 'read committed';
ALTER ROLE teh SET timezone TO 'Europe/Riga';
\c teh_db
CREATE SCHEMA teh AUTHORIZATION teh;
GRANT CREATE ON DATABASE "teh_db" TO teh;

# /etc/postgresql/15/main/postgresql.conf
# listen_addresses = '*'

# /etc/postgresql/15/main/pg_hba.conf
# host    all             teh             0.0.0.0/0               scram-sha-256
# host    all             teh             ::/0                    scram-sha-256

# postgres backup
pg_dump -d teh -f teh_backup.sql
```

