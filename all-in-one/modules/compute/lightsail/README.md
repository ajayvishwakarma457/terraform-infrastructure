What this Lightsail module does (high-level only):
    1) Creates a Lightsail VM instance
    2) Assigns a static public IP to the instance
    3) Opens firewall ports: 22 (SSH), 443 (HTTPS), 3000, 3100
    4) Takes instance snapshots using AWS CLI (Terraform workaround)
    5) Creates an additional disk
    6) Attaches the disk to the instance at /dev/xvdf
    7) Creates a managed Lightsail MySQL database
    8) Creates a Lightsail Container Service
    9) Deploys a container (nginx / app image)
    10) Exposes the container via a public HTTP endpoint
    11) Configures health checks for the container endpoint
    12) Tags all supported resources