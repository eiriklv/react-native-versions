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

var appId = '20ecc627-bef4-432c-8d65-0e7bd6090151';

UpdateManager.configureUpdater({
  appId: appId,
});

var list = UpdateManager.discoverLatestVersionAsync()
  .then((latest) => {

    if (latest.bundle_hash === UpdateManager.currentJSVersion) {
      console.log("Already running current version " + UpdateManager.currentJSVersion);
    } else {
      UpdateManager.downloadVersionAsync(latest.bundle_hash)
      .then((path) => {
        console.log("downloaded "+latest.bundle_hash)
        AppReloader.reloadAppWithURLString(path, "ExampleApp");
      })
      .catch((err) => {

      });

    }

  })
  .catch((err) => {
    console.log(err);
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
