$started = $false
$connectedTo = ""

While ($true) {
    Start-Sleep -Seconds 30

    $hll = Get-Process HLL-Win64-Shipping -ErrorAction SilentlyContinue

    if (!(Test-Path "C:\Users\$env:username\Documents\server.txt")) {
        if ($started) {
            Write-Host "Killing HLL"
            $hll.CloseMainWindow()

            Start-Sleep -Seconds 5
            if (!$hll.HasExited) {
                $hll | Stop-Process -Force
                Start-Sleep -Seconds 15
            }

            Start-Sleep -Seconds 120

            $started = $false
        }

        continue
    }
    
    $server = Get-Content "C:\Users\$env:username\Documents\server.txt" 

    if ($started) {
        if (!$hll) {
            $started = $false
            Start-Sleep -Seconds 15
            continue
        }

        if ($server -ne $connectedTo) {
            Write-Host "Switching server"
            start $server
            $connectedTo = $server
        }

        continue
    }

    Write-Host "Starting HLL"

    start $server
    Start-Sleep -Seconds 60
    start $server

    $started = $true
    $connectedTo = $server
}