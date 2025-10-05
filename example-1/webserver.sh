#!/bin/bash

set -euxo pipefail
exec > /var/log/bootstrap.log 2>&1

dnf -y install nginx amazon-efs-utils nfs-utils
systemctl enable --now nginx

cat >/usr/share/nginx/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
  <head>
  	<title>Simple Webserver</title>
  </head>
  <body>
    <h1>Hello from __HOSTNAME__</h1>
  </body>
</html>
EOF

sed -i "s/__HOSTNAME__/$(hostname -f)/" /usr/share/nginx/html/index.html
systemctl restart nginx
