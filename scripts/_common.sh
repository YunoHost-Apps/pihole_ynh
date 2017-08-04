#!/bin/bash

# =============================================================================
#                     YUNOHOST 2.7 FORTHCOMING HELPERS
# =============================================================================

# Create a dedicated nginx config
#
# usage: ynh_add_nginx_config
ynh_add_nginx_config () {
	finalnginxconf="/etc/nginx/conf.d/$domain.d/$app.conf"
	ynh_backup_if_checksum_is_different "$finalnginxconf"
	sudo cp ../conf/nginx.conf "$finalnginxconf"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${path_url:-}"; then
		ynh_replace_string "__PATH__" "$path_url" "$finalnginxconf"
	fi
	if test -n "${domain:-}"; then
		ynh_replace_string "__DOMAIN__" "$domain" "$finalnginxconf"
	fi
	if test -n "${port:-}"; then
		ynh_replace_string "__PORT__" "$port" "$finalnginxconf"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__NAME__" "$app" "$finalnginxconf"
	fi
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finalnginxconf"
	fi
	ynh_store_file_checksum "$finalnginxconf"

	sudo systemctl reload nginx
}

# Remove the dedicated nginx config
#
# usage: ynh_remove_nginx_config
ynh_remove_nginx_config () {
	ynh_secure_remove "/etc/nginx/conf.d/$domain.d/$app.conf"
	sudo systemctl reload nginx
}

# Create a dedicated php-fpm config
#
# usage: ynh_add_fpm_config
ynh_add_fpm_config () {
	finalphpconf="/etc/php5/fpm/pool.d/$app.conf"
	ynh_backup_if_checksum_is_different "$finalphpconf"
	sudo cp ../conf/php-fpm.conf "$finalphpconf"
	ynh_replace_string "__NAMETOCHANGE__" "$app" "$finalphpconf"
	ynh_replace_string "__FINALPATH__" "$final_path" "$finalphpconf"
	ynh_replace_string "__USER__" "$app" "$finalphpconf"
	sudo chown root: "$finalphpconf"
	ynh_store_file_checksum "$finalphpconf"

	if [ -e "../conf/php-fpm.ini" ]
	then
		finalphpini="/etc/php5/fpm/conf.d/20-$app.ini"
		ynh_backup_if_checksum_is_different "$finalphpini"
		sudo cp ../conf/php-fpm.ini "$finalphpini"
		sudo chown root: "$finalphpini"
		ynh_store_file_checksum "$finalphpini"
	fi

	sudo systemctl reload php5-fpm
}

# Remove the dedicated php-fpm config
#
# usage: ynh_remove_fpm_config
ynh_remove_fpm_config () {
	ynh_secure_remove "/etc/php5/fpm/pool.d/$app.conf"
	ynh_secure_remove "/etc/php5/fpm/conf.d/20-$app.ini" 2>&1
	sudo systemctl reload php5-fpm
}

# Create a dedicated systemd config
#
# usage: ynh_add_systemd_config
ynh_add_systemd_config () {
	finalsystemdconf="/etc/systemd/system/$app.service"
	ynh_backup_if_checksum_is_different "$finalsystemdconf"
	sudo cp ../conf/systemd.service "$finalsystemdconf"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finalsystemdconf"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__APP__" "$app" "$finalsystemdconf"
	fi
	ynh_store_file_checksum "$finalsystemdconf"

	sudo chown root: "$finalsystemdconf"
	sudo systemctl enable $app
	sudo systemctl daemon-reload
}

# Remove the dedicated systemd config
#
# usage: ynh_remove_systemd_config
ynh_remove_systemd_config () {
	finalsystemdconf="/etc/systemd/system/$app.service"
	if [ -e "$finalsystemdconf" ]; then
		sudo systemctl stop $app
		sudo systemctl disable $app
		ynh_secure_remove "$finalsystemdconf"
	fi
}

#=================================================
#=================================================

#=================================================
# CHECKING
#=================================================

CHECK_DOMAINPATH () {	# Vérifie la disponibilité du path et du domaine.
	# Check availability of a web path
	ynh_webpath_available $domain $path_url
	# Register/book a web path for an app
	ynh_webpath_register $app $domain $path_url
}

CHECK_FINALPATH () {	# Vérifie que le dossier de destination n'est pas déjà utilisé.
	final_path=/var/www/$app
	test ! -e "$final_path" || ynh_die "This path already contains a folder"
}

#=================================================
# DISPLAYING
#=================================================

NO_PRINT () {	# Supprime l'affichage dans stdout pour la commande en argument.
	set +x
	$@
	set -x
}

WARNING () {	# Écrit sur le canal d'erreur pour passer en warning.
	$@ >&2
}

