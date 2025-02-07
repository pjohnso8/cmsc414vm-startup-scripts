#!/bin/bash
# Start the VM via QEMU. This command runs in the background.
qemu-system-x86_64 -accel tcg -m 2G -drive if=virtio,format=qcow2,file=cmsc414.qcow2 -nic user,model=virtio,hostfwd=tcp:127.0.0.1:41422-:22 &

# Define host and port for SSH connection.
HOST="127.0.0.1"
PORT=41422

echo "Waiting for SSH port $PORT on $HOST..."
# Loop until something is listening on the given port.
while ! nc -z "$HOST" "$PORT"; do
    echo "Port $PORT is not open yet. Waiting..."
    sleep 5
done

echo "Port $PORT is open."
echo "Checking if the system is fully booted (systemctl is-system-running)..."
# Now loop until the remote system reports that it is fully running.
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

until ssh -p "$PORT" $SSH_OPTS cmsc414@localhost "systemctl is-system-running" 2>/dev/null | grep -qi "running"; do
    echo "VM not fully booted yet. Waiting..."
    sleep 5
done

echo "Port $PORT is now open. Connecting via SSH..."
code --folder-uri "vscode-remote://ssh-remote+cmsc414-vm/home/cmsc414?windowId=_blank"


