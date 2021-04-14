# banking_challenge
A simple phoenix project for banking transactions.

To run this project you need first to have a Postgres container running on port 5432. I embedded a docker-compose configuration to ease setting up the environment.

``` sh
# Run this to have a postgres database on port 5432:
docker-compose up -d
```

To run tests: `mix tests` on the root folder.