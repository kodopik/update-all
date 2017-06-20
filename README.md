# update-all
One to rule them all… One command for update, upgrade, autoremove and autoclean Ubuntu software

What this script actually does:
```
apt update \
     && apt list --upgradable \
     && apt full-upgrade [-y] \
     && apt autoremove [-y] \
     && apt autoclean
```

# Installation:
```
sudo make install
```
