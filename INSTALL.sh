sudo apt install --no-install-recommends zsh vim-nox vim-pathogen powerline
git init && git remote add origin https://github.com/afflux/dot && git fetch origin master
git checkout master && git submodule init && git submodule update
