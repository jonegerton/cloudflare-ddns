#!/bin/sh
# Reads a dns records for a desired host from cloudflare hosted zone.
# Use this to get the domain id required for cloudflare ddns updates 
# (is ID in the saved json at cf-ddns.json)
#
# Created 8-Aug-2018 Jon Egerton, from the Cloudflare API V4 documentation here: 
# https://api.cloudflare.com/#dns-records-for-a-zone-dns-record-details
#
# This version is working as at 8-Aug-2018
# As/When cloudflare change their API amendments may be required
# Latest versions are here: https://github.com/jonegerton/cloudflare-ddns
#
# Use strictly at your own risk

#Set values below
cfuser= #Account user name
cfkey= #Global API Key from My Account > API Keys
cfzonekey= #Zone ID from zone overview page
cfhost= #Name of the host entry

curl -X GET "https://api.cloudflare.com/client/v4/zones/$cfzonekey/dns_records?type=A&name=$cfhost" \
  -H "X-Auth-Key: $cfkey " \
  -H "X-Auth-Email: $cfuser" \
  -H "Content-Type: application/json" > ./cf-ddns.json
