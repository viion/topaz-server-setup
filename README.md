# topaz-server-setup

### This is heavily WIP and I just threw it together to try out Topaz!
> aka - not production ready, just for your own fun.

__

A script to setup FFXI Project Topaz on Ubuntu 18.04

This is mostly based on https://github.com/project-topaz/topaz/wiki/Server-Installation---Setup-%5BUbuntu-18.04-LTS%5D.

**Changes:**

- `libmariadbclient-dev libmariadb-dev-compat` have conflicting dependencies and cannot be installed together it seems (at least on an Ubuntu 18.04 Server) - you do not need the client: `libmariadbclient-dev`
- `zlib1g-dev libssl-dev` are required.
- Config needs copying: `cp conf/default/* conf/`
- Automated some of the config updates using `sed`
- Automated some of the port forwarding

## Running

I've tested this on a Digital Ocean $10 node (for 2GB RAM)

- Edit: https://github.com/viion/topaz-server-setup/blob/master/ffxi_topaz_setup.sh#L4
- Edit: https://github.com/viion/topaz-server-setup/blob/master/db_ffxi_topaz_update.sql#L3
- Run `./ffxi_topaz_setup.sh`

## Todo 

- Remove the SQL scripts completely and do everything in the main shell script
- Add arguments for setting Passwords
- Add arguments for some basic config
- Automate IP Retreival if server is to be public
