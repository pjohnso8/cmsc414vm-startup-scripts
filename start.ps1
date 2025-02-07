# Start the VM via QEMU (runs in the background)
Start-Process -FilePath "qemu-system-x86_64.exe" -ArgumentList "-accel tcg -m 2G -drive if=virtio,format=qcow2,file=cmsc414.qcow2 -nic user,model=virtio,hostfwd=tcp:127.0.0.1:41422-:22" -NoNewWindow

# Define the VM host and port for SSH connection
$VMHost = "127.0.0.1"
$Port = 41422

Write-Host "Waiting for SSH port $Port on $VMHost..."

function Test-PortOpen {
    param(
        [string]$HostName,
        [int]$Port
    )
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $asyncResult = $client.BeginConnect($HostName, $Port, $null, $null)
        $wait = $asyncResult.AsyncWaitHandle.WaitOne(1000, $false)
        if (-not $wait) {
            $client.Close()
            return $false
        }
        else {
            $client.EndConnect($asyncResult)
            $client.Close()
            return $true
        }
    }
    catch {
        return $false
    }
}

# Loop until the port is open
while (-not (Test-PortOpen -HostName $VMHost -Port $Port)) {
    Write-Host "Port $Port is not open yet. Waiting..."
    Start-Sleep -Seconds 5
}

Write-Host "Port $Port is open."
Write-Host "Checking if the system is fully booted (systemctl is-system-running)..."

# Define SSH options
$SSH_OPTS = @("-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null")

function Test-VMBoot {
    try {
        # Force pseudo-terminal allocation with -t
        $output = ssh -t -p $Port @SSH_OPTS cmsc414@localhost "systemctl is-system-running" 2>$null
        if ($output -like "*running*") {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}

# Wait until the VM’s system reports it is running
while (-not (Test-VMBoot)) {
    Write-Host "VM not fully booted yet. Waiting..."
    Start-Sleep -Seconds 5
}

Write-Host "VM is fully booted. Connecting via SSH with VS Code..."

# Open VS Code via the Remote-SSH URI (ensure your SSH config entry uses a matching host alias, e.g. 'cmsc414-vm')
code --folder-uri "vscode-remote://ssh-remote+cmsc414-vm/home/cmsc414?windowId=_blank"
