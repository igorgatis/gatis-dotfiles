This repo contains dotfiles for terminal tools such as bash, vim, git, etc. It
is managed using [yadm](https://yadm.io/) but it is not required.

Once I have `yadm` installed, I run:
```sh
yadm clone https://github.com/igorgatis/dotfiles.git
yadm checkout --force
```

To make changes, I set the following origin:
```sh
yadm remote remove origin
yadm remote add origin git@github.com:igorgatis/dotfiles.git
```
