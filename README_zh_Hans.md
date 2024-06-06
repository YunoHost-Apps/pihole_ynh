<!--
注意：此 README 由 <https://github.com/YunoHost/apps/tree/master/tools/readme_generator> 自动生成
请勿手动编辑。
-->

# YunoHost 上的 Pi-hole

[![集成程度](https://dash.yunohost.org/integration/pihole.svg)](https://dash.yunohost.org/appci/app/pihole) ![工作状态](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![维护状态](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![使用 YunoHost 安装 Pi-hole](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[阅读此 README 的其它语言版本。](./ALL_README.md)*

> *通过此软件包，您可以在 YunoHost 服务器上快速、简单地安装 Pi-hole。*  
> *如果您还没有 YunoHost，请参阅[指南](https://yunohost.org/install)了解如何安装它。*

## 概况

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**分发版本：** 5.18.2~ynh1

## 截图

![Pi-hole 的截图](./doc/screenshots/dashboard.png)

## :red_circle: 负面特征

- **Package not maintained**: This YunoHost package is not actively maintained and needs adoption. This means that minimal maintenance is made by volunteers who don't use the app, so you should expect the app to lose reliability over time. You can [learn how to package](https://yunohost.org/packaging_apps_intro) if you'd like to adopt it.

## 文档与资源

- 官方应用网站： <https://pi-hole.net/>
- 官方管理文档： <https://docs.pi-hole.net>
- 上游应用代码库： <https://github.com/pi-hole/pi-hole>
- YunoHost 商店： <https://apps.yunohost.org/app/pihole>
- 报告 bug： <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## 开发者信息

请向 [`testing` 分支](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing) 发送拉取请求。

如要尝试 `testing` 分支，请这样操作：

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
或
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**有关应用打包的更多信息：** <https://yunohost.org/packaging_apps>
