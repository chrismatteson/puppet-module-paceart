class paceart::install (
  $dbmanagersource,
  $optimasource,
) {

  $dbfilename = staging_parse($dbmanagersource, 'filename')
  $dbinstaller = "${::staging_windir}\\${module_name}\\${dbfilename}"
  staging::file { $dbfilename:
    source => $dbmanagersource,
  }
  $optimafilename = staging_parse($dbmanagersource, 'filename')
  $optimainstaller = "${::staging_windir}\\${module_name}\\${optimafilename}"
  staging::file { $optimafilename:
    source => $optimasource,
  }

  package { $dbfilename:
    ensure          => installed,
    provider        => 'windows',
    source          => $dbinstaller,
    install_options => [],
  }
  package { $optimafilename:
    ensure          => installed,
    provider        => 'windows',
    source          => $optimainstaller,
    install_options => [],
  }

}
