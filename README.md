# WordPress Core Development Extension for Chassis

This extension configures a [Chassis](http://chassis.io) virtual machine for WordPress core development.

## Quick Start

Clone Chassis into the directory of your choice with this command:

```bash
# You may change core-dev-vm to the folder name of your choice.
git clone --recursive https://github.com/Chassis/Chassis core-dev-vm
```

Next, create an empty `config.local.yaml` file in the root of the Chassis checkout, and paste in these options:

```yaml
# Specify the .local hostname of your choice.
hosts:
  - core.local

paths:
  # Use Chassis paths as normal,
  content: content
  base: .
  # Except use your checkout for the WordPress directory. To switch
  # between /src and /build, edit this line then run `vagrant provision`.
  wp: wordpress-develop/src

# Instruct Chassis to use this extension.
extensions:
  - core_dev

# Set a PHPUnit version.
phpunit:
  version: 7.5
```
(Other [Chassis configuration options](http://docs.chassis.io/en/latest/config/) may be used as normal, so long as the above paths are provided correctly.)

After creating this file, run `vagrant up` to initialize the virtual machine.

Once provisioned, your new WordPress development site will be available at [core.local](http://core.local), and you may login at [core.local/wp](http://core.local/wp) with the username `admin` and password `password`. The site will be using the `/src` build of the `wordpress-develop` repository, newly cloned on your host system at `[Chassis root]/wordpress-develop` and available as `/vagrant/wordpress-develop` inside the virtual machine.

To switch the site to use the **`build`** version of the site instead, edit the `wp:` line in your `config.local.yaml` to end in "build" instead of "src" then run `vagrant provision`.

### A Note on the WordPress Build Process

**PLEASE NOTE:** The provisioner will run `npm install` and `grunt` for you after cloning the repository, so you can get started right away. However, subsequent `npm` or `grunt` commands are left to you, the developer. If you have made changes to the code and are using the `/src` directory, run `grunt build --dev` to rebuild the project into the `/src` directory if you do not see your changes. If you are using `/build`, run `grunt` or `grunt build`. See the [WordPress core contributor handbook](https://make.wordpress.org/core/handbook/) for more information on building & developing WordPress.

(Commands may be run either within the Chassis VM — _e.g._ `vagrant ssh -c 'cd /vagrant/wordpress-develop && grunt build --dev'` — or else you may run `npm install` within your host operating system and run the builds with `grunt` locally on your machine. Builds may be faster on the host system than within the VM, but using the VM's versions of Node and Grunt means you need less tooling installed outside Chassis.)

## Use An Existing WordPress Checkout

You may already have `wordpress-develop` checkout out locally using `git` or `svn`. You may choose to use this repository within your VM instead of cloning a fresh copy by mapping the directory into your virtual machine using `synced_folders`.

As an example, imagine that you have your Chassis box checked out in `~/core-vm`, and your WordPress development repository checked out in `~/wordpress-develop`. In your `config.local.yaml` file inside the Chassis directory, tell Chassis to sync the folder `../wordpress-develop` into the VM as `/vagrant/wordpress-develop`.

```yml
hosts:
  - core.local

paths:
  # Use the normal Chassis directory structure,
  content: content
  base: .
  # Except use your checkout for the WordPress directory. To switch
  # between /src and /build, edit this line then run `vagrant provision`.
  wp: ../wordpress-develop/src

synced_folders:
  # This will allow you to run the WP unit tests against your existing
  # wordpress-develop repository checkout.
  ../wordpress-develop: /vagrant/wordpress-develop

extensions:
  - core_dev

```

## Running the Unit Tests

From the host machine, use `vagrant ssh` to run the unit tests inside the virtual machine:

```bash
vagrant ssh -c 'cd /vagrant/wordpress-develop && phpunit'
```

To run a particular suite of tests, for example just the tests defined within the `WP_Test_REST_Posts_Controller` class, provide that class name with `--filter`:

```bash
vagrant ssh -c 'cd /vagrant/wordpress-develop && phpunit --filter WP_Test_REST_Posts_Controller'
```

The best version of PHPUnit to install depends on the version of PHP you are using:

* PHP 5.6: PHPUnit 4.8
* PHP 7.0: PHPUnit 6.5
* PHP 7.1+: PHPUnit 7.5


## Extension Options

Define a `core_dev` key in your `config.local.yaml` to configure this extension.

```yml
# config.local.yaml

core-dev:
    # If the wordpress-develop repo is not already checked out within the
    # Chassis root directory, this extension will clone a fresh copy for
    # you. To add a "mirror" remote pointing to your own fork of the develop
    # repo, specify your fork's address in the `mirror` option.
    mirror: git@github.com:{your GitHub name}/wordpress-develop.git
```


## Recommended Extensions

There are some other useful Chassis extensions that can help to make core contributions easier. We recommend the following extensions:

* [Imagick](https://github.com/Chassis/Imagick) - Imagick speeds up image processing and allows permitting better testing of media component work.
* [Intl](https://github.com/Chassis/intl) - A Chassis extension to install and configure Intl on your server.
* [BC Math](https://github.com/Chassis/BCMath) - BCMath provides arbitrary precision mathematics.
* [MailHog](https://github.com/Chassis/MailHog) - Catch all the emails WordPress sends while you're developing using Chassis!
* [XDebug](https://github.com/Chassis/Xdebug) - Xdebug is an extension for PHP to assist with debugging and development. 
* [WP_CLI](https://github.com/Chassis/WP_CLI) - A Chassis extension to automate the installation of WP-CLI packages.
* [Whoops](https://github.com/Chassis/Whoops) - A Chassis extension to install Whoops for PHP error reporting.
* [Debugging](https://github.com/Chassis/Debugging) - A Chassis extension to install and activate common WordPress plugins used for debugging during development.

