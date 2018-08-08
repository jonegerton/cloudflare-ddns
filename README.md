# cloudflare-ddns
Scripts for updating the Cloudflare DDNS Api

These scripts are working as at 08-Aug-2018. Changes to the api by CloudFlare will likely break them.

CloudFlare's documentation for the Apis used [is here](https://api.cloudflare.com).

These scripts are also discussed [at my blog here](http://www.jonegerton.com/raspberrypi/cloudflare-ddns-updates-aug-2018-edition/)

####cf-ddns.sh:

Updates CloudFlare for DDNS
Based on the commented update by @deluxor on here: https://gist.github.com/larrybolt/6295160
Since modified to track CloudFlare API updates

####cf-ddns-read.sh:

Reads CloudFlare DNS settings
Mainly required for getting the home id parameter for the dns entry to set in the cf-ddns script
