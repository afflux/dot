sudo apt install --no-install-recommends zsh vim-nox vim-pathogen
# on desktop, also install:
# lubuntu-desktop fonts-dejavu qlipper lximage-qt qlipper xss-lock
git init && git remote add origin https://github.com/afflux/dot && git fetch origin master
git checkout master && git submodule init && git submodule update
