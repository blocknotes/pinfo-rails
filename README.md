# PROJECT UNMAINTAINED

> *This project is not maintained anymore*
>
> *If you like it or continue to use it fork it please.*

---
---

# pinfo-rails: Rails project info [![Gem Version](https://badge.fury.io/rb/pinfo-rails.svg)](https://badge.fury.io/rb/pinfo-rails)

An utility to collect informations from a Rails project.

Currently I added some basic checks, feel free to contact me (or pull request) to improve this project.

[https://rubygems.org/gems/pinfo-rails](https://rubygems.org/gems/pinfo-rails)

### Features

- `pinfo` command line tool
- Colored output
- Fetch informations directly from files, without running Rails (faster, easier)
- Options from a global config file (`~/.pinfo-rails.conf`)
- Options from a local config file (see [pinfo-rails.sample_conf](https://github.com/blocknotes/pinfo-rails/blob/master/pinfo-rails.sample_conf))

### Usage

- Install the gem: `gem install pinfo-rails`
- Enter in a Rails project directory
- Execute: `pinfo`

### Sample output

```
- Ruby (current): 2.3.0
- Ruby (Gemfile): ruby '2.3.0'
- Rails: 'rails', '4.2.5.2'
- Required: 'redis-rails'
- Required: 'sunspot_solr'

- Database development: adapter = mysql2; host = localhost; database = my_db; username = root
- Database staging: adapter = mysql2; host = 192.168.1.1; database = stag_db; username = stag; password = stag

- Cache development:
    config.cache_classes = false
    config.action_controller.perform_caching = false
- Cache staging    :
    config.cache_classes = true
    config.action_controller.perform_caching = true
- Cache production :
    config.cache_classes = true
    config.action_controller.perform_caching = true

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
-r, --required=REQS              Search for specific gems
-s, --[no-]styles                With styles and colors (default)

    --[no-]cache                 Show cache info
    --[no-]database              Show database info
    --[no-]deploy                Show deploy info
```

### History

When I started to work with Ruby on Rails often I had to switch projects to make minor updates, add new features, fix things; and to publish the changes I created a small script to fetch for config informations. After some times I decided to make a gem for that purpose, this gem.

---

My website: <https://blocknot.es/>
