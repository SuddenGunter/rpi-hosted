# Hassio aka Home Assistant
Hassio is my "smart" home heart and brain. It communicates with my wifi devices directly and zigbee devices using deconz container.


## YeeLight bulb
This bulb has some problems with discovery so I add it manually here.
This must be in `cfg/configuration.yaml`:
```
discovery:
  ignore:
    - yeelight
yeelight:
  devices:
    BULB_IPv4:
      name: Living Room
```