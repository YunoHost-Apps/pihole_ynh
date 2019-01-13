#!/bin/bash

#=================================================
# BACKUP
#=================================================

HUMAN_SIZE () {	# Transforme une taille en Ko en une taille lisible pour un humain
	human=$(numfmt --to=iec --from-unit=1K $1)
	echo $human
}

CHECK_SIZE () {	# Vérifie avant chaque backup que l'espace est suffisant
	file_to_analyse=$1
	backup_size=$(du --summarize "$file_to_analyse" | cut -f1)
	free_space=$(df --output=avail "/home/yunohost.backup" | sed 1d)

	if [ $free_space -le $backup_size ]
	then
		ynh_print_err "Espace insuffisant pour sauvegarder $file_to_analyse."
		ynh_print_err "Espace disponible: $(HUMAN_SIZE $free_space)"
		ynh_die "Espace nécessaire: $(HUMAN_SIZE $backup_size)"
	fi
}

#=================================================
# PACKAGE CHECK BYPASSING...
#=================================================

IS_PACKAGE_CHECK () {
	return $(env | grep -c container=lxc)
}

#=================================================
# BOOLEAN CONVERTER
#=================================================

bool_to_01 () {
	local var="$1"
	[ "$var" = "true" ] && var=1
	[ "$var" = "false" ] && var=0
	echo "$var"
}

bool_to_true_false () {
	local var="$1"
	[ "$var" = "1" ] && var=true
	[ "$var" = "0" ] && var=false
	echo "$var"
}

#=================================================
# FUTUR OFFICIAL HELPERS
#=================================================

