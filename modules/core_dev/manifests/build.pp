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

	# Run npm run build:dev to build the project.
	exec { 'npm run build:dev':
		command => '/usr/bin/npm run build:dev',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => [
			Exec['npm install'],
			Class['core_dev::repository'],
		],
		creates => '/vagrant/wordpress-develop/src/wp-includes/js',
	}
}
