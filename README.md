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
  -d password="password"
  -d password_confirmation="password"
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

### Tokens

Any action done on behalf of a user will require a token, which is
unique to that user. A token is obtained by passing the email address and password
of that user to the tokens endpoint:

```sh
curl -X POST
  -d email="daniel@danielmackey.com"
  -d password="password"
  http://localhost:9393/tokens
```

Returns:

**Valid credentials**
```json
{
  "data":{
    "object_type": "token",
    "value": "c99d5b8b703003855dd9c9ee9feb41aa109f7495",
    "user_id": 1
  }
}
```

**Invalid credentials**
```json
{
  "error":{
    "code": "invalid_credentials",
    "message": ["email and/or password do not match"]
  }
}
```

A token can be deleted by sending `DELETE` to
`http://localhost:9393/tokens/:value`. In a more robust service,
the tokens would implement some sort of TTL, or even better,
utilize an accepted pattern like OAuth.

### Creating a Checkin

A checkin happens when a [user](#creating-users) visits a
[business](#creating-businesses), so we need both of those to
exist in the system to create a checkin. Once we have both a user and
a business in the system, we need to obtain a [token](#tokens) for that user.

Take the `business_id` and `token` value and `POST` it to the checkins endpoint.

```sh
curl -X POST
  -d token=c99d5b8b703003855dd9c9ee9feb41aa109f7495
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
In order to prevent any client from checking in on any given user's behalf,
we've implemented a token strategy. This requires you to [obtain a token](#tokens) from
the system once you have valid user credentials. This model would allow a single
developer making one client to allow users to login and then act on their behalf.

In addition to user tokens, you'll notice the response includes a `created_at` timestamp.
We store this to prevent the same user from checking into the same
business within a given window of time.

This value is set to `5.minutes` by default, but can be configured via
an ENV variable `ENV['CHECKIN_FREQUENCY']` and is accessible as a constant
on `Checkin::FREQUENCY`.


## Getting checkins for User/Business

I've added some extra endpoints to a business or user to grab the checkins related to it.

### Business checkins
```sh
curl http://localhost:9393/businesses/1/checkins
```

```json
{
  "data":[
    {
      "object_type":"checkin",
      "id":"1",
      "user_id":1,
      "business_id":1,
      "created_at":"2014-05-02 15:31:19 UTC"
    },{
      "object_type":"checkin",
      "id":"2",
      "user_id":1,
      "business_id":1,
      "created_at":"2014-05-02 17:45:05 UTC"
    }
  ]
}
```

### User checkins
```sh
curl http://localhost:9393/users/1/checkins
```

```json
{
  "data":[
    {
      "object_type":"checkin",
      "id":"1",
      "user_id":1,
      "business_id":1,
      "created_at":"2014-05-02 15:31:19 UTC"
    },{
      "object_type":"checkin",
      "id":"2",
      "user_id":1,
      "business_id":1,
      "created_at":"2014-05-02 17:45:05 UTC"
    }
  ]
}
```


## Specs

To run the suite, make sure you've setup your database and run the specs.

```sh
RACK_ENV=test rake db:create
RACK_ENV=test rake db:migrate
rspec spec/
```

## TODO:
- Add a `rake db:seed` task (possibly add to napa)
- Add endpoint to list unique visitors for business @ `/businesses/:id/visitors`