# Internal helper design to allow helpers to use getopts to manage their arguments
#
# [internal]
#
# example: function my_helper()
# {
#     declare -Ar args_array=( [a]=arg1= [b]=arg2= [c]=arg3 )
#     local arg1
#     local arg2
#     local arg3
#     ynh_handle_getopts_args "$@"
#
#     [...]
# }
# my_helper --arg1 "val1" -b val2 -c
#
# usage: ynh_handle_getopts_args "$@"
# | arg: $@    - Simply "$@" to tranfert all the positionnal arguments to the function
#
# This helper need an array, named "args_array" with all the arguments used by the helper
# 	that want to use ynh_handle_getopts_args
# Be carreful, this array has to be an associative array, as the following example:
# declare -Ar args_array=( [a]=arg1 [b]=arg2= [c]=arg3 )
# Let's explain this array:
# a, b and c are short options, -a, -b and -c
# arg1, arg2 and arg3 are the long options associated to the previous short ones. --arg1, --arg2 and --arg3
# For each option, a short and long version has to be defined.
# Let's see something more significant
# declare -Ar args_array=( [u]=user [f]=finalpath= [d]=database )
#
# NB: Because we're using 'declare' without -g, the array will be declared as a local variable.
#
# Please keep in mind that the long option will be used as a variable to store the values for this option.
# For the previous example, that means that $finalpath will be fill with the value given as argument for this option.
#
# Also, in the previous example, finalpath has a '=' at the end. That means this option need a value.
# So, the helper has to be call with --finalpath /final/path, --finalpath=/final/path or -f /final/path, the variable $finalpath will get the value /final/path
# If there's many values for an option, -f /final /path, the value will be separated by a ';' $finalpath=/final;/path
# For an option without value, like --user in the example, the helper can be called only with --user or -u. $user will then get the value 1.
#
# To keep a retrocompatibility, a package can still call a helper, using getopts, with positional arguments.
# The "legacy mode" will manage the positional arguments and fill the variable in the same order than they are given in $args_array.
# e.g. for `my_helper "val1" val2`, arg1 will be filled with val1, and arg2 with val2.
ynh_handle_getopts_args () {
	# Manage arguments only if there's some provided
	set +x
	if [ $# -ne 0 ]
	then
		# Store arguments in an array to keep each argument separated
		local arguments=("$@")

		# For each option in the array, reduce to short options for getopts (e.g. for [u]=user, --user will be -u)
		# And built parameters string for getopts
		# ${!args_array[@]} is the list of all option_flags in the array (An option_flag is 'u' in [u]=user, user is a value)
		local getopts_parameters=""
		local option_flag=""
		for option_flag in "${!args_array[@]}"
		do
			# Concatenate each option_flags of the array to build the string of arguments for getopts
			# Will looks like 'abcd' for -a -b -c -d
			# If the value of an option_flag finish by =, it's an option with additionnal values. (e.g. --user bob or -u bob)
			# Check the last character of the value associate to the option_flag
			if [ "${args_array[$option_flag]: -1}" = "=" ]
			then
				# For an option with additionnal values, add a ':' after the letter for getopts.
				getopts_parameters="${getopts_parameters}${option_flag}:"
			else
				getopts_parameters="${getopts_parameters}${option_flag}"
			fi
			# Check each argument given to the function
			local arg=""
			# ${#arguments[@]} is the size of the array
			for arg in `seq 0 $(( ${#arguments[@]} - 1 ))`
			do
				# And replace long option (value of the option_flag) by the short option, the option_flag itself
				# (e.g. for [u]=user, --user will be -u)
				# Replace long option with =
				arguments[arg]="${arguments[arg]//--${args_array[$option_flag]}/-${option_flag} }"
				# And long option without =
				arguments[arg]="${arguments[arg]//--${args_array[$option_flag]%=}/-${option_flag}}"
			done
		done

		# Read and parse all the arguments
		# Use a function here, to use standart arguments $@ and be able to use shift.
		parse_arg () {
			# Read all arguments, until no arguments are left
			while [ $# -ne 0 ]
			do
				# Initialize the index of getopts
				OPTIND=1
				# Parse with getopts only if the argument begin by -, that means the argument is an option
				# getopts will fill $parameter with the letter of the option it has read.
				local parameter=""
				getopts ":$getopts_parameters" parameter || true

				if [ "$parameter" = "?" ]
				then
					ynh_die --message="Invalid argument: -${OPTARG:-}"
				elif [ "$parameter" = ":" ]
				then
					ynh_die --message="-$OPTARG parameter requires an argument."
				else
					local shift_value=1
					# Use the long option, corresponding to the short option read by getopts, as a variable
					# (e.g. for [u]=user, 'user' will be used as a variable)
					# Also, remove '=' at the end of the long option
					# The variable name will be stored in 'option_var'
					local option_var="${args_array[$parameter]%=}"
					# If this option doesn't take values
					# if there's a '=' at the end of the long option name, this option takes values
					if [ "${args_array[$parameter]: -1}" != "=" ]
					then
						# 'eval ${option_var}' will use the content of 'option_var'
						eval ${option_var}=1
					else
						# Read all other arguments to find multiple value for this option.
						# Load args in a array
						local all_args=("$@")

						# If the first argument is longer than 2 characters,
						# There's a value attached to the option, in the same array cell
						if [ ${#all_args[0]} -gt 2 ]; then
							# Remove the option and the space, so keep only the value itself.
							all_args[0]="${all_args[0]#-${parameter} }"
							# Reduce the value of shift, because the option has been removed manually
							shift_value=$(( shift_value - 1 ))
						fi

						# Declare the content of option_var as a variable.
						eval ${option_var}=""
						# Then read the array value per value
						local i
						for i in `seq 0 $(( ${#all_args[@]} - 1 ))`
						do
							# If this argument is an option, end here.
							if [ "${all_args[$i]:0:1}" == "-" ]
							then
								# Ignore the first value of the array, which is the option itself
								if [ "$i" -ne 0 ]; then
									break
								fi
							else
								# Else, add this value to this option
								# Each value will be separated by ';'
								if [ -n "${!option_var}" ]
								then
									# If there's already another value for this option, add a ; before adding the new value
									eval ${option_var}+="\;"
								fi
								eval ${option_var}+=\"${all_args[$i]}\"
								shift_value=$(( shift_value + 1 ))
							fi
						done
					fi
				fi

				# Shift the parameter and its argument(s)
				shift $shift_value
			done
		}

		# LEGACY MODE
		# Check if there's getopts arguments
		if [ "${arguments[0]:0:1}" != "-" ]
		then
			# If not, enter in legacy mode and manage the arguments as positionnal ones..
			# Dot not echo, to prevent to go through a helper output. But print only in the log.
			set -x; echo "! Helper used in legacy mode !" > /dev/null; set +x
			local i
			for i in `seq 0 $(( ${#arguments[@]} -1 ))`
			do
				# Try to use legacy_args as a list of option_flag of the array args_array
				# Otherwise, fallback to getopts_parameters to get the option_flag. But an associative arrays isn't always sorted in the correct order...
				# Remove all ':' in getopts_parameters
				getopts_parameters=${legacy_args:-${getopts_parameters//:}}
				# Get the option_flag from getopts_parameters, by using the option_flag according to the position of the argument.
				option_flag=${getopts_parameters:$i:1}
				if [ -z "$option_flag" ]; then
						ynh_print_warn --message="Too many arguments ! \"${arguments[$i]}\" will be ignored."
						continue
				fi
				# Use the long option, corresponding to the option_flag, as a variable
				# (e.g. for [u]=user, 'user' will be used as a variable)
				# Also, remove '=' at the end of the long option
				# The variable name will be stored in 'option_var'
				local option_var="${args_array[$option_flag]%=}"

				# Store each value given as argument in the corresponding variable
				# The values will be stored in the same order than $args_array
				eval ${option_var}+=\"${arguments[$i]}\"
			done
			unset legacy_args
		else
			# END LEGACY MODE
			# Call parse_arg and pass the modified list of args as an array of arguments.
			parse_arg "${arguments[@]}"
		fi
	fi
	set -x
}

#=================================================

# Install or update the main directory yunohost.multimedia
#
# usage: ynh_multimedia_build_main_dir
ynh_multimedia_build_main_dir () {
	local ynh_media_release="v1.2"
	local checksum="806a827ba1902d6911095602a9221181"

	# Download yunohost.multimedia scripts
	wget -nv https://github.com/YunoHost-Apps/yunohost.multimedia/archive/${ynh_media_release}.tar.gz 

	# Check the control sum
	echo "${checksum} ${ynh_media_release}.tar.gz" | md5sum -c --status \
		|| ynh_die "Corrupt source"

	# Check if the package acl is installed. Or install it.
	ynh_package_is_installed 'acl' \
		|| ynh_package_install acl

	# Extract
	mkdir yunohost.multimedia-master
	tar -xf ${ynh_media_release}.tar.gz -C yunohost.multimedia-master --strip-components 1
	./yunohost.multimedia-master/script/ynh_media_build.sh
}

# Add a directory in yunohost.multimedia
# This "directory" will be a symbolic link to a existing directory.
#
# usage: ynh_multimedia_addfolder "Source directory" "Destination directory"
#
# | arg: -s, --source_dir= - Source directory - The real directory which contains your medias.
# | arg: -d, --dest_dir= - Destination directory - The name and the place of the symbolic link, relative to "/home/yunohost.multimedia"
ynh_multimedia_addfolder () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [s]=source_dir= [d]=dest_dir= )
	local source_dir
	local dest_dir
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	./yunohost.multimedia-master/script/ynh_media_addfolder.sh --source="$source_dir" --dest="$dest_dir"
}

# Move a directory in yunohost.multimedia, and replace by a symbolic link
#
# usage: ynh_multimedia_movefolder "Source directory" "Destination directory"
#
# | arg: -s, --source_dir= - Source directory - The real directory which contains your medias.
# It will be moved to "Destination directory"
# A symbolic link will replace it.
# | arg: -d, --dest_dir= - Destination directory - The new name and place of the directory, relative to "/home/yunohost.multimedia"
ynh_multimedia_movefolder () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [s]=source_dir= [d]=dest_dir= )
	local source_dir
	local dest_dir
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	./yunohost.multimedia-master/script/ynh_media_addfolder.sh --inv --source="$source_dir" --dest="$dest_dir"
}

# Allow an user to have an write authorisation in multimedia directories
#
# usage: ynh_multimedia_addaccess user_name
#
# | arg: -u, --user_name= - The name of the user which gain this access.
ynh_multimedia_addaccess () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [u]=user_name=)
	local user_name
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	groupadd -f multimedia
	usermod -a -G multimedia $user_name
}

