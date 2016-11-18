# puppet-module-paceart

This is a puppet module to install and manage Paceart.  The
current version will is capable of installing sql server and
IIS either on the same box or seperate boxes.  Once a silent
Paceart installer is available it will be easily extended to
complete the Paceart installation.

This module utilizes several other modules which will need to
be installed before hand:

puppetlabs/stdlib
puppetlabs/acl
puppetlabs/reboot
puppetlabs/mount_iso
nanliu/staging
puppetlabs/sqlserver (puppet enterprise only)
puppet/windowsfeature
