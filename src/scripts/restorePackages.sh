sudo pacman -S --needed - < archConfigs/packages/pkglist-repo.txt
for x in $(< archConfigs/packages/pkglist-aur.txt); do paru -S $x; done