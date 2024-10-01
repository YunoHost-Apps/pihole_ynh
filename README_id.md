<!--
N.B.: README ini dibuat secara otomatis oleh <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Ini TIDAK boleh diedit dengan tangan.
-->

# Pi-hole untuk YunoHost

[![Tingkat integrasi](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/) ![Status kerja](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Status pemeliharaan](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Pasang Pi-hole dengan YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Baca README ini dengan bahasa yang lain.](./ALL_README.md)*

> *Paket ini memperbolehkan Anda untuk memasang Pi-hole secara cepat dan mudah pada server YunoHost.*  
> *Bila Anda tidak mempunyai YunoHost, silakan berkonsultasi dengan [panduan](https://yunohost.org/install) untuk mempelajari bagaimana untuk memasangnya.*

## Ringkasan

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Versi terkirim:** 5.18.2~ynh1

## Tangkapan Layar

![Tangkapan Layar pada Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Antifitur

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Dokumentasi dan sumber daya

- Website aplikasi resmi: <https://pi-hole.net/>
- Dokumentasi admin resmi: <https://docs.pi-hole.net>
- Depot kode aplikasi hulu: <https://github.com/pi-hole/pi-hole>
- Gudang YunoHost: <https://apps.yunohost.org/app/pihole>
- Laporkan bug: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Info developer

Silakan kirim pull request ke [`testing` branch](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Untuk mencoba branch `testing`, silakan dilanjutkan seperti:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
atau
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Info lebih lanjut mengenai pemaketan aplikasi:** <https://yunohost.org/packaging_apps>
