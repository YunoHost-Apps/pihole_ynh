<!--
N.B.: Diese README wurde automatisch von <https://github.com/YunoHost/apps/tree/master/tools/readme_generator> generiert.
Sie darf NICHT von Hand bearbeitet werden.
-->

# Pi-hole für YunoHost

[![Integrations-Level](https://apps.yunohost.org/badge/integration/pihole)](https://ci-apps.yunohost.org/ci/apps/pihole/)
![Funktionsstatus](https://apps.yunohost.org/badge/state/pihole)
![Wartungsstatus](https://apps.yunohost.org/badge/maintained/pihole)

[![Pi-hole mit YunoHost installieren](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Dieses README in anderen Sprachen lesen.](./ALL_README.md)*

> *Mit diesem Paket können Sie Pi-hole schnell und einfach auf einem YunoHost-Server installieren.*  
> *Wenn Sie YunoHost nicht haben, lesen Sie bitte [die Anleitung](https://yunohost.org/install), um zu erfahren, wie Sie es installieren.*

## Übersicht

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Ausgelieferte Version:** 6.0.6~ynh1

## Bildschirmfotos

![Bildschirmfotos von Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Anti-Eigenschaften

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Dokumentation und Ressourcen

- Offizielle Website der App: <https://pi-hole.net/>
- Offizielle Verwaltungsdokumentation: <https://docs.pi-hole.net>
- Upstream App Repository: <https://github.com/pi-hole/pi-hole>
- YunoHost-Shop: <https://apps.yunohost.org/app/pihole>
- Einen Fehler melden: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Entwicklerinformationen

Bitte senden Sie Ihren Pull-Request an den [`testing` branch](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Um den `testing` Branch auszuprobieren, gehen Sie bitte wie folgt vor:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
oder
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Weitere Informationen zur App-Paketierung:** <https://yunohost.org/packaging_apps>
