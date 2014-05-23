# Writefully

[![Build Status](https://travis-ci.org/codemy/writefully.svg?branch=master)](https://travis-ci.org/codemy/writefully) [![Coverage Status](https://coveralls.io/repos/codemy/writefully/badge.png?branch=master)](https://coveralls.io/r/codemy/writefully?branch=master) [![Code Climate](https://codeclimate.com/github/codemy/writefully.png)](https://codeclimate.com/github/codemy/writefully)

Allows developers who love to write to publish easily

## Getting Started

There are 2 ways to use Writefully, generate a brand new app or integrate it into an existing application.

Writefully depends on PostgreSQL with hstore extension activated so make sure you set that up if your going with the existing application route.

### New App

```bash
gem install writefully

wf-app new [name]
```

This will generate the boilerplate rails app to get you started using writefully.

### Existing App

```bash
gem 'writefully'
```

Once you've installed the gem run 

```bash
rake writefully:migrations:install
```

In `config/routes.rb` add the following

```ruby
mount Writefully::Engine, at: '/writefully'
```

Create any model for Writefully. This is the model writefully will use.

```bash
rails g model [ModelName (Post|Article|Whatever)] --skip-migration --parent=writefully/post
```

The last step is to run the migration to generate the database structure for writefully

```bash
rake db:migrate
```



## Manifesto

+ Writefully Core
  + Separate lightweight process that manages all the work
  + Main rails process should be able to communicate with Writefully via Redis queue
    + When a site is created it sets up a repository / hooks with sample content
  + Manages content taxonomy via Tags / Taggings
  + Easily Extendable from main rails app
  + Content Localization
  + Backend Interface for managing sites
  + Receive WebHook from github and updates site
  + Turns repository collaborators into authors
  + Converts local based images into content provider URL
    + S3 / Cloudfront
    + Akamai
    + Cloudfiles
    + etc...

+ Writefully Desktop App
  + Probably going to use [node-webkit](https://github.com/rogerwang/node-webkit)
  + More details to com

+ Writefully mobile app
  + Probably going to use [Framework7](http://www.idangero.us/framework7/)
  + More details to come