#=================================================

# Create a dedicated fail2ban config (jail and filter conf files)
#
# usage: ynh_add_fail2ban_config log_file filter [max_retry [ports]]
# | arg: -l, --logpath= - Log file to be checked by fail2ban
# | arg: -r, --failregex= - Failregex to be looked for by fail2ban
# | arg: -m, --max_retry= - Maximum number of retries allowed before banning IP address - default: 3
# | arg: -p, --ports= - Ports blocked for a banned IP address - default: http,https
ynh_add_fail2ban_config () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [l]=logpath= [r]=failregex= [m]=max_retry= [p]=ports= )
	local logpath
	local failregex
	local max_retry
	local ports
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"
	max_retry=${max_retry:-3}
	ports=${ports:-http,https}

	test -n "$logpath" || ynh_die "ynh_add_fail2ban_config expects a logfile path as first argument and received nothing."
	test -n "$failregex" || ynh_die "ynh_add_fail2ban_config expects a failure regex as second argument and received nothing."

	finalfail2banjailconf="/etc/fail2ban/jail.d/$app.conf"
	finalfail2banfilterconf="/etc/fail2ban/filter.d/$app.conf"
	ynh_backup_if_checksum_is_different "$finalfail2banjailconf" 1
	ynh_backup_if_checksum_is_different "$finalfail2banfilterconf" 1

	tee $finalfail2banjailconf <<EOF
