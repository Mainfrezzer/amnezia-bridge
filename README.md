# Amnezia Bridge

## Small Note ##
Ive discovered something rather funky with amnezia, im not sure if wireguard has the same "issue"
If you declare a ipv4 address as endpoint in the config, local v6 connections via lan will fail.
That will not happen if your amnezia config uses a domain name, which might resolve to a ipv4 or you use a ipv6 address. Not sure why it happens yet but i noticed it while i swapped some configs around

## Quick Start

### Unraid
The template can be downloaded here
<pre>
  https://github.com/Mainfrezzer/UnRaid-Templates/blob/main/mainfrezzer-amnezia-bridge.xml
</pre>

### Docker run
<pre>
docker run --name amnezia-bridge \
    --restart unless-stopped \
    --cap-add=NET_ADMIN \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    -v /my/own/dir:/etc/amnezia/amneziawg/ \
    -p 1080:1080/tcp `#Socks5` \
    -p 8080:8080/tcp `#Privoxy` \
    -e LAN_NETWORK=192.168.3.0/24 `#supports multiple networks, use "," as divider` \
    -e LAN_NETWORK6=fd00::/64 `#supports multiple networks, use "," as divider` \
    -e HTTPPORT=8080 `#Privoxy Port, default is 8080` \
    -e CONNECTED_CONTAINERS= `#Optional feature of ich777 container` \
    -e ENABLE_RANDOM=0 `#Enables Random mode for the server chosen, picks a file from /etc/amnezia/amneziawg at random` \
    -e HEALTH_URL_CHECK= `#Custom URL or IP to ping for the healthcheck`\
    -e DISABLE_TUNNEL_MODE= `#Setting ANY value will disable the VPN tunnel enforcement.*` \
    -d ghcr.io/mainfrezzer/amnezia-bridge
</pre>

### Compose ###

<pre>
  amnezia-bridge:
       container_name: amnezia-bridge
       network_mode: bridge
       restart: unless-stopped
       cap_add:
           - NET_ADMIN
       sysctls:
           - net.ipv4.conf.all.src_valid_mark=1
       volumes:
           - /my/own/dir:/etc/amnezia/amneziawg/
       ports:
           - 1080:1080/tcp #Socks5
           - 8080:8080/tcp #Privoxy
       environment:
           - LAN_NETWORK=192.168.3.0/24 #supports multiple networks, use "," as divider
           - LAN_NETWORK6=fd00::/64 #supports multiple networks, use "," as divider
           - HTTPPORT=8080 #Privoxy Port, default is 8080
           - CONNECTED_CONTAINERS= #Optional feature of ich777 container
           - ENABLE_RANDOM=0 #Enables Random mode for the server chosen, picks a file from /etc/wireguard at random
           - DISABLE_TUNNEL_MODE= #Setting ANY value will disable the VPN tunnel enforcement.*
           - HEALTH_URL_CHECK= #Custom URL or IP to ping for the healthcheck
       image: ghcr.io/mainfrezzer/amnezia-bridge
</pre>

'*' That means the container will not ensure that all your traffic is routed through the VPN. This is useful if you want your containers only to reach specific VPN IPs but otherwise want to use your internet connection




