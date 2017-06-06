# Vault Development Docker Image

Docker image based on upstream official Vault image which allows pre-populating with
secrets for local development/testing. DO NOT USE FOR PRODUCTION PURPOSES.

Secrets
-------

The JSON file at ``/opt/secrets.json`` (share in via a volume) will be read and written
into the generic secret backend on startup.

The format is an object associating a path with value, as follows:

```json
{
  "secret/foo/bar": "baz",
  "secret/something/else": "asdf1234"
}

```

Healthcheck
-----------
The native Docker healthcheck will return healthy when all configured secrets have been
written.

Authentication
--------------

The upstream vault image is mostly unmodified so it runs Vault in development by
default (no auth necessary) and also respects the environment variable ``VAULT_DEV_ROOT_TOKEN_ID``.

See https://hub.docker.com/_/vault/ for details.
