# z2m

zigbee2mqtt + mosquitto to control devices connected to connbee2.

Deploy namespace first

```sh
kubectl apply -f ns.yaml
```

Add dev namespace context to kube config:

```yml
- context:
    cluster: default
    namespace: dev
    user: default
  name: dev
```

Switch to dev namespace context:

```sh
kubectl config use-context dev
```

## MQTT

I run mostly default mqtt setup, the only difference is that I want clients to be authenticated. To achieve this create `mqttcreds.txt` file and write something like (save raw usernames/passwords somewhere, you would need them later for zigbee2mqtt and node-red):

```
user1:password1
user2:password2
```

Then run `mosquitto_passwd -U passwd` to hash passwords. Mosquitto also wants you to set the correct file owner and will complain in logs that "your password file is too accessible" or something. If you want/know how to fix it painlessly - contributions are welcome. I just don't care about that warning and ignore it.

Push credentials file to k8s secret:

```sh
kubectl create secret generic mqtt-credentials --from-file=mqttcreds.txt
```

Deploy mosquitto:

```sh
kubectl apply -f mqtt.yaml
```

We could test this deployment by publishing a message and seeing it came out on the other end.

Setup port-forwarding to your cluster:

```sh
kubectl port-forward -n dev svc/mqtt-service 1883:1883
```

In first terminal window  (run and DO NOT CLOSE IT YET):

```sh
mosquitto_sub --username user1 --pw password1 --topic 'test'
```

In second terminal window:

```sh
mosquitto_pub --username user1 --pw password1 --topic 'test'  -m 'hello world'
```

If you can see a message in first terminal everything is wokring fine, you could close those terminals and close port-forwarding.

### Zigbee2MQTT

My setup is for connbee II, which is usually being mounted on the host system as `/dev/ttyACM0`. If you use another zigbee donngle, you might need to update `z2m_noakri.yaml` to use your device.

#### Long disclaimer about security

Zigbee2MQTT needs to have device access and it's a pain in k8s. Yes, device plugins exist and some of them like [akri](https://docs.akri.sh/) are part of CNCF, but I was not able to run them successfully on my setup. 

I assume the issue is caused by zigbee2mqtt implementation - having access to specific /dev/... is not enough, it also need to be able to read hosts /run/udev and [may need to have](https://kubernetes.io/blog/2021/11/09/non-root-containers-and-devices/) privileged access to host to be able to access devices. 

So, I configured it in the most straightforward and non-secure manner. Think if you want to follow my guide or try another approach. [Generic device plugin](https://github.com/squat/generic-device-plugin) seems much more user-friendly in comparison to akri if you just need to allow access to one USB device so maybe try to use it. Or check that [kubernetes document on non-root access](https://kubernetes.io/blog/2021/11/09/non-root-containers-and-devices/) to devices. 

#### Short guide on non-secure zigbee2mqtt installation

Create file for zigbee2mqtt secrets with following contents (call the file `z2msecret.yaml`):

```yaml
user: user1
password: password1
server: mqtt://mqtt-service
network_key:
  - 1
  - 1
  - 1 
  # and a few more numbers after
```

Network key should be a bit longer, to create it check this guide: https://www.zigbee2mqtt.io/advanced/zigbee/03_secure_network.html#change-zigbee-network-encryption-key .

I recommend creating network key upfront BEFORE deploying zigbee2mqtt. If you do not do it, zigbee2mqtt uses default zigbee key (which is very unsecure approach and allows anybody to access your netwrok). Another (recommended by zigbee2mqtt docs) approach is to sey `network_key: GENERATE` and it works fine for docker/docker-compose deployments, but it's PITA if you want to store network_key in k8s secret - cause zigbee2mqtt want's to update file in place and I'm not sure a container can just do it and override secret as regular file.

After you've created secret push it to k8s:

```sh
# kubectl create secret generic z2m-secret --from-file=z2msecret.yaml
```

And deploy zigbee2mqtt:

```sh
kubectl apply -f z2m_noakri.yaml
```

Wait for a bit and try opening zigbee2mqtt dashboard. Port-forward 8080 and open http://localhost:8080 in your browser.

```sh
kubectl port-forward -n dev svc/z2m-service 8080:8080
```

Pair your devices from that dashboard, rename them, etc.

## Next steps

1. You might want to configure ingress so you don't need to port-forward to access zigbee2mqtt dashboard (or other web servers in your k3s). I did not configure ingress yet, but k3s comes with traefik and it has good documenttaion - you would be able to do it on your own.

2. You might want to use something like node-RED or homeAssistant for home automation, zigbee2mqtt is just software gateway to your devices, it's not a home automation platform. If you want to go with homeAssistant I recommend running homeAssistant on a dedicated hardware device (or as a VM) with their linux distro - only then you would be able to use plugins etc. Running HA as a container is PITA, don't do it.