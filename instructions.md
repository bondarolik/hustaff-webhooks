# Changelog 

## Prepare the application 

To use this application you will need to make few adjustments.

### Database

Create you `database.yml` with following contents:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("POSTGRES_HOST") %> # refers to docker-compose.yml variables
  username: <%= ENV.fetch("POSTGRES_USER") %>  # refers to docker-compose.yml variables
  password: <%= ENV.fetch("POSTGRES_PASSWORD") %>  # refers to docker-compose.yml variables
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: webhooks_db_dev # change it as you like

test:
  <<: *default
  database: webhooks_db_test # change it as you like

production:
  <<: *default
  database: webhooks_db_prod # change it as you like
```

### ENV file

Create `.env` file and place some secret phrase for [JWT gem](https://github.com/jwt/ruby-jwt):

```
JWT_SECRET=your_super_secret_combination
```

### Final steps (Docker or running locally)

1. Ensure that you have Docker installed on your local machine
2. Run `docker-compose build` to prepare docker containers
3. Run `docker-compose run --rm app bin/rails db:setup` to setup prepare the app
4. Run `docker-compose up` to start the application

The application is exposed to **3000** port. You can access the app vía API (or Browser) pointing at **localhost:3000** (or **127.0.0.0.1:3000**)

**Note**: Follow [README.md](README.md) instructions if you want to run this application without Docker.

## How does Authentication works 

This application is using [Rodauth](https://github.com/janko/rodauth-rails) and [JWT](https://github.com/jwt/ruby-jwt) gems. 

Rodauth is the most complete and fresh solution to handle all authentication functionality and posibilities, including passwordless, OTP and Token-based auth.

JWT to improve API (token) based feature.

Routes handled by RodauthApp:

```
  /login                   rodauth.login_path
  /create-account          rodauth.create_account_path
  /verify-account-resend   rodauth.verify_account_resend_path
  /verify-account          rodauth.verify_account_path
  /change-password         rodauth.change_password_path
  /change-login            rodauth.change_login_path
  /logout                  rodauth.logout_path
  /remember                rodauth.remember_path
  /reset-password-request  rodauth.reset_password_request_path
  /reset-password          rodauth.reset_password_path
  /verify-login-change     rodauth.verify_login_change_path
  /close-account           rodauth.close_account_path
```

### Create one organization, it's project and some tasks

Use seeds to preload database with some data.

```
docker-compose run --rm app bin/rails db:seed
```

## Payloads

Use any RESTFul API client such as [Postman](https://www.postman.com) or [Thunder for VS Code](https://www.thunderclient.com) to make requests.

Make sure that your client is configured to accept **application/json**. 

### Create new account

```yaml
# POST: http://127.0.0.1:3000/create-account
# Content-Type: application/json
{
  "login": "foo@example.com",
  "password": "secret"
}

# Response:
# Use the token obtained in Authorization header
# HTTP/1.1 200 OK
# Content-Type: application/json
# Authorization: eyJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50X2lkIjozLCJhdXRoZW50aWNhdGVkX2J5IjpbImF1dG9sb2d...

{ "success": "Your account has been created" }
```

### Read projects data

Without Authorization token:

```yaml
# GET: http://127.0.0.1:3000/organizations/1/projects
# Content-Type: application/json

# Response:
# Use the token obtained in Authorization header
# HTTP/1.1 200 OK
# Content-Type: application/json
# Authorization: eyJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50X2lkIjozLCJhdXRoZW50aWNhdGVkX2J5IjpbImF1dG9sb2d...

{ "success": "our account has been created" }
```

Now, let's use Authorization token:

```yaml
# GET: http://127.0.0.1:3000/organizations/1/projects
# Content-Type: application/json
# Headers-Authorization: eyJhbGciOiJIUzI1NiJ9...

# Response:
# HTTP/1.1 200 OK
# Content-Type: application/json
# Authorization: eyJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50X2lkIjozLCJhdXRoZW50aWNhdGVkX2J5IjpbImF1dG9sb2d...

{
  "data": [
    {
      "id": "1",
      "type": "project",
      "attributes": {
        "name": "Webhooks",
        "organization_id": 1,
        "created_at": "2022-05-25T14:01:31.528Z",
        "updated_at": "2022-05-25T14:01:31.528Z"
      }
    }
  ]
}
```