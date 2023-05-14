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
   Date............ 05/14/2023              Version....... V2.0-hook
   By.............. Michael Santosti        Target........ Zimbra 8GA
 ==============================================================================

EOF

#Set Working Directory
DIR_WORK="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cat <<EOF
 ========================================
 ==== Copying post-renew hook script ====
 ========================================

EOF
sudo cp $DIR_WORK/letsencrypt_hooks/santosti_post_certscript.sh /etc/letsencrypt/renewal-hooks/post/santosti_post_certscript.sh

cat <<EOF
 ========================================
 ====  Copying pre-renew hook script ====
 ========================================

EOF
sudo cp $DIR_WORK/letsencrypt_hooks/santosti_pre_certscript.sh /etc/letsencrypt/renewal-hooks/pre/santosti_pre_certscript.sh

cat <<EOF
 ========================================
 ====     Grant exec permissions     ====
 ========================================

EOF
sudo chmod +x /etc/letsencrypt/renewal-hooks/post/santosti_post_certscript.sh
sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/santosti_pre_certscript.sh

cat <<EOF
 ========================================
 ====           Done :D              ====
 ========================================

EOF
