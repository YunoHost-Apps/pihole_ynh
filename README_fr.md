# Pi-hole pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/jenkins/job/pihole%20%28Community%29/lastBuild/consoleFull)  
[![Installer Pi-hole avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=pihole

*[Read this readme in english.](./README.md)*

> *Ce package vous permet d'installer Pi-hole rapidement et simplement sur un serveur YunoHost.  
Si vous n'avez pas YunoHost, merci de regarder [ici](https://yunohost.org/#/install_fr) pour savoir comment l'installer et en profiter.*

## Résumé
Blocage des publicités sur l'ensemble du réseau via votre propre matériel Linux

**Version embarquée:** 3.1.4

## Captures d'écran

![](https://i0.wp.com/pi-hole.net/wp-content/uploads/2016/12/dashboard212.png)

## Configuration

Utiliser le panneau d'administration de votre Pi-hole pour configurer cette application.

## Documentation

* Documentation officielle: Impossible à trouver
* Pi-hole en tant que serveur DHCP: [dhcp.md](./dhcp.md)
* Documentation YunoHost: Il n'y a pas d'autre documentation, n'hésitez pas à contribuer.

## Fonctionnalités spécifiques à YunoHost

* Accès privé au panneau d'administration.

#### Support multi-utilisateurs

#### Architectures supportées.

* Testé sur x86_64

## Limitations

* Activer DHCP avec Pi-hole nécessite une configuration manuelle de votre routeur.

## Informations additionnelles

## Liens

 * Reporter un bug: https://github.com/YunoHost-Apps/pihole_ynh/issues
 * Site de Pi-hole: https://pi-hole.net/
 * Site de YunoHost: https://yunohost.org/

---

Informations à l'intention des développeurs
----------------

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Pour tester la branche testing, merci de procéder ainsi.
```
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --verbose
ou
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --verbose
```
