# Install and configure our WordPress site.
define core-dev::site (
	$location,
	$sitename,

	$database,
	$database_user = 'wordpress',
	$database_password = 'vagrantpassword',
	$database_host = 'localhost',
	$database_prefix = 'wp_',

	$admin_user,
	$admin_email,
	$admin_password,
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
		require        => [
			File["${ location }/wp-config.php"],
			Mysql::Db[$database],
		],
	}
}
