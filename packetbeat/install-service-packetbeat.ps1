# Delete and stop the service if it already exists.
if (Get-Service packetbeat -ErrorAction SilentlyContinue) {
  Stop-Service packetbeat
  (Get-Service packetbeat).WaitForStatus('Stopped')
  Start-Sleep -s 1
  sc.exe delete packetbeat
}

$workdir = Split-Path $MyInvocation.MyCommand.Path

# Create the new service.
New-Service -name packetbeat `
  -displayName Packetbeat `
  -binaryPathName "`"$workdir\packetbeat.exe`" --environment=windows_service -c `"$workdir\packetbeat.yml`" --path.home `"$workdir`" --path.data `"$env:PROGRAMDATA\packetbeat`" --path.logs `"$env:PROGRAMDATA\packetbeat\logs`" -E logging.files.redirect_stderr=true"

# Attempt to set the service to delayed start using sc config.
Try {
  Start-Process -FilePath sc.exe -ArgumentList 'config packetbeat start= delayed-auto'
}
Catch { Write-Host -f red "An error occurred setting the service to delayed start." }
