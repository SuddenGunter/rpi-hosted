# V3

V3 is organized by docker network.


## iot

IoT is a network for mqtt, zigbee2mqtt and smart home automations

### mqtt

MQTT directory deploys zigbee2mqtt and eclipse mosquitto.

My setup is for connbee II, which is usually being mounted on the host system as `/dev/ttyACM0`. If you use another zigbee donngle, you might need to update `z2m_noakri.yaml` to use your device.

What do you need to change for your deployment:

1. Create mqtt passwords file in mqtt/mqtt directory:
```sh
mosquitto_passwd -c mqttcreds.txt zigbee2mqtt # create new file
mosquitto_passwd mqttcreds.txt admin # append user to file
```

2. Update `mqtt/zigbee2mqtt/configuration.yaml` with your mqtt credentials and [network key](https://www.zigbee2mqtt.io/guide/configuration/zigbee-network.html#network-config).

3. Deploy the contents of mqtt folder to your server, run with `docker compose up -d`

