# Class to install dependencies and build WordPress into `/src` and `/build`.
class core_dev::build {
	exec { 'upgrade npm':
		command => '/usr/bin/npm install -g npm',
		user    => 'root',
		require => Class['npm'],
	}

	exec { 'npm install':
		command => '/usr/bin/npm install',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		timeout => 0,
		require => [
			Exec['upgrade npm'],
			Class['core_dev::repository'],
		],
		creates => '/vagrant/wordpress-develop/node_modules',
	}

	# Run grunt to build the project.
	exec { 'grunt build --dev':
		command => '/usr/bin/npm run build:dev',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => [
			Class['grunt'],
			Exec['npm install'],
			Class['core_dev::repository'],
		],
		creates => '/vagrant/wordpress-develop/src/wp-includes/js',
	}

	exec { 'grunt build':
		command => '/usr/bin/npm run build',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => [
			Class['grunt'],
			Exec['npm install'],
			Class['core_dev::repository'],
		],
		creates => '/vagrant/wordpress-develop/build/wp-includes/js',
	}
}
