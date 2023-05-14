#!/bin/bash
cat <<EOF

                _________              __                  __  .__
               /   _____/____    _____/  |_  ____  _______/  |_|__|
               \_____  \__   \  /    \   __\/  _ \/  ___/\   __\  |
               /        \/ __ \|   |  \  | (  <_> )___ \  |  | |  |
              /_______  (____  /___|  /__|  \____/____  > |__| |__|
 =====================\/=====\/=====\/================\/=======================
                         Zimbra Certificate Renew Tool
 ==============================================================================
   Date............ 05/14/2023              Version....... V2.0
   By.............. Michael Santosti        Target........ Zimbra 8GA
 ==============================================================================

EOF

# Catching Zimbra Domain
mailhost=$(runuser -l zimbra -c 'zmhostname')

echo
echo "Domain Name:"
echo  $mailhost
echo

# Check if Certificates are OK
if [[ $(runuser -l zimbra -c 'export mailhost=$(zmhostname) && zmcertmgr verifycrt comm /opt/zimbra/ssl/zimbra/commercial/commercial.key /etc/letsencrypt/live/$mailhost/cert.pem /etc/letsencrypt/live/$mailhost/chain.pem') = *OK* ]];  then
    echo Certificate OK.
else

# Stop Zimbra Mail
runuser -l zimbra -c 'zmcontrol stop'

# Renew Certificates
certbot renew --standalone

# Copy Certificates (Avoid Limit Rate)
cp /etc/letsencrypt/live/$mailhost/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
chown zimbra:zimbra /opt/zimbra/ssl/zimbra/commercial/commercial.key

# Download Latest CA
wget -O /tmp/ISRG-X1.pem https://letsencrypt.org/certs/isrgrootx1.pem
wget -O /tmp/R3.pem https://letsencrypt.org/certs/lets-encrypt-r3.pem

# Copy X1 Auth to Chain
latestchain=$(ls /etc/letsencrypt/archive/$mailhost/chain* -tp | grep -v /$ | head -1)
cat /tmp/R3.pem > $latestchain
cat /tmp/ISRG-X1.pem >> $latestchain

# Deploy that shit
runuser -l zimbra -c 'export mailhost=$(zmhostname) && zmcertmgr deploycrt comm /etc/letsencrypt/live/$mailhost/cert.pem /etc/letsencrypt/live/$mailhost/chain.pem'
runuser -l zimbra -c 'zmcontrol start'

fi

