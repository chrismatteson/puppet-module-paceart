class paceart::prereqs (
  $mount_iso,
  $iso_drive,
  $dbsource,
  $stagingowner,
  $admin_user,
  $sa_pass,
) {

  windowsfeature { 'IIS_APPSERVER':
    feature_name => [
      'Web-Server',
      'Net-Framework-45-ASPNET',
      'Application-Server',
      'AS-NET-Framework',
      'AS-Web-Support',
      'Web-Mgmt-Tools',
      'Web-Mgmt-Console',
      'Web-Scripting-Tools',
      'Web-WebServer',
      'Web-App-Dev',
      'Web-Asp-Net45',
      'Web-ISAPI-Ext',
      'Web-ISAPI-Filter',
      'Web-Net-Ext45',
      'Web-Common-Http',
      'Web-Default-Doc',
      'Web-Dir-Browsing',
      'Web-Http-Errors',
      'Web-Http-Redirect',
      'Web-Static-Content',
      'Web-Health',
      'Web-Http-Logging',
      'Web-Log-Libraries',
      'Web-Request-Monitor',
      'Web-Stat-Compression',
      'Web-Dyn-Compression',
      'Web-Security',
      'Web-Basic-Auth',
      'Web-Cert-Auth',
      'Web-Client-Auth',
      'Web-Digest-Auth',
      'Web-Filtering',
      'Web-IP-Security',
      'Web-Url-Auth',
      'Web-Windows-Auth',
    ]
  }

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

  class { 'paceart::extract':
    installer => $installer,
    filename  => $filename,
    iso_drive => $iso_drive,
    require   => Acl["${::staging_windir}\\${module_name}"],
  }

  class { 'paceart::sql':
    source      => $source,
    admin_user  => $admin_user,
    db_instance => 'Paceart_Database',
    sa_pass     => $sa_pass,
    db_name     => 'Paceart_Database',
    require     => Class['paceart::extract'],
  }

}
