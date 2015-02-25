#!/bin/sh
# modified by jfro from http://www.cnysupport.com/index.php/linode-dynamic-dns-ddn$
# Update: changed because the old IP-service wasn't working anymore
# Uses curl to be compatible with machines that don't have wget by default
# modified by Ross Hosman for use with cloudflare.
# modified by Jon Egerton to add logging
#
# This version is working as at 25-Feb-2015
# As/When cloudflare change their API amendments may be required
# Latest versions of these scripts are here: https://github.com/jonegerton/cloudflare-ddns
#
# Place at:
# /usr/local/bin/cf-ddns.sh
# run `crontab -e` and add next line:
# /5 * * * * bash /usr/local/bin/cf-ddns.sh >/dev/null 2>&1

cfkey=API_KEY_HERE
cfuser=EMAIL_HERE
cfhost=HOST_HERE (this is the specific home/subdomain line to be updated)
cfid=API_ID_HERE (see separate script to get this)
domain=DOMAIN_HERE

log=$HOME/.cf-dns-update.log
date +"%F %T" >> $log

WAN_IP=`curl -s http://icanhazip.com`
if [ -f $HOME/.wan_ip-cf.txt ]; then
        OLD_WAN_IP=`cat $HOME/.wan_ip-cf.txt`
else
        echo "No file, need IP" >> $log
        OLD_WAN_IP=""
fi

if [ "$WAN_IP" = "$OLD_WAN_IP" ]; then
        echo  "IP Unchanged" >> $log
else
        echo $WAN_IP > $HOME/.wan_ip-cf.txt
        echo "Updating DNS to $WAN_IP" >> $log
         curl https://www.cloudflare.com/api_json.html \
          -d a=rec_edit \
          -d tkn=$cfkey \
          -d email=$cfuser \
          -d z=$domain \
          -d id=$cfid \
          -d type=A \
          -d name=$cfhost \
          -d ttl=1 \
          -d "content=$WAN_IP" >> $log
fi
