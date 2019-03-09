# Class to install dependencies and build WordPress into `/src` and `/build`.
class core-dev::build () {
	exec { 'npm install':
		command => '/usr/bin/npm install',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
	}

	# Run grunt to build the project into /vagrant/wordpress-develop/build.
	exec { 'grunt build':
		command => '/usr/bin/grunt build',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => Exec['npm install'],
	}

	# Run grunt to build the project in situ within /vagrant/wordpress-develop/src.
	exec { 'grunt build --dev':
		command => '/usr/bin/grunt build --dev',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => Exec['npm install'],
	}

	# Symlink /build into the nginx root.
	file { '/vagrant/build':
		ensure => link,
		target => '/vagrant/wordpress-develop/build',
		notify => Service['nginx'],
		require => Exec['grunt build'],
	}

	# Symlink /src into the nginx root.
	file { '/vagrant/src':
		ensure => link,
		target => '/vagrant/wordpress-develop/src',
		notify => Service['nginx'],
		require => Exec['grunt build --dev'],
	}
}
