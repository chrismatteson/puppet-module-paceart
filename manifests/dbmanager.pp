class paceart::dbmanager (
  $dbmanagersource,
) {

  contain paceart::sql

  $dbfilename = staging_parse($dbmanagersource, 'filename')
  $dbinstaller = "${::staging_windir}\\${module_name}\\${dbfilename}"
  staging::file { $dbfilename:
    source => $dbmanagersource,
  }

  package { $dbfilename:
    ensure          => installed,
    provider        => 'windows',
    source          => $dbinstaller,
    install_options => [],
  }

}
