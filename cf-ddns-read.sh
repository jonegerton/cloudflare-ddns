#!/bin/sh
# Reads all dns records for a cloudflare hosted domain.
# Use this to get the domain id required for cloudflare ddns updates 
# (is rec_id in the saved json at ~/.cf-dns.txt)
#
# Created 25-Feb-2015 Jon Egerton, from the rec_load_all documentation here: 
# https://www.cloudflare.com/docs/client-api.html
#
# This version is working as at 25-Feb-2015
# As/When cloudflare change their API amendments may be required
# Latest versions are here: https://github.com/jonegerton/cloudflare-ddns

cfkey=API_KEY_HERE
cfuser=EMAIL_HERE
domain=DOMAIN_HERE

curl https://www.cloudflare.com/api_json.html \
  -d a=rec_load_all \
  -d tkn=$cfkey \
  -d email=$cfuser \
  -d z=$domain > $HOME/.cf-dns.txt
