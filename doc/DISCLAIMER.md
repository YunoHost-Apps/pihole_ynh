* Any known limitations, constrains or stuff not working, such as (but not limited to):
    * Activate DHCP with Pi-hole needs manual configuration of your router.
    * Pi-Hole can't be updated beyond version 3.3.1, because higher versions use an integrated version of dnsmasq. This would require disabling the version of dnsmasq used by YunoHost.
* Other infos that people should be aware of, such as:
    * Use the admin panel of your Pi-hole to configure this app. You may also need to follow the [post-install guide](https://docs.pi-hole.net/main/post-install/) to setup Pi-hole either as a *DNS server* or a *DHCP server*.
    * Pi-hole as a DHCP server: [dhcp.md](./dhcp.md)
