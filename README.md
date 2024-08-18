# LXC Lubelogger Setup Script

This script automates the setup of an LXC container with [LubeLogger])(https://lubelogger.com/) app on Proxmox VE. It installs Docker and Docker Compose, downloads necessary files, and starts an application using Docker Compose.

## Prerequisites

- Proxmox VE (Virtual Environment)
- LXC (Linux Containers) enabled on Proxmox
- Access to Proxmox CLI

## Features

- **Creates an LXC container** using a predefined template.
- **Installs Docker and Docker Compose** inside the container.
- **Downloads required files** (`docker-compose.yml` and `.env`) from a GitHub repository.
- **Starts the application** using Docker Compose.
- **Displays the container's IP address** and provides the URL where the application is accessible.

## Usage

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/shot4free/lubelog-proxmox-ct
    cd lubelog-proxmox-ct
    ```

2. **Make the Script Executable**:

    ```bash
    chmod +x setup-ll-ct.sh
    ```

3. **Run the Script**:

    ```bash
    ./setup-ll-ct.sh
    ```

## Script Details

- **CT_NAME**: The name assigned to the LXC container (`lubelogger`).
- **CT_ID**: The next available container ID automatically fetched.
- **TEMPLATE**: The LXC template to use (`debian-12-turnkey-core_18.1-1_amd64.tar.gz`).
- **DISK_SIZE**: Disk size for the container (`8 GB`).
- **RAM**: RAM allocated to the container (`512 MB`).
- **CPU_CORES**: Number of CPU cores assigned (`1`).
- **NET**: Network bridge for the container (`vmbr0`).

### URLs for Files

- **Docker Compose File**: [docker-compose.yml](https://raw.githubusercontent.com/hargata/lubelog/main/docker-compose.yml)
- **Environment File**: [.env](https://raw.githubusercontent.com/hargata/lubelog/main/.env)


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
