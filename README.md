# Pi-hole for YunoHost

[![Integration level](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/jenkins/job/pihole%20%28Community%29/lastBuild/consoleFull)  
[![Install Pi-hole with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=pihole)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allow you to install Pi-hole quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview
Network-wide ad blocking via your own Linux hardware

**Shipped version:** 3.3

## Screenshots

![](https://i0.wp.com/pi-hole.net/wp-content/uploads/2016/12/dashboard212.png)

## Configuration

Use the admin panel of your Pi-hole to configure this app.

## Documentation

* Official documentation: Not found
* Pi-hole as a DHCP server: [dhcp.md](./dhcp.md)
* YunoHost documentation: There no other documentations, feel free to contribute.

## YunoHost specific features

* Private access to the admin panel.

#### Multi-users support

#### Supported architectures

* Tested on x86_64

## Limitations

* Activate DHCP with Pi-hole need a manuel configuration of your router.
* Pi-Hole-FTL can't be upgrade above the version 2.13.2, because of the usage of an option of dnsmasq not yet available on Jessie.

## Additionnal informations

## Links

 * Report a bug: https://github.com/YunoHost-Apps/pihole_ynh/issues
 * Pi-hole website: https://pi-hole.net/
 * YunoHost website: https://yunohost.org/

---

Developers infos
----------------

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --verbose
or
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --verbose
```
