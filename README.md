# Banking API Challenge - Stone Co.
A simple phoenix project for banking transactions. The description of the challenge is found [here](https://github.com/JoaoAngelojr/banking_challenge/blob/main/CHALLENGE.md).

# Runnig Project
To run this project you need first to have a Postgres container running on port 5432. I embedded a docker-compose configuration to ease setting up the environment.

On the root folder, execute the following steps:
``` sh
# Run this to have a postgres database on port 5432:
docker-compose up -d
```

``` sh
# Run this to get all dependencies and to apply all migrations:
mix setup
```

``` sh
# For running the api:
mix phx.server
```

Once the api is running, you can access all endpoints at `http://localhost:4000`. You can see all routes running this:

``` sh
# Run this to see all the api's available routes:
mix phx.routes BankingChallengeWeb.Router
```

# Runnig Tests
On the root folder:

``` sh
# To run tests:
mix test
```