#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

pihole_adminlte_version=5.18
pihole_flt_version=5.20

# This is hard-coded upstream...
PI_HOLE_LOCAL_REPO="/etc/.pihole"
PI_HOLE_INSTALL_DIR="/opt/pihole"
PI_HOLE_CONFIG_DIR="/etc/pihole"
PI_HOLE_BIN_DIR="/usr/local/bin"

# Get the default network interface
main_iface=$(ip route | grep --max-count=1 default | awk '{print $5;}')

# Get the dnsmasq user to set log files permissions
dnsmasq_user=$(grep DNSMASQ_USER= /etc/init.d/dnsmasq | cut -d'"' -f2)

# Find the IP associated to the network interface
localipv4=$(ip address | grep "${main_iface}\$" | awk '{print $2;}' | cut -d/ -f1)

if [ "$query_logging" -eq 1 ]; then
    query_logging_str=true
else
    query_logging_str=false
fi

#=================================================
# PERSONAL HELPERS
#=================================================

_configure_ports() {
    if [ "$port" -gt 4720 ]; then
        ynh_die --message="The ports 4711 to 4720 are already in use. Pi-hole can't work on another port. Please try to free one of these ports."
    fi

    # Disable the port 53 for upnp
    ynh_exec_fully_quiet yunohost firewall disallow Both 53 --no-reload
    ynh_exec_fully_quiet yunohost firewall allow Both 53 --no-upnp

    # Open the UDP port 67 for dhcp
    ynh_exec_fully_quiet yunohost firewall allow UDP 67 --no-upnp
}

_add_cron_jobs() {
    install -D -m 644 -T -o root -g root "$PI_HOLE_LOCAL_REPO/advanced/Templates/pihole.cron" /etc/cron.d/pihole

    # Randomize gravity update time
    ynh_replace_string --target_file="/etc/cron.d/pihole" \
        --match_string="59 1 " \
        --replace_string="$((1 + RANDOM % 58)) $((3 + RANDOM % 2)) "

    # Randomize update checker time
    ynh_replace_string --target_file="/etc/cron.d/pihole" \
        --match_string="59 17" \
        --replace_string="$((1 + RANDOM % 58)) $((12 + RANDOM % 8))"

    # Remove git usage for version. Which fails because we use here a release instead of master.
    ynh_replace_string --target_file="/etc/cron.d/pihole" \
        --match_string=".*updatechecker.*" \
        --replace_string="#&"
}

_add_sudoers_config() {
    install -m 0640 "$PI_HOLE_LOCAL_REPO/advanced/Templates/pihole.sudo" /etc/sudoers.d/pihole
    echo "$app ALL=NOPASSWD: ${PI_HOLE_BIN_DIR}/pihole" >> /etc/sudoers.d/pihole
}

_add_logrotate_config() {
    install -D -m 644 -T "${PI_HOLE_LOCAL_REPO}"/advanced/Templates/logrotate "$PI_HOLE_CONFIG_DIR/logrotate"
    sed -i "/# su #/d;" "$PI_HOLE_CONFIG_DIR/logrotate"
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

ynh_maintenance_mode_ON () {
	mkdir -p /var/www/html/

	# Create an html to serve as maintenance notice
	echo "<!DOCTYPE html>
<html>
<head>
<meta http-equiv="refresh" content="3">
<title>Your app $app is currently under maintenance!</title>
<style>
	body {
		width: 70em;
		margin: 0 auto;
	}
</style>
</head>
<body>
<h1>Your app $app is currently under maintenance!</h1>
<p>This app has been put under maintenance by your administrator at $(date)</p>
<p>Please wait until the maintenance operation is done. This page will be reloaded as soon as your app will be back.</p>

</body>
</html>" > "/var/www/html/maintenance.$app.html"

	# Create a new nginx config file to redirect all access to the app to the maintenance notice instead.
	echo "# All request to the app will be redirected to ${path}_maintenance and fall on the maintenance notice
rewrite ^${path}/(.*)$ ${path}_maintenance/? redirect;
# Use another location, to not be in conflict with the original config file
location ${path}_maintenance/ {
alias /var/www/html/ ;

try_files maintenance.$app.html =503;

# Include SSOWAT user panel.
include conf.d/yunohost_panel.conf.inc;
}" > "/etc/nginx/conf.d/$domain.d/maintenance.$app.conf"

	# The current config file will redirect all requests to the root of the app.
	# To keep the full path, we can use the following rewrite rule:
	# 	rewrite ^${path}/(.*)$ ${path}_maintenance/\$1? redirect;
	# The difference will be in the $1 at the end, which keep the following queries.
	# But, if it works perfectly for a html request, there's an issue with any php files.
	# This files are treated as simple files, and will be downloaded by the browser.
	# Would be really be nice to be able to fix that issue. So that, when the page is reloaded after the maintenance, the user will be redirected to the real page he was.

	systemctl reload nginx
}

ynh_maintenance_mode_OFF () {
	# Rewrite the nginx config file to redirect from ${path}_maintenance to the real url of the app.
	echo "rewrite ^${path}_maintenance/(.*)$ ${path}/\$1 redirect;" > "/etc/nginx/conf.d/$domain.d/maintenance.$app.conf"
	systemctl reload nginx

	# Sleep 4 seconds to let the browser reload the pages and redirect the user to the app.
	sleep 4

	# Then remove the temporary files used for the maintenance.
	rm "/var/www/html/maintenance.$app.html"
	rm "/etc/nginx/conf.d/$domain.d/maintenance.$app.conf"

	systemctl reload nginx
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
