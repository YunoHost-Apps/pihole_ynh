# Pi-hole pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/pihole.svg)](https://dash.yunohost.org/appci/app/pihole) ![](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)  
[![Installer Pi-hole avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer Pi-hole rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

Filtrage publicitaire sur l'ensemble du réseau via votre propre serveur DNS.

**Version incluse :** 5.3.1~ynh1



## Captures d'écran

![](./doc/screenshots/dashboard.png)

## Avertissements / informations importantes

## Configuration

Utiliser le panneau d'administration de votre Pi-hole pour configurer cette application. Vous devrez peut-être aussi suivre le [guide de post-installation] (https://docs.pi-hole.net/main/post-install/) pour configurer Pi-hole en tant que *serveur DNS* ou *serveur DHCP*.

## Limitations

* Activer DHCP avec Pi-hole nécessite une configuration manuelle de votre routeur.
* Pi-Hole ne peut pas être mis à jour au-delà de la version 3.3.1, car les versions supérieures utilisent une version intégrée de dnsmasq. Ce qui oblige a désactiver la version de dnsmasq utilisée par YunoHost.

## Documentations et ressources

* Site officiel de l'app : https://pi-hole.net/
* Documentation officielle de l'admin : https://docs.pi-hole.net
* Dépôt de code officiel de l'app : https://github.com/pi-hole/pi-hole/
* Documentation YunoHost pour cette app : https://yunohost.org/app_pihole
* Signaler un bug : https://github.com/YunoHost-Apps/pihole_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
ou
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps