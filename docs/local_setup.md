## Local/Dev
### Install services
You will need to install:
- [Elixir/Erlang installed](https://elixir-lang.org/install.html).
- [Postresql](https://www.postgresql.org/download).

Make sure that Elixir is in correct version (currently using 1.14). You can find required version [here](https://github.com/beyond-all-reason/apollo/blob/master/mix.exs#L8).
You can use [asdf](https://github.com/asdf-vm/asdf) to install correct version.

### Install build tools (gcc, g++, make)
#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install build-essential
```

### Elixir setup
```bash
mix deps.get
mix deps.compile
```

### Postgres setup
If you want to change the username or password then you will need to update the relevant files in [config](/config).
```bash
sudo su postgres
psql postgres postgres <<EOF
CREATE USER apollo_dev WITH PASSWORD '123456789';
CREATE DATABASE apollo_dev;
GRANT ALL PRIVILEGES ON DATABASE apollo_dev to apollo_dev;
ALTER USER apollo_dev WITH SUPERUSER;

CREATE USER apollo_test WITH PASSWORD '123456789';
CREATE DATABASE apollo_test;
GRANT ALL PRIVILEGES ON DATABASE apollo_test to apollo_test;
ALTER USER apollo_test WITH SUPERUSER;
EOF
exit

# You should now be back in the apollo folder as yourself
# this next command will perform database migrations
mix ecto.create
```

### SASS
We use sass for our css generation and you'll need to run this to get it started.
```bash
mix sass.install
```

### Running it
Standard mode
```bash
mix phx.server
```

Interactive REPL mode
```
iex -S mix phx.server
```
If all goes to plan you should be able to access your site locally at [http://localhost:4000/](http://localhost:4000/).

### Libraries you need to get yourself
The site makes liberal use of [FontAwesome](https://fontawesome.com/)
```
fontawesome/css/all.css -> priv/static/css/fontawesome.css
fontawesome/webfonts -> priv/static/webfonts
```