[$app]
enabled = true
port = $ports
filter = $app
logpath = $logpath
maxretry = $max_retry
EOF

  tee $finalfail2banfilterconf <<EOF
[INCLUDES]
before = common.conf
[Definition]
failregex = $failregex
ignoreregex =
EOF

	ynh_store_file_checksum "$finalfail2banjailconf"
	ynh_store_file_checksum "$finalfail2banfilterconf"

	if [ "$(lsb_release --codename --short)" != "jessie" ]; then
		systemctl reload fail2ban
	else
		systemctl restart fail2ban
	fi
	local fail2ban_error="$(journalctl -u fail2ban | tail -n50 | grep "WARNING.*$app.*")"
	if [ -n "$fail2ban_error" ]
	then
		echo "[ERR] Fail2ban failed to load the jail for $app" >&2
		echo "WARNING${fail2ban_error#*WARNING}" >&2
	fi
}

# Remove the dedicated fail2ban config (jail and filter conf files)
#
# usage: ynh_remove_fail2ban_config
ynh_remove_fail2ban_config () {
	ynh_secure_remove "/etc/fail2ban/jail.d/$app.conf"
	ynh_secure_remove "/etc/fail2ban/filter.d/$app.conf"
	if [ "$(lsb_release --codename --short)" != "jessie" ]; then
		systemctl reload fail2ban
	else
		systemctl restart fail2ban
	fi
}

#=================================================

# Read the value of a key in a ynh manifest file
#
# usage: ynh_read_manifest manifest key
# | arg: -m, --manifest= - Path of the manifest to read
# | arg: -k, --key= - Name of the key to find
ynh_read_manifest () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [m]=manifest= [k]=manifest_key= )
	local manifest
	local manifest_key
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	python3 -c "import sys, json;print(json.load(open('$manifest', encoding='utf-8'))['$manifest_key'])"
}

# Read the upstream version from the manifest
# The version number in the manifest is defined by <upstreamversion>~ynh<packageversion>
# For example : 4.3-2~ynh3
# This include the number before ~ynh
# In the last example it return 4.3-2
#
# usage: ynh_app_upstream_version [-m manifest]
# | arg: -m, --manifest= - Path of the manifest to read
ynh_app_upstream_version () {
	declare -Ar args_array=( [m]=manifest= )
	local manifest
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	manifest="${manifest:-../manifest.json}"
	if [ ! -e "$manifest" ]; then
		manifest="../settings/manifest.json"	# Into the restore script, the manifest is not at the same place
	fi
	version_key=$(ynh_read_manifest --manifest="$manifest" --manifest_key="version")
	echo "${version_key/~ynh*/}"
}

# Read package version from the manifest
# The version number in the manifest is defined by <upstreamversion>~ynh<packageversion>
# For example : 4.3-2~ynh3
# This include the number after ~ynh
# In the last example it return 3
#
# usage: ynh_app_package_version [-m manifest]
# | arg: -m, --manifest= - Path of the manifest to read
ynh_app_package_version () {
	declare -Ar args_array=( [m]=manifest= )
	local manifest
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	manifest="${manifest:-../manifest.json}"
	if [ ! -e "$manifest" ]; then
		manifest="../settings/manifest.json"	# Into the restore script, the manifest is not at the same place
	fi
	version_key=$(ynh_read_manifest --manifest="$manifest" --manifest_key="version")
	echo "${version_key/*~ynh/}"
}

