sudo pacman -S --needed - < packages/pkglist-repo.txt
for x in $(< packages/pkglist-aur.txt); do paru -S $x; done