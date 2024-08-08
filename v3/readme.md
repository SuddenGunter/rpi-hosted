# V3

V3 is organized by docker network. Deployment is done using [go-task](https://github.com/go-task/task)

## infra

Infra handles reverse-proxy, metrics collection etc.


### reproxy

Reproxy is a reverse proxy that (in current configuration) designed to work over https. I use certbot generated certificate that I share with reproxy container via docker volume. I generate certs via certbot manually for now.

```sh
docker run -it --rm --name certbot \
                        -v "./letsencrypt:/etc/letsencrypt"  -v "./cf:/cf" \
                        certbot/dns-cloudflare certonly --dns-cloudflare --dns-cloudflare-credentials='/cf/cfcreds'  -d '*.myhostname'
```



## iot

IoT is a network for mqtt, zigbee2mqtt and smart home automations.

To deploy use `task deploy:infra`

### mqtt

MQTT directory deploys zigbee2mqtt and eclipse mosquitto.

My setup is for connbee II, which is usually being mounted on the host system as `/dev/ttyACM0`. If you use another zigbee donngle, you might need to update `mqtt/zigbee2mqtt/configuration.yaml` and `docker-compose.yaml` to use your device.

What do you need to change for your deployment:

1. Create mqtt passwords file in mqtt/mqtt directory:
```sh
mosquitto_passwd -c mqttcreds.txt zigbee2mqtt # create new file
mosquitto_passwd mqttcreds.txt admin # append user to file
```

2. Update `mqtt/zigbee2mqtt/configuration.yaml` with your mqtt credentials and [network key](https://www.zigbee2mqtt.io/guide/configuration/zigbee-network.html#network-config).


3. Run `task deploy:iot`.