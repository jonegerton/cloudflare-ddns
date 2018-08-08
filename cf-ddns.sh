
#!/bin/sh
# modified by jfro from http://www.cnysupport.com/index.php/linode-dynamic-dns-ddn$
# Update: changed because the old IP-service wasn't working anymore
# Uses curl to be compatible with machines that don't have wget by default
# modified by Ross Hosman for use with cloudflare.
# modified by Jon Egerton to add logging
# modified by Jon Egerton to update to cloud flare api v4 (see https://api.cloudflare.com)
#
# This version is working as at 8-Aug-2018
# As/When cloudflare change their API amendments may be required
# Latest versions of these scripts are here: https://github.com/jonegerton/cloudflare-ddns
#
# To schedule:
# run `crontab -e` and add next line (without the leading #):
# */5 * * * * bash {set file location here}/cf-ddns.sh >/dev/null 2>&1
# this will run the script every 5 minutes. The IP is cached, so requests are only sent 
# when the WAN IP has changed. Log output is minimal, so shouldn't grow too large.
#
# Use strictly at your own risk

cfuser= #Account user name
cfkey= #Global API Key from My Account > API Keys
cfzonekey= #Zone ID from zone overview page
cfhost= #Name of the host entry
cfhostkey= #ID of the host entry (run cf-ddns-read.sh)
cfttl=1 #=automatic - needs to be set in curl request otherwise reverts to a default. Set to the correct value
cfproxied=true # also needs to eb set in curl request otherwise reverts to false. Set to the correct value

log=/var/log/cf-ddns-update.log #Set to desired log output location

date +"%F %T" >> $log

WAN_IP=`curl -s http://icanhazip.com`
if [ -f wan_ip-cf.txt ]; then
        OLD_WAN_IP=`cat wan_ip-cf.txt`
else
        echo "No file, need IP" >> $log
        OLD_WAN_IP=""
fi

if [ "$WAN_IP" = "$OLD_WAN_IP" ]; then
        echo  "IP Unchanged" >> $log
else
        echo $WAN_IP > wan_ip-cf.txt
        echo "Updating DNS to $WAN_IP" >> $log

data="{\"type\":\"A\",\"name\":\"$cfhost\",\"content\":\"$WAN_IP\",\"ttl\":$cfttl,\"proxied\":$cfproxied}"
echo "data: $data" >> $log

curl -X PUT "https://api.cloudflare.com/client/v4/zones/$cfzonekey/dns_records/$cfhostkey" \
	-H "X-Auth-Key: $cfkey" \
	-H "X-Auth-Email: $cfuser" \
	-H "Content-Type: application/json" \
	--data $data >> $log

fi
