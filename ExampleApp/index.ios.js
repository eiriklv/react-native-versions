/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  NativeModules: {
    UpdateManager, AppReloader
  }
} = React;

var Promise = require('bluebird');
// we still want to see the red screen of death when
// we have issues like wrong variables etc. within a promise chain
Promise.onPossiblyUnhandledRejection((error) =>{
  throw error;
});

var appId = '20ecc627-bef4-432c-8d65-0e7bd6090151';

UpdateManager.configureUpdater({
  appId: appId,
});

var list = UpdateManager.discoverLatestVersionAsync()
  .then((latestVersion) => {
    console.log("latest version is "+latestVersion.bundle_hash)
    UpdateManager.getCurrentJsVersion()
    .then((currentVersion) => {
      console.log("Current version is "+currentVersion);
      if (latestVersion.bundle_hash === currentVersion) {
        console.log("already on the latest version");
      } else {
        UpdateManager.downloadVersionAsync(latestVersion.bundle_hash)
        .then((path) => {
          UpdateManager.setCurrentJsVersion(latestVersion.bundle_hash);
          AppReloader.reloadAppWithURLString(path, "ExampleApp");
        })
      }
    });
  });

var ExampleApp = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          React Native Update Sample App
        </Text>
        <Text>
        AppID: {appId}
        </Text>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('ExampleApp', () => ExampleApp);
