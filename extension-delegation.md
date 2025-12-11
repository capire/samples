# Extension delegation

## Preconditions

Precondition to use extension delegation is to use at least @sap/cds-mtxs@3.6.0 which support the separation of extensions by `appid`.

This example is deployed as one `mtar`. So all destinations from applications to the shared-db module are defined within the [`mta.yaml`](./mta.yaml).

## Limitation

The sample implementation only allows synchronous extension requests for now.

Support for asynchronous extension requests requires further investigation and will be added later.

## Required service implementation per microservice (see `reviews` or `orders`)

Every microservice contains a `cds.xt.RemoteExtensiblityService` (see [remote-extensibility-service.cds](./reviews/srv/remote-extensibility-service.cds)) that is configured in [package.json](./reviews/package.json)

In addition, a handler implementation for `cds.xt.ExtensibilityService` redirects the requests to the `cds.xt.RemoteExtensiblityService` (see [delegating-extensibility-service.js](./reviews/srv/delegating-extensibility-service.js))

