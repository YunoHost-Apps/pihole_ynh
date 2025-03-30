<!--
N.B.: Aquest README ha estat generat automàticament per <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
NO s'ha de modificar manualment.
-->

# Pi-hole per YunoHost

[![Nivell d'integració](https://apps.yunohost.org/badge/integration/pihole)](https://ci-apps.yunohost.org/ci/apps/pihole/)
![Estat de funcionament](https://apps.yunohost.org/badge/state/pihole)
![Estat de manteniment](https://apps.yunohost.org/badge/maintained/pihole)

[![Instal·la Pi-hole amb YunoHosth](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Llegeix aquest README en altres idiomes.](./ALL_README.md)*

> *Aquest paquet et permet instal·lar Pi-hole de forma ràpida i senzilla en un servidor YunoHost.*  
> *Si no tens YunoHost, consulta [la guia](https://yunohost.org/install) per saber com instal·lar-lo.*

## Visió general

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Versió inclosa:** 6.0.6~ynh1

## Captures de pantalla

![Captures de pantalla de Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Anticaracterístiques

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Documentació i recursos

- Lloc web oficial de l'aplicació: <https://pi-hole.net/>
- Documentació oficial per l'administrador: <https://docs.pi-hole.net>
- Repositori oficial del codi de l'aplicació: <https://github.com/pi-hole/pi-hole>
- Botiga YunoHost: <https://apps.yunohost.org/app/pihole>
- Reportar un error: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Informació per a desenvolupadors

Envieu les pull request a la [branca `testing`](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Per provar la branca `testing`, procedir com descrit a continuació:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
o
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Més informació sobre l'empaquetatge d'aplicacions:** <https://yunohost.org/packaging_apps>
