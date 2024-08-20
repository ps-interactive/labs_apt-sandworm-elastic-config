# Delete and stop the service if it already exists.
if (Get-Service packetbeat -ErrorAction SilentlyContinue) {
  Stop-Service packetbeat
  (Get-Service packetbeat).WaitForStatus('Stopped')
  Start-Sleep -s 1
  sc.exe delete packetbeat
}
