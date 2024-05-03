<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# Pi-hole pour YunoHost

[![Niveau d’intégration](https://dash.yunohost.org/integration/pihole.svg)](https://dash.yunohost.org/appci/app/pihole) ![Statut du fonctionnement](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Statut de maintenance](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Installer Pi-hole avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer Pi-hole rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

Pi-hole® est un puits DNS qui protège vos appareils des contenus indésirables sans installer de logiciel côté client.


**Version incluse :** 5.14.2~ynh4

## Captures d’écran

![Capture d’écran de Pi-hole](./doc/screenshots/dashboard.png)

## Documentations et ressources

- Site officiel de l’app : <https://pi-hole.net/>
- Documentation officielle de l’admin : <https://docs.pi-hole.net>
- Dépôt de code officiel de l’app : <https://github.com/pi-hole/pi-hole>
- YunoHost Store : <https://apps.yunohost.org/app/pihole>
- Signaler un bug : <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
ou
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
