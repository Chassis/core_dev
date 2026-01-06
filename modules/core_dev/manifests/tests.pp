# Set the WordPress database test constants.
#
# @param database The name of the WordPress test database
# @param database_user The database user for WordPress tests
# @param database_password The database password for WordPress tests
# @param database_host The database host for WordPress tests
# @param database_prefix The table prefix for WordPress tests
# @param tests_domain The domain for WordPress tests
# @param tests_email The admin email for WordPress tests
# @param tests_title The site title for WordPress tests
class core_dev::tests (
  String $database = 'wordpress_tests',
  String $database_user = 'wordpress',
  String $database_password = 'vagrantpassword',
  String $database_host = 'localhost',
  String $database_prefix = 'wptests_',

  String $tests_domain = 'example.org',
  String $tests_email = 'admin@example.org',
  String $tests_title = 'Test Blog',
) {
  mysql::db { $database:
    user     => $database_user,
    password => $database_password,
    host     => $database_host,
    grant    => ['all'],
  }

  file { '/vagrant/wordpress-develop/wp-tests-config.php':
    content => template('core_dev/wp-tests-config.php.erb'),
    require => Class['core_dev::repository'],
  }

  # See https://make.wordpress.org/core/handbook/contribute/git/#unit-tests
  vcsrepo { '/vagrant/wordpress-develop/tests/phpunit/data/plugins/wordpress-importer':
    ensure   => present,
    provider => svn,
    source   => 'https://plugins.svn.wordpress.org/wordpress-importer/trunk/',
    user     => 'vagrant',
    require  => Class['core_dev::repository'],
  }
}
