+++
date = "2016-07-15T00:00:00+01:00"
draft = false
description = "Google App Engine PHP Development"
keywords = ["Google App Engine", "PHP"]
title = "Google App Engine PHP Development"
type = "post"
+++

##### Intro
Me and a few friends are working on a new idea named [vphone](https://vphone.io)
The website is developed using wordpress, and we are trying to run it on Google
App Engine. Google App Engine uses PHP 5.5, which is pretty old. It looks like they
want to drop PHP, or maybe they want to drop the whole App Engine in favor of
[Flexible Environments](https://cloud.google.com/appengine/docs/flexible/).
But, I'm pretty accustomed to App Engine, and App Engine still costs less.

##### The Problem
To prepare a development environment in Ubuntu, Google
[suggests to install PHP 5](https://cloud.google.com/appengine/downloads#Google_App_Engine_SDK_for_PHP)
but Ubuntu 16.04 has dropped support for PHP 5. Getting PHP 5.5 from
[other PPAs](http://tecadmin.net/install-php5-on-ubuntu/#) is possible, but
still going through all the details to have an easy development setup is a pain.


##### The Solution
I created a docker image that contains all you need to run your Google App Engine
PHP apps locally. Here you can find the repository:
https://github.com/mhariri/docker-google-appengine-php
