#!/bin/bash

# Variables
CT_NAME="lubelogger"  # Container name
CT_ID=$(pvesh get /cluster/nextid)
TEMPLATE="debian-12-turnkey-core_18.1-1_amd64.tar.gz"
TEMPLATE_FULL_NAME="local:vztmpl/$TEMPLATE"  # Path to the template
DISK_SIZE="8"        # Disk size in GB
RAM="512"             # RAM size in MB
CPU_CORES="1"         # Number of CPU cores
NET="vmbr0"           # Network bridge

# URLs for required files
DOCKER_COMPOSE_URL="https://raw.githubusercontent.com/hargata/lubelog/main/docker-compose.yml"
ENV_FILE_URL="https://raw.githubusercontent.com/hargata/lubelog/main/.env"

# Check if the template is already downloaded
if ! pveam list local | grep -q $TEMPLATE; then
    echo "Template not found locally. Downloading..."
    pveam download local $TEMPLATE
fi

# Create the LXC container
pct create $CT_ID $TEMPLATE_FULL_NAME --hostname $CT_NAME --cores $CPU_CORES --memory $RAM --net0 name=eth0,bridge=$NET,ip=dhcp --rootfs local-lvm:$DISK_SIZE --start 1 --unprivileged 1 --features nesting=1

# Wait for the container to start
sleep 10

# Install docker and docker-compose
pct exec $CT_ID -- bash -c "
apt-get update && apt-get upgrade -y && apt-get install -y docker.io docker-compose
systemctl enable docker
systemctl start docker
"

# Download required files and start app using the docker-compose.yml file
pct exec $CT_ID -- bash -c "
mkdir /root/lubelog &&
curl -o /root/lubelog/docker-compose.yml $DOCKER_COMPOSE_URL &&
curl -o /root/lubelog/.env $ENV_FILE_URL &&
cd /root/lubelog &&
docker pull ghcr.io/hargata/lubelogger:latest &&
docker-compose up -d
"

# Get the IP address from the container
IP_ADDRESS=$(pct exec $CT_ID -- ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

# Display IP address and port information
echo "LXC container $CT_NAME created with IP address: $IP_ADDRESS"
echo "The lubelog app is started and available on http://$IP_ADDRESS:8080"