# Checks the app version to upgrade with the existing app version and returns:
# - UPGRADE_APP if the upstream app version has changed
# - UPGRADE_PACKAGE if only the YunoHost package has changed
#
## It stops the current script without error if the package is up-to-date
#
# This helper should be used to avoid an upgrade of an app, or the upstream part
# of it, when it's not needed
#
# To force an upgrade, even if the package is up to date,
# you have to set the variable YNH_FORCE_UPGRADE before.
# example: sudo YNH_FORCE_UPGRADE=1 yunohost app upgrade MyApp
#
# usage: ynh_check_app_version_changed
ynh_check_app_version_changed () {
	local force_upgrade=${YNH_FORCE_UPGRADE:-0}
	local package_check=${PACKAGE_CHECK_EXEC:-0}

	# By default, upstream app version has changed
	local return_value="UPGRADE_APP"

	local current_version=$(ynh_read_manifest --manifest="/etc/yunohost/apps/$YNH_APP_INSTANCE_NAME/manifest.json" --manifest_key="version" || echo 1.0)
	local current_upstream_version="$(ynh_app_upstream_version --manifest="/etc/yunohost/apps/$YNH_APP_INSTANCE_NAME/manifest.json")"
	local update_version=$(ynh_read_manifest --manifest="../manifest.json" --manifest_key="version" || echo 1.0)
	local update_upstream_version="$(ynh_app_upstream_version)"

	if [ "$current_version" == "$update_version" ] ; then
		# Complete versions are the same
		if [ "$force_upgrade" != "0" ]
		then
			echo "Upgrade forced by YNH_FORCE_UPGRADE." >&2
			unset YNH_FORCE_UPGRADE
		elif [ "$package_check" != "0" ]
		then
			echo "Upgrade forced for package check." >&2
		else
			ynh_die "Up-to-date, nothing to do" 0
		fi
	elif [ "$current_upstream_version" == "$update_upstream_version" ] ; then
		# Upstream versions are the same, only YunoHost package versions differ
		return_value="UPGRADE_PACKAGE"
	fi
	echo $return_value
}

#=================================================

# Delete a file checksum from the app settings
#
# $app should be defined when calling this helper
#
# usage: ynh_remove_file_checksum file
# | arg: -f, --file= - The file for which the checksum will be deleted
ynh_delete_file_checksum () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [f]=file= )
	local file
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	local checksum_setting_name=checksum_${file//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	ynh_app_setting_delete $app $checksum_setting_name
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

# Start (or other actions) a service,  print a log in case of failure and optionnaly wait until the service is completely started
#
# usage: ynh_systemd_action [-n service_name] [-a action] [ [-l "line to match"] [-p log_path] [-t timeout] [-e length] ]
# | arg: -n, --service_name= - Name of the service to reload. Default : $app
# | arg: -a, --action=       - Action to perform with systemctl. Default: start
# | arg: -l, --line_match=   - Line to match - The line to find in the log to attest the service have finished to boot.
#                              If not defined it don't wait until the service is completely started.
# | arg: -p, --log_path=     - Log file - Path to the log file. Default : /var/log/$app/$app.log
# | arg: -t, --timeout=      - Timeout - The maximum time to wait before ending the watching. Default : 300 seconds.
# | arg: -e, --length=       - Length of the error log : Default : 20
ynh_systemd_action() {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [n]=service_name= [a]=action= [l]=line_match= [p]=log_path= [t]=timeout= [e]=length= )
	local service_name
	local action
	local line_match
	local length
	local log_path
	local timeout

	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	local service_name="${service_name:-$app}"
	local action=${action:-start}
	local log_path="${log_path:-/var/log/$service_name/$service_name.log}"
	local length=${length:-20}
	local timeout=${timeout:-300}

	# Start to read the log
	if [[ -n "${line_match:-}" ]]
	then
		local templog="$(mktemp)"
	# Following the starting of the app in its log
	if [ "$log_path" == "systemd" ] ; then
		# Read the systemd journal
		journalctl -u $service_name -f --since=-45 > "$templog" &
	else
		# Read the specified log file
		tail -F -n0 "$log_path" > "$templog" &
	fi
		# Get the PID of the tail command
		local pid_tail=$!
	fi

	echo "${action^} the service $service_name" >&2
	systemctl $action $service_name \
		|| ( journalctl --lines=$length -u $service_name >&2 \
		; test -n "$log_path" && echo "--" && tail --lines=$length "$log_path" >&2 \
		; false )

	# Start the timeout and try to find line_match
	if [[ -n "${line_match:-}" ]]
	then
		local i=0
		for i in $(seq 1 $timeout)
		do
			# Read the log until the sentence is found, that means the app finished to start. Or run until the timeout
			if grep --quiet "$line_match" "$templog"
			then
				echo "The service $service_name has correctly started." >&2
				break
			fi
			echo -n "." >&2
			sleep 1
		done
		if [ $i -eq $timeout ]
		then
			echo "The service $service_name didn't fully started before the timeout." >&2
			journalctl --lines=$length -u $service_name >&2
			test -n "$log_path" && echo "--" && tail --lines=$length "$log_path" >&2
		fi

		echo ""
		ynh_clean_check_starting
	fi
}

