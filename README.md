# Envoy on Windows with Consul

Note: The paths configured in this example assume that c:/tmp is writable.

All the binaries can be found in GitHub releases.

## Run Consul server

```
.\consul.exe agent --dev
```

## Load the Consul config

```
.\consul.exe services register .\backend.hcl
.\consul.exe services register .\frontend.hcl
.\consul.exe config write .\backend-defaults.hcl
```

### optional step
This repo contains the required Envoy bootstrap config, however,
bootstrap config can also be generated with the following command:

```
.\consul.exe connect envoy --sidecar-for=frontend-1 -bootstrap
.\consul.exe connect envoy --sidecar-for=backend-1 -bootstrap
```

Note: you will need to change the generated config to update
the `access_log_path` as `/dev/null` is not available.

```json
  "admin": {
    "access_log_path": "c:/tmp/fake-access.log",
    "address": {
      "socket_address": {
        "address": "127.0.0.1",
        "port_value": 19000
      }
    }
  },
```

## Run Fake Backend and the associated Envoy
```
.\fake-service.exe
.\envoy.exe -c c:\tmp\bootstrap-backend.json
```

## Run Fake Frontend Envoy
This uses Consul as the registered service to 
bypass the need for running a real service, we only
want the service to start.

```
.\envoy.exe -c c:\tmp\bootstrap-frontend.json
```

## Test the service
Envoy has been configured to expose the backend service via
the frontend proxies local listener localhost:9091

```
curl "http://localhost:9091"
```