+++
date = "2017-03-04T23:00:00+01:00"
draft = false
description = "Google App Engine + Letsencrypt"
keywords = ["Google App Engine", "letsencrypt", "certificate", "renewal"]
title = "Letsencrypt Certificate Renewal for Google App Engine"
type = "post"
+++

##### Intro
I've been using letsencrypt for [vphone](https://vphone.io) for a while, and
every time I need to renew the certificates, I face new problems and surprises.
Originally I had setup letsencrypt for my website by following 
[this](https://medium.com/google-cloud/let-s-encrypt-with-app-engine-8047b0642895#.2agz42674).
Tonight, the problem was that I was getting the following error when going
through my notes on how to renew the certificates, just after running
``letsencrypt/letsencrypt-auto renew`` in [certbot](https://github.com/certbot/certbot):

```nohighlight
Attempting to renew cert from /etc/letsencrypt/renewal/vphone.io-0002.conf produced an unexpected error: The manual plugin is not working; there may be problems with your existing configuration.
The error was: PluginError('An authentication script must be provided with --manual-auth-hook when using the manual plugin non-interactively.',). Skipping.
```

##### The Problem

Looking for the cause, I saw that [a new parameter has been added to
the manual plugin](https://github.com/certbot/certbot/blob/master/CHANGELOG.md#01112017)
of [certbot](https://github.com/certbot/certbot) which was stopping me from renewing the
certificates. 


##### The Solution

To solve the issue, I added a small bash script to my project to help
in automating the letsencrypt website validation under letsencrypt directory of my 
GAE project:

```bash
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CERTBOT_VALIDATION" > "$DIR/.well-known/acme-challenge/$CERTBOT_TOKEN"
gcloud app deploy -q "$DIR/../app.yaml"
```

The above script will put the challenge provided by letsencrypt into the correct location
in my project and deploys the project to GAE.

Then, I changed the previous configuration of letsencrypt to use the above script,
by adding the last line to the contents of /etc/letsencrypt/renewal/vphone.io-0002.conf:

```nohighlight
# renew_before_expiry = 30 days
version = 0.12.0
cert = /etc/letsencrypt/live/vphone.io-0002/cert.pem
privkey = /etc/letsencrypt/live/vphone.io-0002/privkey.pem
chain = /etc/letsencrypt/live/vphone.io-0002/chain.pem
fullchain = /etc/letsencrypt/live/vphone.io-0002/fullchain.pem
archive_dir = /etc/letsencrypt/archive/vphone.io-0002

# Options used in the renewal process
[renewalparams]
authenticator = manual
installer = None
account = <hidden>
manual_public_ip_logging_ok = True
manual_auth_hook = /home/user/my-appengine-project/letsencrypt/auth_hook.sh
```

Running ``letsencrypt/letsencrypt-auto renew`` again, I did not see any errors this time,
and the certificates were generated successfully. The next step was uploading the new certificates
to the GAE, as described in the post I mentioned in the beginning.
