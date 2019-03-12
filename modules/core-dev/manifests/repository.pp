include vcsrepo

# Class to prepare the Chassis box for WP core development.
class core-dev::repository (
	$config
) {
	# Ensure SVN is installed.
	package { 'subversion':
		ensure => 'present',
	}

	# Ignore wordpress-develop folder within the parent Chassis checkout.
	if $::parent_repository_exclude_file == 'present' {
		file_line { 'ignore wordpress-develop directory':
			path => '/vagrant/.git/info/exclude',
			line => 'wordpress-develop',
		}
		file_line { 'ignore src/ symlink':
			path => '/vagrant/.git/info/exclude',
			line => 'src',
		}
		file_line { 'ignore build/ symlink':
			path => '/vagrant/.git/info/exclude',
			line => 'build',
		}
	}

	# vcsrepo task may fail unless GitHub is listed in known_hosts.
	exec { 'Add github to known_hosts':
		command => '/usr/bin/ssh-keyscan -t rsa github.com >> /home/vagrant/.ssh/known_hosts',
		unless  => '/bin/grep -Fq "github.com" /home/vagrant/.ssh/known_hosts',
	}

	# A repository may exist in the Chassis root, or a repository directory
	# elsewhere on the host system may be mapped into the wordpress-develop
	# directory using synced_folders. Once a repository is present, we cannot
	# make as many assumptions about how the user wishes to manage that repo;
	# They may be using SVN, or have defined their own remotes, etcetera.
	# We therefore only try to clone and setup a repository if there is not
	# already a checkout of any sort in `/vagrant/wordpress-develop`.
	unless $::core_dev_repository == present {
		# Permit a develop repo mirror remote to be specified in config.local.yaml.
		if ( !empty($config['core-dev']) and !empty($config['core-dev']['mirror']) ) {
			$repository_remotes = {
				'origin' => 'git://develop.git.wordpress.org/',
				'mirror' => $config['core-dev']['mirror']
			}
		} else {
			$repository_remotes = { 'origin' => 'git://develop.git.wordpress.org/' }
		}

		vcsrepo { '/vagrant/wordpress-develop':
			ensure   => present,
			provider => git,
			remote   => 'origin',
			source   => $repository_remotes,
			user     => 'vagrant',
		}
	}
}
