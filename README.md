# Setup

1. Copy `env.template` to `.env` and set the variables.
1. Modify the `command` in `docker-compose.yml`, by setting a valid [bcp](https://learn.microsoft.com/en-us/sql/tools/bcp-utility) command
1. Run `docker compose build`

# Run

Execute: `docker compose run --rm postgrest2sqlserver`

If everything goes as expected, set `DELETE` to `true` to move the data instead of copying them.
