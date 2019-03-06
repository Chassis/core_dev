# Example Puppet class!
#
# Chassis automatically loads your class, and passes $config in, which is an
# array representing the YAML-based configuration. You can use this to access
# Chassis configuration, or your own custom keys. In this demo, we've used
# `show_example`. To test it out, add the following to your config:
#
#     show_example: hello!
#
# The entirety of your behaviour should be wrapped inside this class.
#
# ***********************************
#          IMPORTANT NOTES:
#
# * Your module directory must be named the same as the extension.
# * Your class must be in init.pp, and named the same as the extension.
#
# ***********************************

class core-dev (
	$config
) {
	# Create vagrant-core.local
	chassis::site { 'vagrant-core.local':
		location          => '/vagrant/wordpress-develop/src',
		wpdir             => '/vagrant/wordpress-develop/src',
		contentdir        => '/vagrant/wordpress-develop/src/wp-content',
		hosts             => ['vagrant-core.local'],
		database          => 'vagrantcore_local',
		database_user     => $config[database][user],
		database_password => $config[database][password],
		admin_user        => $config[admin][user],
		admin_email       => $config[admin][email],
		admin_password    => $config[admin][password],
		sitename          => $config[site][name],
		require => [
			Class['chassis::php'],
			Package['git-core'],
			Class['mysql::server'],
		]
	}

# 	package { 'php-package-name':
# 		ensure  => $package
# 	}
#
# 	file { '/tmp/randomfile.ini':
# 		ensure => $file,
# 		content => '# Example content',
# 		force  => true
# 	}
}
