# Napa Checkin

A "check-in" service built using [Napa](https://github.com/bellycard/napa).

## Setup

Clone, bundle, and rake db:*

```sh
git clone git@github.com:danielmackey/napa-service.git
cd napa-service
bundle
rake db:create
rake db:migrate
```


## Getting Started

To run the app
```sh
shotgun
```
which will server the service at http://localhost:9393

### API Security

This service utilizes the basic `Napa::Middleware::Authentication` to serve as an API key.

Setting `HEADER_PASSWORDS='suchsecure,muchpassword'` in the `.env` file will allow those two passwords to act as api keys for every request.

In a more robust environment, a mechanism for creating, storing, and validating API keys for various clients would be built.



