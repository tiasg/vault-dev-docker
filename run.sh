#!/bin/dumb-init /bin/sh

rm -f /opt/healthcheck

#copypasta from upstream docker-entrypoint.sh

# VAULT_CONFIG_DIR isn't exposed as a volume but you can compose additional
# config files in there if you use this image as a base, or use
# VAULT_LOCAL_CONFIG below.
VAULT_CONFIG_DIR=/vault/config

# You can also set the VAULT_LOCAL_CONFIG environment variable to pass some
# Vault configuration JSON without having to bind any volumes.
if [ -n "$VAULT_LOCAL_CONFIG" ]; then
    echo "$VAULT_LOCAL_CONFIG" > "$VAULT_CONFIG_DIR/local.json"
fi

vault server \
        -config="$VAULT_CONFIG_DIR" \
        -dev-root-token-id="${VAULT_DEV_ROOT_TOKEN_ID:-root}" \
        -dev-listen-address="${VAULT_DEV_LISTEN_ADDRESS:-"0.0.0.0:8200"}" \
        -dev "$@" &

# end copypasta

sleep 1 # wait for Vault to come up

# parse JSON array, populate Vault
if [[ -f /opt/secrets.json ]]; then
  for path in $(jq -r 'keys[]' < /opt/secrets.json); do
    jq -rj ".\"${path}\"" < /opt/secrets.json > /tmp/value
    echo "writing value to ${path}"
    vault write "${path}" "value=@/tmp/value"
    rm -f /tmp/value
  done
else
  echo "/opt/secrets.json not found, skipping"
fi

# docker healthcheck
touch /opt/healthcheck

# block forever
tail -f /dev/null
