include vcsrepo

# Class to prepare the Chassis box for WP core development.
class core-dev::repository (
	$config
) {
	# Ensure SVN is installed.
	package { 'subversion':
		ensure => 'present',
	}

	# Validate a .git/info/exclude file exists for the Chassis checkout.
	exec { 'git_exclude_exists':
		command => '/bin/false',
		unless  => '/usr/bin/test -e /vagrant/.git/info/exclude',
	}

	# Ignore wordpress-develop folder within the parent Chassis checkout.
	file_line { 'ignore wordpress-develop directory':
		path    => '/vagrant/.git/info/exclude',
		line    => 'wordpress-develop',
		require => Exec['git_exclude_exists'],
	}

	# Ensure the repository destination directory exists.
	file { '/vagrant/wordpress-develop':
		ensure => 'directory',
	}

	# vcsrepo task may fail unless GitHub is listed in known_hosts.
	exec { 'Add github to known_hosts':
		command => '/usr/bin/ssh-keyscan -t rsa github.com >> /home/vagrant/.ssh/known_hosts',
		unless  => '/bin/grep -Fxq "github.com" /home/vagrant/.ssh/known_hosts',
	}

	# Test whether a checkout already exists in the target location.
	exec { 'wp_dev_checkout_missing':
		command => '/bin/true',
		unless  => '/usr/bin/test -f /vagrant/wordpress-develop/package.json',
	}

	# Permit a develop repo mirror remote to be specified in config.local.yaml.
	if ( !empty($config['core-dev']) and !empty($config['core-dev']['mirror']) ) {
		$repository_remotes = {
			'origin' => 'git://develop.git.wordpress.org/',
			'mirror' => $config['core-dev']['mirror']
		}
	} else {
		$repository_remotes = { 'origin' => 'git://develop.git.wordpress.org/' }
	}

	# Otherwise, if no repo is present, check out the repository and set up remotes.
	vcsrepo { '/vagrant/wordpress-develop':
		ensure   => present,
		provider => git,
		remote   => 'origin',
		source   => $repository_remotes,
		user     => 'vagrant',
		require  => Exec['wp_dev_checkout_missing'],
	}
}
