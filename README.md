# Auto-Startup VM & Connect with VS Code Remote

This script automates the process of starting up a virtual machine (VM) using QEMU and connecting to it via VS Code Remote SSH.
This guide assumes the completion the instructions given from Canvas before starting.

## Prerequisites
Before running the script, ensure the following:
1. **Public Key Authentication:**
   - Your SSH public key (`id_rsa.pub`) must be added to the VM's `~/.ssh/authorized_keys`.
2. **SSH Configuration:**
   - Modify or create your SSH configuration file (`~/.ssh/config` or `C:\Users\YourUsername\.ssh\config` on Windows) as follows:
     ```
     Host cmsc414-vm
         HostName 127.0.0.1
         Port 41422
         User cmsc414
         IdentityFile C:\Users\YourUsername\.ssh\id_rsa
     ```
     **Important:** Ensure `IdentityFile` points to the private key (`id_rsa`), not the public key (`id_rsa.pub`).
3. **Windows File Extensions:**
   - On Windows, make sure the SSH config file is not saved as a `.txt` file (e.g., `config.txt`). It should be named simply `config`.
4. **VM File Path:**
   - Ensure the script points to the correct file path for your VM image (`cmsc414.qcow2`). Modify it if necessary at `file=cmsc414.qcow2`.
5. **VS Code Extension**  
   - Ensure the Remote - SSH extension from Microsoft is installed on the host machine.  

## Usage
Run the appropriate script based on your operating system.

### Linux/Mac
1. Open a terminal.
2. Navigate to the directory containing the script.
3. Run the script:
   ```bash
   ./startup_vm.sh
   ```

### Windows (PowerShell)
1. Open PowerShell.
2. Navigate to the directory containing the script.
3. Run the script:
   ```powershell
   .\startup_vm.ps1
   ```
4. Alternatively, if the script is on your desktop or in a folder, you can right-click on it and select **Run with PowerShell**.

## What the Script Does
- Starts the VM using QEMU.
- Waits until the SSH port (`41422`) is open.
- Ensures the VM has fully booted before proceeding.
- Opens VS Code using Remote-SSH to connect to the VM.

## Troubleshooting
- **SSH Connection Issues:**
  - Check that the VM is running and SSH is accepting connections.
  - Verify the SSH config file is correctly set up.
  - Ensure your public key is in `~/.ssh/authorized_keys` on the VM.
- **VS Code Remote Not Connecting:**
  - Try connecting manually: `ssh cmsc414-vm`.
  - Restart VS Code and ensure the Remote-SSH extension is installed.

If you encounter issues, double-check your configuration and VM settings.

