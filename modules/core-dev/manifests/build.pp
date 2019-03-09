# Class to install dependencies and build WordPress into `/src` and `/build`.
define core-dev::build (
	$grunt_command,
) {
	# Run grunt to build the project.
	exec { "grunt ${ grunt_command }":
		command => "/usr/bin/grunt ${ grunt_command }",
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => Class['grunt'],
	}

	# Symlink /build into the nginx root.
	file { "/vagrant/${ name }/":
		ensure => link,
		target => "/vagrant/wordpress-develop/${ name }",
		notify => Service['nginx'],
		require => Exec[ "grunt ${ grunt_command }" ],
	}
}
