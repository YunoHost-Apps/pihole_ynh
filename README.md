# Pi-hole for YunoHost

[![Integration level](https://dash.yunohost.org/integration/pihole.svg)](https://dash.yunohost.org/appci/app/pihole) ![](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)  
[![Install Pi-hole with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=pihole)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allow you to install Pi-hole quickly and easily on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to learn how to install and enjoy it.*

## Overview
Network-wide ad blocking via your own Linux hardware

**Shipped version:** 3.3.1

## Screenshots

![](https://i0.wp.com/pi-hole.net/wp-content/uploads/2016/12/dashboard212.png)

## Demo

No demo available.

## Configuration

Use the admin panel of your Pi-hole to configure this app. You may also need to follow the [post-install guide](https://docs.pi-hole.net/main/post-install/) to setup Pi-hole either as a *DNS server* or a *DHCP server*.

## Documentation

* Official documentation: https://docs.pi-hole.net/
* Pi-hole as a DHCP server: [dhcp.md](./dhcp.md)
* YunoHost documentation: There is no other documentation. Feel free to contribute!

## YunoHost specific features

* Private access to the admin panel.

#### Multi-users support

#### Supported architectures

* x86-64b - [![](https://ci-apps.yunohost.org/ci/logs/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/)
* ARMv8-A - [![](https://ci-apps-arm.yunohost.org/ci/logs/pihole.svg)](https://ci-apps-arm.yunohost.org/ci/apps/pihole/)

## Limitations

* Activate DHCP with Pi-hole needs manual configuration of your router.
* Pi-Hole can't be updated beyond version 3.3.1, because higher versions use an integrated version of dnsmasq. This would require disabling the version of dnsmasq used by YunoHost.

## Additionnal informations

## Links

 * Report a bug: https://github.com/YunoHost-Apps/pihole_ynh/issues
 * Pi-hole website: https://pi-hole.net/
 * Pi-hole repository: https://github.com/pi-hole/pi-hole/
 * YunoHost website: https://yunohost.org/

---

Developers infos

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

To try the testing branch, please do the following:
```
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
or
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```
