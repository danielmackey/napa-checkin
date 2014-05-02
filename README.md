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

Setting `HEADER_PASSWORDS='suchsecure,muchpassword'` in the `.env` file will allow those two passwords to act as API keys for every request.

In a more robust environment, a mechanism for creating, storing, and validating API keys for various clients would be built.

### Creating Users

To create a new user:

```sh
curl -X POST
  --header 'Password: suchsecure'
  -d name="Daniel Mackey"
  -d email="daniel@danielmackey.com"
  http://localhost:9393/users
```

Returns:

```json
{
  "data": {
    "object_type": "user",
    "id": "1",
    "name": "Daniel Mackey",
    "email": "daniel@danielmackey.com"
  }
}
```

> Note: Moving forward, all requests to the api should include the
`--header 'Password: suchsecure'` option, but will be excluded from
the documentation below.

### Creating Businesses

To create a new business:

```sh
curl -X POST
  -d name="Such Business Much Money"
  -d website="https://www.so-profit.biz"
  http://localhost:9393/businesses
```

Returns:
```json
{
  "data":{
    "object_type": "business",
    "id": "1",
    "name": "Such Business Much Money",
    "website": "https://www.so-profit.biz"
  }
}
```


### Creating a Checkin

A checkin happens when a [user](#creating-users) visits a
[business](#creating-businesses), so we need both of those to
exist in the system to create a checkin.

```sh
curl -X POST
  -d user_id=1
  -d business_id=1
  http://localhost:9393/checkins
```

Returns:
```json
{
  "data": {
    "object_type":"checkin",
    "id":"1",
    "user_id":1,
    "business_id":1,
    "created_at":"2014-05-02T15:31:19Z"
  }
}
```

#### Preventing abuse
You'll notice the response includes a `created_at` timestamp.
We store this to prevent the same user from checking into the same
business within a given window of time.

This value is set to `5.minutes` by default, but can be configured via
an ENV variable `ENV['CHECKIN_FREQUENCY']` and is accessible as a constant
on `Checkin::FREQUENCY`.

#### Possible enhancements to prevent abuse
Right now, there is nothing to prevent a client from creating checkins for
and existing user in the system. If our client was a mobile app, where only
only the logged in user should be able to check in to a business, we could
add a `UserToken` model, and an login endpoint on the `UsersApi` to authenticate
a user (with username/password) and return a token. The checkin endpoint would no
longer require/allow an explicit `user_id` to be sent, and instead reference the `token`
to look up the user.


## Specs

To run the suite, make sure you've setup your database and run the specs.

```sh
RACK_ENV=test rake db:create
RACK_ENV=test rake db:migrate
rspec spec/
```

## TODO:
- Add a `rake db:seed` task (possibly add to napa)
- Add endpoint to list checkins for user @ `/users/:id/checkins`
- Add endpoint to list checkins for business @ `/businesses/:id/checkins`
- Add endpoint to list visitors for business @ `/businesses/:id/visitors`

