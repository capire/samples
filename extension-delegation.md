# Extension delegation

## Preconditions

Precondition to use extension delegation is to use at least @sap/cds-mtxs@3.6.0 which support the separation of extensions by `appid`.

This example is deployed as one `mtar`. So all destinations from applications to the shared-db module are defined within the [`mta.yaml`](./mta.yaml).

## Limitation

The sample implementation only allows synchronous extension requests for now.

Support for asynchronous extension requests requires further investigation and will be added later.

## Required service implementation per microservice (see `reviews` or `orders`)

Every microservice contains a `cds.xt.RemoteExtensiblityService` (see [remote-extensibility-service.cds](https://github.com/capire/reviews/blob/remote-extend/srv/remote-extensibility-service.cds)) that is configured in [package.json](https://github.com/capire/reviews/blob/remote-extend/package.json)

In addition, a handler implementation for `cds.xt.ExtensibilityService` redirects the requests to the `cds.xt.RemoteExtensiblityService` (see [delegating-extensibility-service.js](https://github.com/capire/reviews/blob/remote-extend/srv/delegating-extensibility-service.js))

### Notes for Java

This is a Node.js example and `@sap/cds-mtxs` is used as a library here running together with the application. In Java, a sidecar is necessary. So the configuration and implementation regarding the remote extensibility service must be done in the `mtx/sidecar` of each app.
