# Install and configure our WordPress site.
define core-dev::site (
	$database,
	$database_user = 'root',
	$database_password = 'password',
	$database_host = 'localhost',
	$admin_user,
	$admin_email,
	$admin_password,

	$location,
	$sitename,
) {
	mysql::db { $database:
		user     => $database_user,
		password => $database_password,
		host     => $database_host,
		grant    => ['all'],
	}

	file { "${ location }/wp-config.php":
		content => template('core-dev/wp-config.php.erb'),
	}

	wp::site { $name:
		url            => "http://${name}/",
		sitename       => $sitename,
		location       => $location,
		admin_user     => $admin_user,
		admin_email    => $admin_email,
		admin_password => $admin_password,
		require => [
			Class['chassis::php'],
			Mysql::Db[$database],
		]
	}
}
