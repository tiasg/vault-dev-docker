# Vault Development Docker Image

Docker image based on upstream official Vault image which allows pre-populating with
secrets for local development/testing. DO NOT USE FOR PRODUCTION PURPOSES.

Secrets
-------

The JSON file at `/opt/secrets.json` (override with
`$VAULT_SECRETS_FILE`) will be read and written into the generic
secret backend on startup.

The format is an object associating a path with value, as follows:

```json
{
  "secret/foo/bar": "baz",
  "secret/something/else": "asdf1234"
}

```

Helm Chart
----------

There is a bundled [Helm](https://helm.sh) chart included at `.helm/charts/vault`. See values.yaml for configuration.

Backends
--------

The following backends can be enabled by setting the appropriate
environment variable to `1`:
- App ID: `$VAULT_USE_APP_ID`
- Kubernetes: `$VAULT_USE_K8S`

Kubernetes
----------

Kubernets auth is supported but will only function when the container is running within a k8s pod. Set `$VAULT_USE_K8S` to "1" to enable the backend.

The following environment variables are supported:

- VAULT_CA_CERT - This is the CA certificate bundle data for [clients of the Kubernetes API](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster/#accessing-the-api-from-a-pod), or the default value "@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt" will read it from the filesystem.
- VAULT_K8S_HOST - Kubernetes API hostname (default: https://kubernetes.default)
- VAULT_K8SROLES_FILE - JSON file containing one or more [Vault k8s auth roles](https://www.vaultproject.io/api/auth/kubernetes/index.html#create-role), in the following format (every field except name accepts multiple comma-separated values):
  ```json
  [
    {
        "name": "k8sauth",
        "service_accounts": "default,default2",
        "namespaces": "default,default2",
        "policies": "policy1,policy2"
    }
  ]
  ```

App ID (deprecated)
-------------------

If the app ID backend is enabled, app ID profiles can be created by
setting the file at `/opt/app-id.json` (override with
`$VAULT_APP_ID_FILE`) as follows:

```json
[
  {
    "name": "app-id-1",
    "policy": "root",
    "user_ids": [
      "asdf",
      "qwerty"
    ]
  },
  {
    "name": "app-id-2",
    "policy": "root",
    "user_ids": [
      "mary",
      "fred"
    ]
  }
]
```

Policies
--------

Policies can be created by specifying the file at `/opt/policies.json`
(override with `$VAULT_POLICIES_FILE`) as follows:

```json
{
  "policy1": "path \"secret/*\" { policy = \"write\" }"
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

Docker Registry
---------------

https://quay.io/dollarshaveclub/vault-dev
