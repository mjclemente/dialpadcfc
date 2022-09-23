# dialpadcfc

A CFML wrapper for the [Dialpad API](https://developers.dialpad.com/reference/). Use it to interact with the Dialpad call and contact center platform to make calls, send SMS, manage your account, and more.

This is an early stage API wrapper and does not yet cover the full Dialpad API. *Feel free to use the issue tracker to report bugs or suggest improvements!*

## Acknowledgements

This project borrows heavily from the API frameworks built by [jcberquist](https://github.com/jcberquist). Thanks to John for all the inspiration!

## Table of Contents

- [Quick Start](#quick-start)
- [Authentication](#authentication)
- [Setup](#setup)
- [`dialpadcfc` Reference Manual](#reference-manual)

### Quick Start

The following is a quick example of listing the call centers in your account.

```cfc
dialpad = new path.to.dialpadcfc.dialpad( apiKey = 'xxx' );

callcenters = dialpad.listCallCenters();

writeDump( var='#callcenters.data#' );
```

### Authentication

To get started with the Dialpad API, you'll need an [API token](https://developers.dialpad.com/docs/authentication-basics) .

Once you have this, you can provide it to this wrapper manually when creating the component, as in the Quick Start example above, or via an environment variable named `DIALPAD_APIKEY`, which will get picked up automatically. This latter approach is generally preferable, as it keeps hardcoded credentials out of your codebase.

### Setup

There are several options you can configure when initializing the CFC.

| Name          | Type    | Default                    | Description                                                                                                                                 |
| ------------- | ------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| apiKey        | string  |                            | If you do not provide this via the init method, it must be provided as an environment variable, as explained in the authentication section. |
| webhookSecret | string  |                            | Can be provided via an environment variable named `DIALPAD_WEBHOOK_SECRET`. Used as a default for creating and decoding webhooks, but can be overridden. |
| baseUrl       | string  | https://dialpad.com/api/v2 | The base endpoint for the API. You shouldn't need to change this, unless you're testing something.                                          |
| includeRaw    | boolean | false                      | When set to true, details of each request (HTTP Method, path, query params, payload) will be included in the response struct.               |
| httpTimeout   | numeric | 50                         | Timeout for http requests, in seconds.                                                                                                      |

### Reference Manual

A full reference manual for all public methods in `dialpad.cfc`  can be found in the `docs` directory, [here](https://github.com/mjclemente/dialpadcfc/blob/main/docs/dialpad.md).

---
