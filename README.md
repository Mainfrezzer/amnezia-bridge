# Amnezia Bridge

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
    -e HTTPPORT=8118 `#Privoxy Port, default is 8080` \
    -e CONNECTED_CONTAINERS= `#Optional feature of ich777 container` \
    -e ENABLE_RANDOM=0 `#Enables Random mode for the server chosen, picks a file from /etc/amnezia/amneziawg at random` \
    -e DISABLE_TUNNEL_MODE= `#Setting ANY value will disable the VPN tunnel enforcement.*` \
    -d ghcr.io/mainfrezzer/amnezia-bridge
</pre>

'*' That means the container will not ensure that all your traffic is routed through the VPN. This is useful if you want your containers only to reach specific VPN IPs but otherwise want to use your internet connection
