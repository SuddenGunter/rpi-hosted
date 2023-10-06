# PiHole
PiHole is used as DNS with ads blocking features.

## Password-protected dashboard
Do not forget to add `WEBPASSWORD` env variable with your password, so you would be able to access the dashboard.

## YouTube history issue
PiHole default blocklist breaks youtube history in iOS app. 
Add these domains to allow-list:
- `s.youtube.com`
- `video-stats.l.google.com`

## Recommended whitelist of domains:

```
# google maps
clients4.google.com
clients2.google.com

# youtube
s.youtube.com
video-stats.l.google.com
oauthaccountmanager.googleapis.com
youtubei.googleapis.com
www.googleapis.com

# fonts
gstaticadssl.l.google.com

# gmail
googleapis.l.google.com

# windows
www.msftncsi.com
sls.update.microsoft.com.akadns.net
fe3.delivery.dsp.mp.microsoft.com.nsatc.net
tlu.dl.delivery.mp.microsoft.com

# apple
appleid.apple.com
gsp-ssl.ls.apple.com
gsp-ssl.ls-apple.com.akadns.net
itunes.apple.com
s.mzstatic.com

# cdn for miro
cdn.split.io
events.split.io
sdk.split.io
```