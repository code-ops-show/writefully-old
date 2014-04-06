# Writefully

[![Build Status](https://travis-ci.org/codemy/writefully.svg?branch=master)](https://travis-ci.org/codemy/writefully) [![Coverage Status](https://coveralls.io/repos/codemy/writefully/badge.png?branch=master)](https://coveralls.io/r/codemy/writefully?branch=master)

Allows developers who love to write to publish easily

# Manifesto

+ Writefully Process
  + Separate lightweight process that manages all the work
  + Main rails process should be able to communicate with Writefully via ZMQ
    + When a site is created it sets up a sample repository
  + Easily Extendable from main rails app
  + Backend Interface for managing sites
  + Turn a github repository into a full blown CMS
    + Receive WebHook from github and updates site
    + Turns repository collaborators into authors
    + Converts local based images into content provider URL
      + S3 / Cloudfront
      + Akamai
      + Cloudfiles
      + etc...

+ Writefully Desktop App
  + Probably going to use !(node-webkit)[https://github.com/rogerwang/node-webkit]
  + More details to com

+ Writefully mobile app
  + Probably going to use !(Framework7)[http://www.idangero.us/framework7/]
  + More details to come
