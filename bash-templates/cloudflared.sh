cat <<EOF

# Create Cloudflare Tunnel for each host under Cloudflare Zero Trust UI
# Install Remotely managed CloudFlare Tunnel on each host

curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb

# Each host will need it's own Cloudflare tunnel token
sudo cloudflared service install "<REPLACE-ME-WITH-CF-TOKEN-FOR-HOST>"
EOP