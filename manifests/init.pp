# init.pp

class r (
  $devel          = false,
  $package_ensure = installed,
) {

  case $::osfamily {
    'Debian': {
      package { 'r-base': ensure => $package_ensure }
    }
    'RedHat': {
      package { 'R-core': ensure => $package_ensure }

      if $devel {
        package { 'R-core-devel': ensure => $package_ensure }
      }
    }
    'windows': {
      # Choco package does not install static version and does not add R to PATH
      exec { 'Install R Windows':
        command  => template('r/windows_install_r.ps1.erb'),
        provider => powershell,
        unless   => "if(Test-Path \"\${Env:ProgramFiles}\\R\\R-*\\bin\\R.exe\"){exit 0}else{exit 1}",
      }
    }
    default: { fail("Not supported on osfamily ${::osfamily}") }
  }

}
