sudo pacman -S --needed - < archConfigs/packages/pkglist-repo.txt
for x in $(< archConfigs/packages/pkglist-aur.txt); do paru -S $x; done
sudo pacman -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
while read snap; do
    sudo snap install "$snap"
done < archConfigs/packages/snap-package-list.txt
