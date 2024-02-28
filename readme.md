### Terraform job
- Terraform creates 2 droplets (server and client), external volume is attached to server, firewalls, vpc. 
- Server user-data script creates user, installs docker, clones this repo, runs docker-compose file (graylog server).
- Client user-data script installs filebeat and graylog-sidecar (needs manual configuration and run).

### Access
- Access to server: ip-address:80
- Login: admin, password stored in .env file.

### Configure server and one client for demo
#### On server:
1. Log in with GRAYLOG_PASSWORD_SECRET from .env.
2. Create input:
    Systems/Inputs -> Inputs -> Select Input -> Beats -> Launch new input -> set a name -> Save
3. Create sidecar token: 
    Systems/Inputs -> Sidecars ->  Create or reuse a token for the graylog-sidecar user -> set a name -> Create Token -> copy token -> Save
#### On client:
1. Edit /etc/graylog/sidecar/sidecar.yml:
    - set server_url
    - paste server_api_token
    - tls_skip_verify: true
2. Execute: \
    `sudo graylog-sidecar -service install` \
    `sudo systemctl enable graylog-sidecar` \
    `sudo systemctl start graylog-sidecar`
#### On server:
1.  Systems/Inputs -> Sidecars -> Sidecar must appear
2. Click "Manage sidecar", choose "filebeat", click "Assign Configurations", click "Add new configuration"
3. Set name, color, tag, collector: "filebeat on linux", set server IP in configuration, click "Create configuration"
4.  Systems/Inputs -> Sidecars -> Manage Sidecar -> choose filebeat -> Assign Configurations -> choose created configuration. Done!
5. Check logs in "Search" tab.