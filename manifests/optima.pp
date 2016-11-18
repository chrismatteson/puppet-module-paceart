class paceart::optima (
  $optimasource,
) {

  contain paceart::iis

  $optimafilename = staging_parse($dbmanagersource, 'filename')
  $optimainstaller = "${::staging_windir}\\${module_name}\\${optimafilename}"
  staging::file { $optimafilename:
    source => $optimasource,
  }

  package { $optimafilename:
    ensure          => installed,
    provider        => 'windows',
    source          => $optimainstaller,
    install_options => [],
  }

}