SUPPRESS_WARNING () {	# Force l'écriture sur la sortie standard
	$@ 2>&1
}

QUIET () {	# Redirige la sortie standard dans /dev/null
	$@ > /dev/null
}

ALL_QUIET () {	# Redirige la sortie standard et d'erreur dans /dev/null
	$@ > /dev/null 2>&1
}

#=================================================
# BACKUP
#=================================================

BACKUP_FAIL_UPGRADE () {
	WARNING echo "Upgrade failed."
	app_bck=${app//_/-}	# Replace all '_' by '-'
	if sudo yunohost backup list | grep -q $app_bck-pre-upgrade$backup_number; then	# Vérifie l'existence de l'archive avant de supprimer l'application et de restaurer
		sudo yunohost app remove $app	# Supprime l'application avant de la restaurer.
		sudo yunohost backup restore --ignore-system $app_bck-pre-upgrade$backup_number --apps $app --force	# Restore the backup if upgrade failed
		ynh_die "The app was restored to the way it was before the failed upgrade."
	fi
}

BACKUP_BEFORE_UPGRADE () {	# Backup the current version of the app, restore it if the upgrade fails
	backup_number=1
	old_backup_number=2
	app_bck=${app//_/-}	# Replace all '_' by '-'
	if sudo yunohost backup list | grep -q $app_bck-pre-upgrade1; then	# Vérifie l'existence d'une archive déjà numéroté à 1.
		backup_number=2	# Et passe le numéro de l'archive à 2
		old_backup_number=1
	fi

	sudo yunohost backup create --ignore-system --apps $app --name $app_bck-pre-upgrade$backup_number	# Créer un backup différent de celui existant.
	if [ "$?" -eq 0 ]; then	# Si le backup est un succès, supprime l'archive précédente.
		if sudo yunohost backup list | grep -q $app_bck-pre-upgrade$old_backup_number; then	# Vérifie l'existence de l'ancienne archive avant de la supprimer, pour éviter une erreur.
			QUIET sudo yunohost backup delete $app_bck-pre-upgrade$old_backup_number
		fi
	else	# Si le backup a échoué
		ynh_die "Backup failed, the upgrade process was aborted."
	fi
}

HUMAN_SIZE () {	# Transforme une taille en Ko en une taille lisible pour un humain
	human=$(numfmt --to=iec --from-unit=1K $1)
	echo $human
}

CHECK_SIZE () {	# Vérifie avant chaque backup que l'espace est suffisant
	file_to_analyse=$1
	backup_size=$(sudo du --summarize "$file_to_analyse" | cut -f1)
	free_space=$(sudo df --output=avail "/home/yunohost.backup" | sed 1d)

	if [ $free_space -le $backup_size ]
	then
		WARNING echo "Espace insuffisant pour sauvegarder $file_to_analyse."
		WARNING echo "Espace disponible: $(HUMAN_SIZE $free_space)"
		ynh_die "Espace nécessaire: $(HUMAN_SIZE $backup_size)"
	fi
}

# Ce helper est temporaire et sert de remplacement à la véritable fonction ynh_restore_file. Le temps qu'elle arrive...
ynh_restore_file () {
	if [ -f "$1" ]; then
		ynh_die "There is already a file at this path: $1"
	fi
	sudo cp -a "${YNH_APP_BACKUP_DIR}$1" "$1"
}

#=================================================
# PACKAGE CHECK BYPASSING...
#=================================================

IS_PACKAGE_CHECK () {	# Détermine une exécution en conteneur (Non testé)
	return $(uname -n | grep -c 'pchecker_lxc')
}

#=================================================
# NODEJS
#=================================================

# INFOS
# n (Node version management) utilise la variable PATH pour stocker le path de la version de node à utiliser.
# C'est ainsi qu'il change de version
# ynh_install_nodejs installe la version de nodejs demandée en argument, avec n
# ynh_use_nodejs active une version de nodejs dans le script courant
# 3 variables sont mises à disposition, et 2 sont stockées dans la config de l'app
# - nodejs_path: Le chemin absolu de cette version de node
# Utilisé pour des appels directs à node.
# - nodejs_version: Simplement le numéro de version de nodejs pour cette application
# - nodejs_use_version: Un alias pour charger une version de node dans le shell courant.
# Utilisé pour démarrer un service ou un script qui utilise node ou npm
# Dans ce cas, c'est $PATH qui contient le chemin de la version de node. Il doit être propagé sur les autres shell si nécessaire.

n_install_dir="/opt/node_n"
node_version_path="/usr/local/n/versions/node"
ynh_use_nodejs () {
	nodejs_version=$(ynh_app_setting_get $app nodejs_version)

	load_n_path="[[ :$PATH: == *\":$n_install_dir/bin:\"* ]] || PATH=\"$n_install_dir/bin:$PATH\""

	nodejs_use_version="$n_install_dir/bin/n -q $nodejs_version"

	# "Load" a version of node
	eval $load_n_path; $nodejs_use_version

	# Get the absolute path of this version of node
	nodejs_path="$(n bin $nodejs_version)"

	# Make an alias for node use
	ynh_node_exec="eval $load_n_path; n use $nodejs_version"
}

ynh_install_nodejs () {
	# Use n, https://github.com/tj/n to manage the nodejs versions
	nodejs_version="$1"
	local n_install_script="https://git.io/n-install"

	# Create $n_install_dir
	mkdir -p "$n_install_dir"

	# Load n path in PATH
	CLEAR_PATH="$n_install_dir/bin:$PATH"
	# Remove /usr/local/bin in PATH in case of node has already setup.
	PATH=$(echo $CLEAR_PATH | sed 's@/usr/local/bin:@@')

	# Move an existing node binary, to avoid to block n.
	test -x /usr/bin/node && mv /usr/bin/node /usr/bin/node_n
	test -x /usr/bin/npm && mv /usr/bin/npm /usr/bin/npm_n

	# If n is not previously setup, install it
	n --version > /dev/null 2>&1 || \
	( echo "Installation of N - Node.js version management" >&2; \
	curl -sL $n_install_script | N_PREFIX="$n_install_dir" bash -s -- -y - )

	# Restore /usr/local/bin in PATH
	PATH=$CLEAR_PATH

	# And replace the old node binary.
	test -x /usr/bin/node_n && mv /usr/bin/node_n /usr/bin/node
	test -x /usr/bin/npm_n && mv /usr/bin/npm_n /usr/bin/npm

	# Install the requested version of nodejs
	n $nodejs_version

	# Find the last "real" version for this major version of node.
	real_nodejs_version=$(find $node_version_path/$nodejs_version* -maxdepth 0 | sort --version-sort | tail --lines=1)
	real_nodejs_version=$(basename $real_nodejs_version)

	# Create a symbolic link for this major version
	ln --symbolic --force --no-target-directory $node_version_path/$real_nodejs_version $node_version_path/$nodejs_version

	# Store the ID of this app and the version of node requested for it
	echo "$YNH_APP_ID:$nodejs_version" | tee --append "$n_install_dir/ynh_app_version"

	# Store nodejs_version into the config of this app
	ynh_app_setting_set $app nodejs_version $nodejs_version

	# Build the update script and set the cronjob
	ynh_cron_upgrade_node

	ynh_use_nodejs
}

ynh_remove_nodejs () {
	ynh_use_nodejs

	# Remove the line for this app
	sed --in-place "/$YNH_APP_ID:$nodejs_version/d" "$n_install_dir/ynh_app_version"

	# If none another app uses this version of nodejs, remove it.
	if ! grep --quiet "$nodejs_version" "$n_install_dir/ynh_app_version"
	then
		n rm $nodejs_version
	fi

	# If none another app uses n, remove n
	if [ ! -s "$n_install_dir/ynh_app_version" ]
	then
		ynh_secure_remove "$n_install_dir"
		ynh_secure_remove "/usr/local/n"
		sed --in-place "/N_PREFIX/d" /root/.bashrc
	fi
}

ynh_cron_upgrade_node () {
	# Build the update script
	cat > "$n_install_dir/node_update.sh" << EOF
#!/bin/bash

version_path="$node_version_path"
n_install_dir="$n_install_dir"

# Log the date
date

# List all real installed version of node
all_real_version="\$(find \$version_path/* -maxdepth 0 -type d | sed "s@\$version_path/@@g")"

# Keep only the major version number of each line
all_real_version=\$(echo "\$all_real_version" | sed 's/\..*\$//')

# Remove double entries
all_real_version=\$(echo "\$all_real_version" | sort --unique)

# Read each major version
while read version
do
	echo "Update of the version \$version"
	sudo \$n_install_dir/bin/n \$version

	# Find the last "real" version for this major version of node.
	real_nodejs_version=\$(find \$version_path/\$version* -maxdepth 0 | sort --version-sort | tail --lines=1)
	real_nodejs_version=\$(basename \$real_nodejs_version)

	# Update the symbolic link for this version
	sudo ln --symbolic --force --no-target-directory \$version_path/\$real_nodejs_version \$version_path/\$version
done <<< "\$(echo "\$all_real_version")"
EOF

	chmod +x "$n_install_dir/node_update.sh"

	# Build the cronjob
	cat > "/etc/cron.daily/node_update" << EOF
#!/bin/bash

$n_install_dir/node_update.sh >> $n_install_dir/node_update.log
EOF

	chmod +x "/etc/cron.daily/node_update"
}
