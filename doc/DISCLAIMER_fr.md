## Configuration

Utiliser le panneau d'administration de votre Pi-hole pour configurer cette application. Vous devrez peut-être aussi suivre le [guide de post-installation] (https://docs.pi-hole.net/main/post-install/) pour configurer Pi-hole en tant que *serveur DNS* ou *serveur DHCP*.

## Limitations

* Activer DHCP avec Pi-hole nécessite une configuration manuelle de votre routeur.
* Pi-Hole ne peut pas être mis à jour au-delà de la version 3.3.1, car les versions supérieures utilisent une version intégrée de dnsmasq. Ce qui oblige a désactiver la version de dnsmasq utilisée par YunoHost.
