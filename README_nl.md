<!--
NB: Deze README is automatisch gegenereerd door <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Hij mag NIET handmatig aangepast worden.
-->

# Pi-hole voor Yunohost

[![Integratieniveau](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/) ![Mate van functioneren](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Onderhoudsstatus](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Pi-hole met Yunohost installeren](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Deze README in een andere taal lezen.](./ALL_README.md)*

> *Met dit pakket kun je Pi-hole snel en eenvoudig op een YunoHost-server installeren.*  
> *Als je nog geen YunoHost hebt, lees dan [de installatiehandleiding](https://yunohost.org/install), om te zien hoe je 'm installeert.*

## Overzicht

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Geleverde versie:** 5.18.3~ynh1

## Schermafdrukken

![Schermafdrukken van Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Anti-eigenschappen

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Documentatie en bronnen

- Officiele website van de app: <https://pi-hole.net/>
- Officiele beheerdersdocumentatie: <https://docs.pi-hole.net>
- Upstream app codedepot: <https://github.com/pi-hole/pi-hole>
- YunoHost-store: <https://apps.yunohost.org/app/pihole>
- Meld een bug: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Ontwikkelaarsinformatie

Stuur je pull request alsjeblieft naar de [`testing`-branch](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Om de `testing`-branch uit te proberen, ga als volgt te werk:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
of
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Verdere informatie over app-packaging:** <https://yunohost.org/packaging_apps>
