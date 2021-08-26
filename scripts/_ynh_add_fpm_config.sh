#!/bin/bash

# To be removed after the 4.3

ynh_add_fpm_config () {
    # Declare an array to define the options of this helper.
    local legacy_args=vtufpd
    local -A args_array=( [v]=phpversion= [t]=use_template [u]=usage= [f]=footprint= [p]=package= [d]=dedicated_service )
    local phpversion
    local use_template
    local usage
    local footprint
    local package
    local dedicated_service
    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"
    package=${package:-}

    # The default behaviour is to use the template.
    use_template="${use_template:-1}"
    usage="${usage:-}"
    footprint="${footprint:-}"
    if [ -n "$usage" ] || [ -n "$footprint" ]; then
        use_template=0
    fi
    # Do not use a dedicated service by default
    dedicated_service=${dedicated_service:-0}

    # Set the default PHP-FPM version by default
    phpversion="${phpversion:-$YNH_PHP_VERSION}"

    local old_phpversion=$(ynh_app_setting_get --app=$app --key=phpversion)

    # If the PHP version changed, remove the old fpm conf
    if [ -n "$old_phpversion" ] && [ "$old_phpversion" != "$phpversion" ]
    then
        local old_php_fpm_config_dir=$(ynh_app_setting_get --app=$app --key=fpm_config_dir)
        local old_php_finalphpconf="$old_php_fpm_config_dir/pool.d/$app.conf"

        ynh_backup_if_checksum_is_different --file="$old_php_finalphpconf"

        ynh_remove_fpm_config
    fi

    # If the requested PHP version is not the default version for YunoHost
    if [ "$phpversion" != "$YNH_DEFAULT_PHP_VERSION" ]
    then
        # If the argument --package is used, add the packages to ynh_install_php to install them from sury
        if [ -n "$package" ]
        then
            local additionnal_packages="--package=$package"
        else
            local additionnal_packages=""
        fi
        # Install this specific version of PHP.
        ynh_install_php --phpversion="$phpversion" "$additionnal_packages"
    elif [ -n "$package" ]
    then
        # Install the additionnal packages from the default repository
        ynh_add_app_dependencies --package="$package"
    fi

    if [ $dedicated_service -eq 1 ]
    then
        local fpm_service="${app}-phpfpm"
        local fpm_config_dir="/etc/php/$phpversion/dedicated-fpm"
    else
        local fpm_service="php${phpversion}-fpm"
        local fpm_config_dir="/etc/php/$phpversion/fpm"
    fi

    # Create the directory for FPM pools
    mkdir --parents "$fpm_config_dir/pool.d"

    ynh_app_setting_set --app=$app --key=fpm_config_dir --value="$fpm_config_dir"
    ynh_app_setting_set --app=$app --key=fpm_service --value="$fpm_service"
    ynh_app_setting_set --app=$app --key=fpm_dedicated_service --value="$dedicated_service"
    ynh_app_setting_set --app=$app --key=phpversion --value=$phpversion

    # Migrate from mutual PHP service to dedicated one.
    if [ $dedicated_service -eq 1 ]
    then
        local old_fpm_config_dir="/etc/php/$phpversion/fpm"
        # If a config file exist in the common pool, move it.
        if [ -e "$old_fpm_config_dir/pool.d/$app.conf" ]
        then
            ynh_print_info --message="Migrate to a dedicated php-fpm service for $app."
            # Create a backup of the old file before migration
            ynh_backup_if_checksum_is_different --file="$old_fpm_config_dir/pool.d/$app.conf"
            # Remove the old PHP config file
            ynh_secure_remove --file="$old_fpm_config_dir/pool.d/$app.conf"
            # Reload PHP to release the socket and allow the dedicated service to use it
            ynh_systemd_action --service_name=php${phpversion}-fpm --action=reload
        fi
    fi

    if [ $use_template -eq 1 ]
    then
        # Usage 1, use the template in conf/php-fpm.conf
        local phpfpm_path="$YNH_APP_BASEDIR/conf/php-fpm.conf"
        # Make sure now that the template indeed exists
        [ -e "$phpfpm_path" ] || ynh_die --message="Unable to find template to configure PHP-FPM."
    else
        # Usage 2, generate a PHP-FPM config file with ynh_get_scalable_phpfpm

        # Store settings
        ynh_app_setting_set --app=$app --key=fpm_footprint --value=$footprint
        ynh_app_setting_set --app=$app --key=fpm_usage --value=$usage

        # Define the values to use for the configuration of PHP.
        ynh_get_scalable_phpfpm --usage=$usage --footprint=$footprint

        local phpfpm_path="$YNH_APP_BASEDIR/conf/php-fpm.conf"
        echo "
[__APP__]
user = __APP__
group = __APP__
chdir = __FINALPATH__
listen = /var/run/php/php__PHPVERSION__-fpm-__APP__.sock
listen.owner = www-data
listen.group = www-data
pm = __PHP_PM__
pm.max_children = __PHP_MAX_CHILDREN__
pm.max_requests = 500
request_terminate_timeout = 1d
" > $phpfpm_path

        if [ "$php_pm" = "dynamic" ]
        then
            echo "
pm.start_servers = __PHP_START_SERVERS__
pm.min_spare_servers = __PHP_MIN_SPARE_SERVERS__
pm.max_spare_servers = __PHP_MAX_SPARE_SERVERS__
" >> $phpfpm_path

        elif [ "$php_pm" = "ondemand" ]
        then
            echo "
pm.process_idle_timeout = 10s
" >> $phpfpm_path
        fi

        # Concatene the extra config.
        if [ -e $YNH_APP_BASEDIR/conf/extra_php-fpm.conf ]; then
            cat $YNH_APP_BASEDIR/conf/extra_php-fpm.conf >> "$phpfpm_path"
        fi
    fi

    local finalphpconf="$fpm_config_dir/pool.d/$app.conf"
    ynh_add_config --template="$phpfpm_path" --destination="$finalphpconf"

    if [ -e "$YNH_APP_BASEDIR/conf/php-fpm.ini" ]
    then
        ynh_print_warn --message="Packagers ! Please do not use a separate php ini file, merge your directives in the pool file instead."
        ynh_add_config --template="$YNH_APP_BASEDIR/conf/php-fpm.ini" --destination="$fpm_config_dir/conf.d/20-$app.ini"
    fi

    if [ $dedicated_service -eq 1 ]
    then
        # Create a dedicated php-fpm.conf for the service
        local globalphpconf=$fpm_config_dir/php-fpm-$app.conf

echo "[global]
pid = /run/php/php__PHPVERSION__-fpm-__APP__.pid
error_log = /var/log/php/fpm-php.__APP__.log
syslog.ident = php-fpm-__APP__
include = __FINALPHPCONF__
" > $YNH_APP_BASEDIR/conf/php-fpm-$app.conf

        ynh_add_config --template="$YNH_APP_BASEDIR/conf/php-fpm-$app.conf" --destination="$globalphpconf"

        # Create a config for a dedicated PHP-FPM service for the app
        echo "[Unit]
Description=PHP __PHPVERSION__ FastCGI Process Manager for __APP__
After=network.target
[Service]
Type=notify
PIDFile=/run/php/php__PHPVERSION__-fpm-__APP__.pid
ExecStart=/usr/sbin/php-fpm__PHPVERSION__ --nodaemonize --fpm-config __GLOBALPHPCONF__
ExecReload=/bin/kill -USR2 \$MAINPID
[Install]
WantedBy=multi-user.target
" > $YNH_APP_BASEDIR/conf/$fpm_service

        # Create this dedicated PHP-FPM service
        ynh_add_systemd_config --service=$fpm_service --template=$fpm_service
        # Integrate the service in YunoHost admin panel
        yunohost service add $fpm_service --log /var/log/php/fpm-php.$app.log --description "Php-fpm dedicated to $app"
        # Configure log rotate
        ynh_use_logrotate --logfile=/var/log/php
        # Restart the service, as this service is either stopped or only for this app
        ynh_systemd_action --service_name=$fpm_service --action=restart
    else
        # Validate that the new php conf doesn't break php-fpm entirely
        if ! php-fpm${phpversion} --test 2>/dev/null
        then
            php-fpm${phpversion} --test || true
            ynh_secure_remove --file="$finalphpconf"
            ynh_die --message="The new configuration broke php-fpm?"
        fi
        ynh_systemd_action --service_name=$fpm_service --action=reload
    fi
}