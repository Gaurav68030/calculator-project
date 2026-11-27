#!/bin/bash
# Q3 - Linux user management for the Hdfc_Bank-ClientApp team. Run as root (sudo bash ...).
# On Amazon Linux first run:  sudo yum install -y zip unzip
set -x
APP=/opt/Hdfc_Bank-ClientApp
mkdir -p $APP

# Groups + existing team (Team A developers, Team B testers)
groupadd developer
groupadd tester
for u in developer1 developer2 developer3; do useradd -m -s /bin/bash -G developer $u; done
for u in tester1 tester2;                  do useradd -m -s /bin/bash -G tester $u;    done
getent group developer; getent group tester

# (i) New user Developer4 joins and is added to the Developer group
useradd -m -s /bin/bash -G developer developer4
passwd developer4            # set a password interactively
id developer4
getent group developer

# (ii) Developer3 leaves: remove account, home directory and mail spool completely
pkill -u developer3 || true  # stop running processes
userdel -r developer3        # -r removes home dir and mail spool
id developer3                # should say: no such user
ls -ld /home/developer3      # should say: No such file or directory
grep developer3 /etc/passwd /etc/shadow || echo "developer3 fully removed"

# (iii) Hdfc-Pack.zip : display contents, then delete a file from it
cd $APP
unzip -l Hdfc-Pack.zip           # display content of the zip
zip -d Hdfc-Pack.zip server.log  # delete one file inside the zip
unzip -l Hdfc-Pack.zip           # verify
