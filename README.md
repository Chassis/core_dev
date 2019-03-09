# wordpress-core-development
A Chassis extension for WordPress Core development.

## Extension Options

Define a `core-dev` key in your `config.local.yaml` to configure this extension.

```yml
# config.local.yaml

core-dev:
    # If the wordpress-develop repo is not already checked out within the
    # Chassis root directory, this extension will clone a fresh copy for
    # you. To add a "mirror" remote pointing to your own fork of the develop
    # repo, specify your fork's address in the `mirror` option.
    mirror: git@github.com:{your GitHub name}/wordpress-develop.git
```

## Use An Existing WordPress Checkout

You may already have `wordpress-develop` checkout out locally using `git` or `svn`. You may choose to use this repository within your VM instead of cloning a fresh copy by mapping the directory into your virtual machine using `synced_folders`.

As an example, imagine that you have your Chassis box checked out in `~/core-vm`, and your WordPress development repository checked out in `~/wp-develop`. In your `config.local.yaml` file inside the Chassis directory, tell Chassis to sync the folder `../wp-develop` into the VM as `/vagrant/wordpress-develop`.

```yml
# config.local.yaml

synced_folders:
    ../wp-develop: /vagrant/wordpress-develop
```