# Clean temporary process and file used by ynh_check_starting
# (usually used in ynh_clean_setup scripts)
#
# usage: ynh_clean_check_starting
ynh_clean_check_starting () {
	# Stop the execution of tail.
	kill -s 15 $pid_tail 2>&1
	ynh_secure_remove "$templog" 2>&1
}

#=================================================

# Send an email to inform the administrator
#
# usage: ynh_send_readme_to_admin app_message [recipients]
# | arg: -m --app_message= - The message to send to the administrator.
# | arg: -r, --recipients= - The recipients of this email. Use spaces to separate multiples recipients. - default: root
#	example: "root admin@domain"
#	If you give the name of a YunoHost user, ynh_send_readme_to_admin will find its email adress for you
#	example: "root admin@domain user1 user2"
ynh_send_readme_to_admin() {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [m]=app_message= [r]=recipients= )
	local app_message
	local recipients
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"
	local app_message="${app_message:-...No specific information...}"
	local recipients="${recipients:-root}"

	# Retrieve the email of users
	find_mails () {
		local list_mails="$1"
		local mail
		local recipients=" "
		# Read each mail in argument
		for mail in $list_mails
		do
			# Keep root or a real email address as it is
			if [ "$mail" = "root" ] || echo "$mail" | grep --quiet "@"
			then
				recipients="$recipients $mail"
			else
				# But replace an user name without a domain after by its email
				if mail=$(ynh_user_get_info "$mail" "mail" 2> /dev/null)
				then
					recipients="$recipients $mail"
				fi
			fi
		done
		echo "$recipients"
	}
	recipients=$(find_mails "$recipients")

	local mail_subject="☁️🆈🅽🅷☁️: \`$app\` was just installed!"

	local mail_message="This is an automated message from your beloved YunoHost server.

Specific information for the application $app.

$app_message

---
Automatic diagnosis data from YunoHost

$(yunohost tools diagnosis | grep -B 100 "services:" | sed '/services:/d')"

	# Define binary to use for mail command
	if [ -e /usr/bin/bsd-mailx ]
	then
		local mail_bin=/usr/bin/bsd-mailx
	else
		local mail_bin=/usr/bin/mail.mailutils
	fi

	# Send the email to the recipients
	echo "$mail_message" | $mail_bin -a "Content-Type: text/plain; charset=UTF-8" -s "$mail_subject" "$recipients"
}

#=================================================

ynh_debian_release () {
	lsb_release --codename --short
}

is_stretch () {
	if [ "$(ynh_debian_release)" == "stretch" ]
	then
		return 0
	else
		return 1
	fi
}

is_jessie () {
	if [ "$(ynh_debian_release)" == "jessie" ]
	then
		return 0
	else
		return 1
	fi
}

#=================================================

