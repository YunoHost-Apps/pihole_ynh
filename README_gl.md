<!--
NOTA: Este README foi creado automáticamente por <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
NON debe editarse manualmente.
-->

# Pi-hole para YunoHost

[![Nivel de integración](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/) ![Estado de funcionamento](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Estado de mantemento](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Instalar Pi-hole con YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Le este README en outros idiomas.](./ALL_README.md)*

> *Este paquete permíteche instalar Pi-hole de xeito rápido e doado nun servidor YunoHost.*  
> *Se non usas YunoHost, le a [documentación](https://yunohost.org/install) para saber como instalalo.*

## Vista xeral

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Versión proporcionada:** 5.18.2~ynh1

## Capturas de pantalla

![Captura de pantalla de Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Debes considerar

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Documentación e recursos

- Web oficial da app: <https://pi-hole.net/>
- Documentación oficial para admin: <https://docs.pi-hole.net>
- Repositorio de orixe do código: <https://github.com/pi-hole/pi-hole>
- Tenda YunoHost: <https://apps.yunohost.org/app/pihole>
- Informar dun problema: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Info de desenvolvemento

Envía a túa colaboración á [rama `testing`](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Para probar a rama `testing`, procede deste xeito:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
ou
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Máis info sobre o empaquetado da app:** <https://yunohost.org/packaging_apps>
