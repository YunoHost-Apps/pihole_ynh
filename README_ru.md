<!--
Важно: этот README был автоматически сгенерирован <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Он НЕ ДОЛЖЕН редактироваться вручную.
-->

# Pi-hole для YunoHost

[![Уровень интеграции](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/) ![Состояние работы](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Состояние сопровождения](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Установите Pi-hole с YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Прочтите этот README на других языках.](./ALL_README.md)*

> *Этот пакет позволяет Вам установить Pi-hole быстро и просто на YunoHost-сервер.*  
> *Если у Вас нет YunoHost, пожалуйста, посмотрите [инструкцию](https://yunohost.org/install), чтобы узнать, как установить его.*

## Обзор

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Поставляемая версия:** 5.18.2~ynh2

## Снимки экрана

![Снимок экрана Pi-hole](./doc/screenshots/dashboard.png)

## :red_circle: Анти-функции

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## Документация и ресурсы

- Официальный веб-сайт приложения: <https://pi-hole.net/>
- Официальная документация администратора: <https://docs.pi-hole.net>
- Репозиторий кода главной ветки приложения: <https://github.com/pi-hole/pi-hole>
- Магазин YunoHost: <https://apps.yunohost.org/app/pihole>
- Сообщите об ошибке: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Информация для разработчиков

Пришлите Ваш запрос на слияние в [ветку `testing`](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

Чтобы попробовать ветку `testing`, пожалуйста, сделайте что-то вроде этого:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
или
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Больше информации о пакетировании приложений:** <https://yunohost.org/packaging_apps>
