# smg-conso.vm bootstrap
Bootstrap Script la-cuna-icu server

On a new server (Windows Hyper-v/Linux podman/ NOT on Linux Hyper-V) you need to open a console terminal and download and run this script from /tmp as root

```bash
cd tmp
wget https://robertt-smg.github.io/ansible-bootstrap/b.sh
SERVERNAME=server1 DOMAIN=smg-conso.vm bash b.sh
```
# Windows
```bash
md c:\batch

start https://robertt-smg.github.io/ansible-bootstrap/w.cmd
```	
Save file in c:\batch
Open an elevated cmd.exe
and run c:\batch\w.cmd OK

