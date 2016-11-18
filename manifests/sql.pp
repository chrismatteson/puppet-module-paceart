class paceart::sql (
  $mount_iso=true,
  $iso_drive='Q',
  $dbsource = 'http://care.dlservice.microsoft.com/dl/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/ExpressAndTools%2064BIT/SQLEXPRWT_x64_ENU.exe',
  $stagingowner='BUILTIN\Administrators',
  $admin_user = 'vagrant',
  $sa_pass = 'Secure_Pass!',
) {

  $filename = staging_parse($dbsource, 'filename')
  $installer = "${::staging_windir}\\${module_name}\\${filename}"
  staging::file { $filename:
    source => $dbsource,
  }

  acl { "${::staging_windir}\\${module_name}" :
    permissions => [
      {
        identity => 'Everyone',
        rights => [ 'full' ]
      },
      {
        identity => $stagingowner,
        rights => [ 'full' ]
      },
    ],
    require => Staging::File[$filename],
  }

  $extract = grep(["${installer}"], '.exe')
  $iso = grep(["${installer}"], '.iso')

  if empty($iso) == false {
    $installsource = "${iso_drive}:\\"
  }
  elsif empty($extract) {
    $installsource = $dbsource
  }
  else {
    $installsource = chop(chop(chop(chop($installer))))
  }

  class { 'paceart::sql::extract':
    installer => $installer,
    filename  => $filename,
    iso_drive => $iso_drive,
    require   => Acl["${::staging_windir}\\${module_name}"],
  }

  class { 'paceart::sql::sqlinstall':
    source      => $installsource,
    admin_user  => $admin_user,
    db_instance => 'Paceart_Database',
    sa_pass     => $sa_pass,
    db_name     => 'Paceart_Database',
    require     => Class['paceart::sql::extract'],
  }

  file { 'C:\tmp':
    ensure => directory,
  }

  file { 'C:\tmp\mcertreq.inf':
    ensure  => file,
    content => template('paceart/mcertreq.inf'),
    require => File['C:\tmp'],
  }

  exec { 'create csr':
    command     => 'C:\Windows\System32\certreq.exe -new C:\tmp\mcertreq.inf C:\tmp\certreq.mcertreq',
    refreshonly => true,
    subscribe   => File['C:\tmp\mcertreq.inf'],
  }
}
