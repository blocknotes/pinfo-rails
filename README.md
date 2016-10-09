
# pinfo-rails: Rails project info

An utility to collect informations from a Rails project

Currently I added only some basic checks, feel free to contact me (or pull request) to improve this project.

### Features

- `pinfo` command line tool
- Styled output
- Fetch informations without running Rails (faster, easier)
- Options from a global config file (`~/.pinfo-rails.conf`)
- Options from config file (see sample conf)

### Usage

- Install the gem: `gem install pinfo-rails`
- Enter in a Rails project directory
- Execute: `pinfo`

### Sample output

```
- Ruby: 2.3.0
- Rails: 'rails', '4.2.5.2'
- DB (development): mysql2, my_db
- Required: 'redis-rails'
- Required: 'sunspot_solr'

- Development: config.cache_classes = false
- Staging    : config.cache_classes = true
- Production : config.cache_classes = true

- Deploy tool: 'mina'
- Staging    :
    domain, '192.168.1.1'
    branch, 'feature/restyle'
    user, 'stag'
- Production :
    server '192.168.1.10'
    branch, 'master'
```

### Options

```
-c, --config=CONF                Config file
-v, --[no-]verbose               Run verbosely

-s, --[no-]styles                With styles and colors (default)
-r, --required=REQS              Search for specific gems
    --[no-]cache                 Show cache info
    --[no-]deploy                Show deploy info
```

### History

When I started to work with Ruby on Rails often I had to switch projects to make minor updates, add new features, fix things; and to publish the changes I created a small script to fetch for config informations. After some times I decided to make a gem for that purpose, this gem.
