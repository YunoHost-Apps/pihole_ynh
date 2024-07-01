<!--
Ohart ongi: README hau automatikoki sortu da <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>ri esker
EZ editatu eskuz.
-->

# Pi-hole YunoHost-erako

[![Integrazio maila](https://dash.yunohost.org/integration/pihole.svg)](https://ci-apps.yunohost.org/ci/apps/pihole/) ![Funtzionamendu egoera](https://ci-apps.yunohost.org/ci/badges/pihole.status.svg) ![Mantentze egoera](https://ci-apps.yunohost.org/ci/badges/pihole.maintain.svg)

[![Instalatu Pi-hole YunoHost-ekin](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=pihole)

*[Irakurri README hau beste hizkuntzatan.](./ALL_README.md)*

> *Pakete honek Pi-hole YunoHost zerbitzari batean azkar eta zailtasunik gabe instalatzea ahalbidetzen dizu.*  
> *YunoHost ez baduzu, kontsultatu [gida](https://yunohost.org/install) nola instalatu ikasteko.*

## Aurreikuspena

The Pi-hole® is a DNS sinkhole that protects your devices from unwanted content without installing any client-side software.

**Paketatutako bertsioa:** 5.18.2~ynh1

## Pantaila-argazkiak

![Pi-hole(r)en pantaila-argazkia](./doc/screenshots/dashboard.png)

## :red_circle: Ezaugarri zalantzagarriak

- **Mantendu gabeko paketea**: YunoHost pakete honek ez du mantenduko duenik, bere gain hartuko duen norbaiten beharra dauka. Honek esan nahi duena da mantentze-lanak minimoak izango direla eta aplikazioa erabiltzen ez duten boluntarioek egingo dituztela lanok; denborak aurrera egin ahala fidagarri izateari utziko dio. [Aplikazioak nola paketatu](https://yunohost.org/packaging_apps_intro) ikas dezakezu, zure gain hartu nahi baduzu.

## Dokumentazioa eta baliabideak

- Aplikazioaren webgune ofiziala: <https://pi-hole.net/>
- Administratzaileen dokumentazio ofiziala: <https://docs.pi-hole.net>
- Jatorrizko aplikazioaren kode-gordailua: <https://github.com/pi-hole/pi-hole>
- YunoHost Denda: <https://apps.yunohost.org/app/pihole>
- Eman errore baten berri: <https://github.com/YunoHost-Apps/pihole_ynh/issues>

## Garatzaileentzako informazioa

Bidali `pull request`a [`testing` abarrera](https://github.com/YunoHost-Apps/pihole_ynh/tree/testing).

`testing` abarra probatzeko, ondorengoa egin:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
edo
sudo yunohost app upgrade pihole -u https://github.com/YunoHost-Apps/pihole_ynh/tree/testing --debug
```

**Informazio gehiago aplikazioaren paketatzeari buruz:** <https://yunohost.org/packaging_apps>
