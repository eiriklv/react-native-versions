Manage javascript bundle versions over the wire from your React Native app.

# Installation

When we have a final release, you can install straight from npm. For now, via this repository:

```
npm install reploy/react-native-versions
```

## The Example App

To get an idea how this works, check the ExampleApp. You should be able to open it and see it pull an update from the Reploy Versions API.

### Setup your AppDelegate

We've left it up to you to load the new javascript version from the native side. Check ```ExampleApp/AppDelegate.m``` for an example. Here, the bundle is loaded into a new RCTRootView, which in turn gets loaded into a new rootViewController with a flip transition animation.

### Setup your top level component to handle version updates

We decided to put most of the version update logic in javascript, for flexibility on the UI side, and easier compatibility with Android. See ExampleApp/index.ios.js for default usage and VersionManager.ios.js to see the logic. The API should be pretty clear there.

### Setup API credentials

You'll need API credentials to use the free API at reploy.io. Or, implement your own based on the examples below.

To use the hosted Reploy API, install the command line client.

```
npm install -g reploy
```

Then, signup for an account. Your personal API token will get installed in ~/.reploy.

```
reploy Setup
```

Finally, from within your React Native project, register your app. This will drop the app's own credentials in .reploy. These are the values you pass to VersionManager.

```
reploy create-app

```

### Release a javascript version

Now the fun part! By default, reploy will run `react-native bundle`, then try to upload the resulting file in iOS/main.jsbundle.

```
reploy push
```

If you want to generate your own bundle, you can skip the bundle step.

```
reploy push -s

``

When your app starts up in *release mode*, it should prompt for an update!

# The Reploy Versions API

Create app
```POST /api/v1//apps```

List apps
```GET /api/v1/apps```

Get info about the latest version
```GET /api/v1/apps/:appId/js_versions/latest```

Download JS bundle contents
```GET /api/v1/apps/:appId/js_versions/:versionNumber```

Create JS bundle version
```POST /api/v1/apps/:appId/js_versions```

## Authentication

Authenticate to the API using X-Secret and X-SecretId HTTP headers.
