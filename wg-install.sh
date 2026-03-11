apt install wireguard -y

BASE_DIR="/root/expriments/wireguard/confs"
NIC="enp1s0"
WG_DIR="/etc/wireguard"

IP=$(ip -4 addr show $NIC | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -z "$IP" ]; then
    echo "Failed to get IPv4 address for $NIC"
    exit 1
fi

CONF_DIR="$BASE_DIR/conf-$IP"

if [ ! -d "$CONF_DIR" ]; then
    echo "Directory not found: $CONF_DIR"
    exit 1
fi


echo "Using config directory: $CONF_DIR"

for conf in "$CONF_DIR"/wg*.conf; do
    if [ -f "$conf" ]; then
        filename=$(basename "$conf")
        name=${filename%.*}
        echo "Applying $conf"
        wg-quick down "$name" 2>/dev/null
        rm -rf "$WG_DIR"/*
        cp "$conf" "$WG_DIR"
        wg-quick up "$name"
        echo "Applied $conf"
    fi
done

echo "All WireGuard configs applied."