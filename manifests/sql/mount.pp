# This class is used to mount an ISO containing the SQL Server 2014 Code.
class paceart::sql::mount (
  $iso,
  $iso_drive,
) {

  $iso_path = "${::staging_windir}\\${module_name}\\${iso}"

  mount_iso { $iso_path :
    drive_letter => $iso_drive,
    before       => Class['paceart::sql'],
  }

}
