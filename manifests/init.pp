class paceart (
  $mount_iso=true,
  $iso_drive='Q',
  $source = 'http://care.dlservice.microsoft.com/dl/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/ExpressAndTools%2064BIT/SQLEXPRWT_x64_ENU.exe',
  $stagingowner='BUILTIN\Administrators',
  $admin_user => 'vagrant',
  $sa_pass = 'Secure_Pass!',
  $dbmanagersource = '',
  $optimasource = '',
) {

  class { 'paceart::prereqs':
    mount_iso    => $mount_iso,
    iso_drive    => $iso_drive,
    source       => $source,
    stagingowner => $stagingowner,
    admin_user   => $admin_user,
    sa_pass => $sa_pass,
  }

  class { 'paceart::install':
    dbmanagersource => $dbmanagersource,
    optimasource    => $optimasource,
  }

}
