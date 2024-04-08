# node-red

This is a simple node-red deployment, it does not even have any auth enabled. Run it at your own risk.

```sh
kubectl apply -f nodered.yaml
```

To access node-red you could use ingress (if you have one) or port-forward to 1880:

```sh
kubectl port-forward -n dev svc/nodered-service 1880:1880
```

You could install node-RED plugins or configure access to MQTT broker via GUI, so no scripts to follow/document in this guide.
Just open dashboard and start building your workflows.