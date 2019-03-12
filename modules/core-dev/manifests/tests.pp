include vcsrepo

define core-dev::tests (
	$database = 'wordpress_tests',
	$database_user = 'wordpress',
	$database_password = 'vagrantpassword',
	$database_host = 'localhost',
	$database_prefix = 'wptests_',

	$tests_domain = 'example.org',
	$tests_email = 'admin@example.org',
	$tests_title = 'Test Blog',
) {
	mysql::db { $database:
		user     => $database_user,
		password => $database_password,
		host     => $database_host,
		grant    => ['all'],
	}

	file { '/vagrant/wordpress-develop/wp-tests-config.php':
		content => template('core-dev/wp-tests-config.php.erb'),
	}

	# See
	vcsrepo { '/vagrant/wordpress-develop/tests/phpunit/data/plugins/wordpress-importer':
		ensure   => present,
		provider => svn,
		source   => 'https://plugins.svn.wordpress.org/wordpress-importer/trunk/',
		user     => 'vagrant',
	}

	# wp::plugin { 'wordpress-importer':
	# 	# Necessary for the tests to pass but need not be installed
	# 	ensure   => installed,
	# 	location => '/vagrant/wordpress-develop/src',
	# 	require  => Class['wp'],
	# }
}
