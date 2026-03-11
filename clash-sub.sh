source /root/clashctl/scripts/cmd/clashctl.sh
BASE_DIR="/root/expriments/clash/confs"
NIC="enp1s0"

IP=$(ip -4 addr show $NIC | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -z "$IP" ]; then
    echo "Failed to get IPv4 for $NIC"
    exit 1
fi

echo "Local IP: $IP"

CONF_DIR="$BASE_DIR/conf-$IP"

if [ ! -d "$CONF_DIR" ]; then
    echo "Directory not found: $CONF_DIR"
    exit 1
fi

echo "Using config directory: $CONF_DIR"

for yaml in "$CONF_DIR"/proxyto_*.yaml; do
    if [ -f "$yaml" ]; then
        echo "Adding $yaml"
        clashsub add "file://$yaml"
    fi
done

echo "Done."