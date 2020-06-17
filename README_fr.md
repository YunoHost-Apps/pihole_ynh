# Pi-hole pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/pihole.svg)](https://dash.yunohost.org/appci/app/pihole) ![](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)  
[![Installer Pi-hole avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=pihole)

*[Read this readme in english.](./README.md)*

> *Ce package vous permet d'installer Pi-hole rapidement et simplement sur un serveur YunoHost.  
Si vous n'avez pas YunoHost, merci de regarder [ici](https://yunohost.org/#/install_fr) pour savoir comment l'installer et en profiter.*

## Résumé
Blocage des publicités sur l'ensemble du réseau via votre propre matériel Linux

**Version embarquée:** 3.3.1 ou 5.0


## Captures d'écran

![](https://i0.wp.com/pi-hole.net/wp-content/uploads/2016/12/dashboard212.png)

## Démo

Aucune démo pour cette application.

## Configuration

Utiliser le panneau d'administration de votre Pi-hole pour configurer cette application. Vous devrez peut-être aussi suivre le [guide de post-installation] (https://docs.pi-hole.net/main/post-install/) pour configurer Pi-hole en tant que *serveur DNS* ou *serveur DHCP*.

## Documentation

* Documentation officielle: https://docs.pi-hole.net/
* Pi-hole en tant que serveur DHCP: [dhcp.md](./dhcp.md)
* Documentation YunoHost: Il n'y a pas d'autre documentation, n'hésitez pas à contribuer.

## Fonctionnalités spécifiques à YunoHost

* Accès privé au panneau d'administration.

#### Support multi-utilisateurs

#### Architectures supportées.

* x86-64b - [![](https://ci-apps.yunohost.org/ci/logs/pihole%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/)
* ARMv8-A - [![](https://ci-apps-arm.yunohost.org/ci/logs/pihole%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/pihole/)
* Buster x86-64b - [![](https://ci-buster.nohost.me/ci/logs/pihole%20%28Apps%29.svg)](https://ci-buster.nohost.me/ci/apps/pihole/)

## Limitations

* Activer DHCP avec Pi-hole nécessite une configuration manuelle de votre routeur.
* Pi-Hole ne peut pas être mis à jour au-delà de la version 3.3.1, car les versions supérieures utilisent une version intégrée de dnsmasq. Ce qui oblige a désactiver la version de dnsmasq utilisée par YunoHost.

## Informations additionnelles

## Liens

 * Reporter un bug: https://github.com/YunoHost-Apps/pihole_ynh/issues
 * Site de Pi-hole: https://pi-hole.net/
 * Dépôt de Pi-hole: https://github.com/pi-hole/pi-hole/
 * Site de YunoHost: https://yunohost.org/

---

Informations à l'intention des développeurs
----------------

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Pour tester la branche testing, merci de procéder ainsi.
```
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --force --debug
ou
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```
