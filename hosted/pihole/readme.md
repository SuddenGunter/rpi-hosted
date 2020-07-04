# PiHole
PiHole is used as DNS with ads blocking features.

## Password-protected dashboard
Do not forget to add `WEBPASSWORD` env variable with your password, so you would be able to access the dashboard.

## YouTube history issue
PiHole default blocklist breaks youtube history in iOS app. 
Add these domains to allow-list:
- `s.youtube.com`
- `video-stats.l.google.com`