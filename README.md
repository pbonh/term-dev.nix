Role Name
=========

Terminal Development Environment Powered by Nix/Ansible

Installation
------------

Configure Git/SSH
```bash
wget -O - https://raw.githubusercontent.com/pbonh/term-dev.nix/main/scripts/bootstrap_gitssh.sh | bash
```

Setup `.envrc` File(Example)
```bash
touch .envrc
ln -s .envrc .env
echo "DOTFILES_TASK_PRELUDE=python" > .envrc
```

License
-------

BSD

Author Information
------------------

Phillip Bonhomme
