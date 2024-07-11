<!--
Este archivo README esta generado automaticamente<https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
No se debe editar a mano.
-->

# Pi-hole para Yunohost

[![Nivel de integración](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/) ![Estado funcional](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Estado En Mantención](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Instalar Pi-hole con Yunhost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Leer este README en otros idiomas.](./ALL_README.md)*

> *Este paquete le permite instalarPi-hole rapidamente y simplement en un servidor YunoHost.*  
> *Si no tiene YunoHost, visita [the guide](https://yunohost.org/install) para aprender como instalarla.*

## Descripción general

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Versión actual:** 5.18.2~ynh1

## Capturas

![Captura de Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Características no deseables

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Documentaciones y recursos

- Sitio web oficial: <https://pi-hole.net/>
- Documentación administrador oficial: <https://docs.pi-hole.net>
- Repositorio del código fuente oficial de la aplicación : <https://github.com/pi-hole/pi-hole>
- Catálogo YunoHost: <https://apps.yunohost.org/app/pihole>
- Reportar un error: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Información para desarrolladores

Por favor enviar sus correcciones a la [`branch testing`](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing

Para probar la rama `testing`, sigue asÍ:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
o
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Mas informaciones sobre el empaquetado de aplicaciones:** <https://yunohost.org/packaging_apps>
