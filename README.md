# Writefully

[![Build Status](https://travis-ci.org/codemy/writefully.svg?branch=master)](https://travis-ci.org/codemy/writefully) [![Coverage Status](https://coveralls.io/repos/codemy/writefully/badge.png?branch=master)](https://coveralls.io/r/codemy/writefully?branch=master) [![Code Climate](https://codeclimate.com/github/codemy/writefully.png)](https://codeclimate.com/github/codemy/writefully)

Allows developers who love to write to publish easily

+ [Getting Started](#getting-started)
    + [New App](#new-app)
    + [Existing App](#existing-app)
+ [Configuration](#configuration)
+ [Running Writefully](#running-writefully)
+ [Tunneling](#tunneling)
+ [Admin Interface](#admin-interface)
+ [Who uses Writefully?](#who-uses-writefully)
+ [Why did you make Writefully?](#why-did-you-make-writefully)
    + [Why don't you use Jekyll / Middleman](#why-dont-you-just-use-static-page-generators-like-jekyll-or-middleman)

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

## Configuration

### Github Application

Writefully integrates with github, which means you'll need to set up a github application.

[Create new Application](https://github.com/settings/applications/new)

Or just create an application in an organization.

### Config file (app/config/writefully.yml)

You'll need to fill out the configuration file for your development environment

```yaml
development: &default
  :pidfile: '/Users/zacksiri/Repositories/blogosphere/tmp/pids/writefully.pid'
  :logfile: '/Users/zacksiri/Repositories/blogosphere/log/writefully.log'
  :content: '/Users/zacksiri/Repositories/blogosphere/content' # create a content folder for development
  :storage_key: 'AKIAIYSBJGEBTA35XDOA'
  :storage_secret: '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'
  :storage_folder: 'codemy-backup'
  :storage_provider: "AWS" # only supports AWS for now
  :app_directory: '/Users/zacksiri/Repositories/blogosphere'
  :github_client: '5c3285c9e7c7098c4b47'
  :github_secret: 'd2a8546dec21f58bb3bc3f68906b15acbb295380'
  :hook_secret: '607c1d7688d4a3024a680b5101f90544' 

test:
  <<: *default
```

These settings might seem obvious in development however you might want to change this in your production / staging environment. We assume you use capistrano style deployment where you have a separate config for those environments

The `hook_secret` config is required to ensure that any web hooks you get from github is legitimate. You can generate it with anything you like. The most simplest thing to do is go into IRB and run

```ruby
require 'securerandom' ; SecureRandom.hex
```

I recommend you use a different one in production / staging than the one in development.

## Running Writefully

In development to run writefully all you have to do is 

```bash
# from your app root
bin/writefully start config/writefully.yml
```

This will start the writefully process and start listening for changes in the `:content` folder.

## Tunneling

If you want to test the github webhook process you'll need to use some  tunneling magic. Here are a few options to choose from.

+ [Ngrok](https://ngrok.com/)
+ [localtunnel npm](http://localtunnel.me/)
+ [localtunnel gem](http://progrium.com/localtunnel/)

For development mode use the localtunnel url when you fill out the details for site creation. The url will be used with github webhooks

## Admin Interface

Once you've set everything up simply head over to

```bash
http://localhost:3000/writefully
```

You will be asked to sign in with github. Once your logged in you'll have access to the admin interface and will be promted to setup your first site.

Once you create your first site simply head over to the repository in your github account and follow the readme there.

## Who uses Writefully?

[Codemy.net](http://codemy.net) Is powered by Writefully

## Why did you make writefully?

I just want to write locally using my text editor in markdown, intead of logging into the admin interface and wrangling with the online editor and mucking about with image uploading.

I just want to do a git push and the server takes care of the rest (updating content / assets uploading etc...). The same way I deploy my applications.

### Why don't you just use static page generators like Jekyll or Middleman?

Because I need real business objects. 

+ I want to have control over my content. I want to be able to control which user can see which content. (needed if you want to sell digital goods)

+ I want to use full text search technologies like Elasticsearch or in Database Full Text Search. 

+ I want to be able to taxonomize my content, put them into groups etc...


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
  + Quill JS
  + More details to come

+ Writefully mobile app
  + Probably going to use [Framework7](http://www.idangero.us/framework7/)
  + More details to come
