# Pihole-Sync
Synchronize Pihole servers DNS A and CNAME records

Download the script and add a crontab job to automatically sync. SSH keys should be used for auth between servers.

Crontab sync every 15 minutes example:
*/15 * * * * /usr/local/bin/sync_pihole_lists.sh >> /var/log/sync_pihole.log 2>&1