ynh_maintenance_mode_ON () {
	# Load value of $path_url and $domain from the config if their not set
	if [ -z $path_url ]; then
		path_url=$(ynh_app_setting_get $app path)
	fi
	if [ -z $domain ]; then
		domain=$(ynh_app_setting_get $app domain)
	fi

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
	echo "# All request to the app will be redirected to ${path_url}_maintenance and fall on the maintenance notice
rewrite ^${path_url}/(.*)$ ${path_url}_maintenance/? redirect;
# Use another location, to not be in conflict with the original config file
location ${path_url}_maintenance/ {
alias /var/www/html/ ;

try_files maintenance.$app.html =503;

# Include SSOWAT user panel.
include conf.d/yunohost_panel.conf.inc;
}" > "/etc/nginx/conf.d/$domain.d/maintenance.$app.conf"

	# The current config file will redirect all requests to the root of the app.
	# To keep the full path, we can use the following rewrite rule:
	# 	rewrite ^${path_url}/(.*)$ ${path_url}_maintenance/\$1? redirect;
	# The difference will be in the $1 at the end, which keep the following queries.
	# But, if it works perfectly for a html request, there's an issue with any php files.
	# This files are treated as simple files, and will be downloaded by the browser.
	# Would be really be nice to be able to fix that issue. So that, when the page is reloaded after the maintenance, the user will be redirected to the real page he was.

	systemctl reload nginx
}

ynh_maintenance_mode_OFF () {
	# Load value of $path_url and $domain from the config if their not set
	if [ -z $path_url ]; then
		path_url=$(ynh_app_setting_get $app path)
	fi
	if [ -z $domain ]; then
		domain=$(ynh_app_setting_get $app domain)
	fi

	# Rewrite the nginx config file to redirect from ${path_url}_maintenance to the real url of the app.
	echo "rewrite ^${path_url}_maintenance/(.*)$ ${path_url}/\$1 redirect;" > "/etc/nginx/conf.d/$domain.d/maintenance.$app.conf"
	systemctl reload nginx

	# Sleep 4 seconds to let the browser reload the pages and redirect the user to the app.
	sleep 4

	# Then remove the temporary files used for the maintenance.
	rm "/var/www/html/maintenance.$app.html"
	rm "/etc/nginx/conf.d/$domain.d/maintenance.$app.conf"

	systemctl reload nginx
}

#=================================================

# Download and check integrity of a file from app.src_file
#
# The file conf/app.src_file need to contains:
#
# FILE_URL=Address to download the file
# FILE_SUM=Control sum
# # (Optional) Program to check the integrity (sha256sum, md5sum...)
# # default: sha256
# FILE_SUM_PRG=sha256
# # (Optionnal) Name of the local archive (offline setup support)
# # default: Name of the downloaded file.
# FILENAME=example.deb
#
# usage: ynh_download_file --dest_dir="/destination/directory" [--source_id=myfile]
# | arg: -d, --dest_dir=  - Directory where to download the file
# | arg: -s, --source_id= - Name of the source file 'app.src_file' if it isn't '$app'
ynh_download_file () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [d]=dest_dir= [s]=source_id= )
	local dest_dir
	local source_id
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	source_id=${source_id:-app} # If the argument is not given, source_id equals "$app"

	# Load value from configuration file (see above for a small doc about this file
	# format)
	local file_url=$(grep 'FILE_URL=' "$YNH_CWD/../conf/${source_id}.src_file" | cut -d= -f2-)
	local file_sum=$(grep 'FILE_SUM=' "$YNH_CWD/../conf/${source_id}.src_file" | cut -d= -f2-)
	local file_sumprg=$(grep 'FILE_SUM_PRG=' "$YNH_CWD/../conf/${source_id}.src_file" | cut -d= -f2-)
	local filename=$(grep 'FILENAME=' "$YNH_CWD/../conf/${source_id}.src_file" | cut -d= -f2-)

	# Default value
	file_sumprg=${file_sumprg:-sha256sum}
	if [ "$filename" = "" ] ; then
		filename="$(basename "$file_url")"
	fi
	local local_src="/opt/yunohost-apps-src/${YNH_APP_ID}/${filename}"

	if test -e "$local_src"
	then    # Use the local source file if it is present
		cp $local_src $filename
	else    # If not, download the source
		local out=`wget -nv -O $filename $file_url 2>&1` || ynh_print_err $out
	fi

	# Check the control sum
	echo "${file_sum} ${filename}" | ${file_sumprg} -c --status \
		|| ynh_die "Corrupt file"

	# Create the destination directory, if it's not already.
	mkdir -p "$dest_dir"
	
	# Move the file to its destination
	mv $filename $dest_dir
}
