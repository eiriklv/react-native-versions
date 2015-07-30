# react-native-updater
Manages updates to React Native apps.


# Updater API

Rails app hosted at reploy.io with no authentication. Just for testing! Apps are assigned a UUID. Binary versions are the App Store version. JS versions are the MD5 hash of the jsbundle.

Create app
```POST http://replay.io/apps.json```

List apps
```GET http://reploy.io/apps.json```

List JS bundle versions for a binary release
```GET http://reploy.io/apps/a3325f20-b08c-4d8a-b313-d964c5d23bdc/1.0/js_versions.json```

Download JS bundle
```GET http://reploy.io/apps/a3325f20-b08c-4d8a-b313-d964c5d23bdc/1.0/js_versions/1f3b5bb596cdd49345812b113809b2cf```

Create JS bundle version
```POST http://replay.io/apps/a3325f20-b08c-4d8a-b313-d964c5d23bdc/1.0/js_versions```

See https://github.com/jsierles/reploy-web for the implementation.