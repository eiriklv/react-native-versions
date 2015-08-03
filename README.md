# react-native-updater
Manages updates to React Native apps.

# Setup

Clone the reploy-cli to manage javascript bundle versions.

```
git clone git@github.com:jsierles/reploy-cli.git
```

Open the ExampleApp and run - it should load the latest bundle from the remote API.

Use the following command to push a new javascript bundle:

```
~/reploy-cli/lib/index.js push
```

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

# TODO

* Set the current JS version in NSUserDefaults
* Don't download a new bundle if the current version matches the latest remote version
* Add try/catch or other mechanism to handle bundle loading errors and fall back to main.jsbundle
* Update AppDelegate.m to use updater in production
