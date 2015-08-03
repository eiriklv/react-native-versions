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
  .then((latestVersionData) => {
    var latestVersion = latestVersionData.version_number
    console.log("latest version: "+latestVersion)
    UpdateManager.getCurrentJsVersion()
    .then((currentVersion) => {
      console.log("Current version: "+currentVersion);
      if (latestVersion == currentVersion) {
        console.log("already on the latest version");
      } else {
        UpdateManager.downloadVersionAsync(latestVersion)
        .then((path) => {
          UpdateManager.setCurrentJsVersion(latestVersion);
          AppReloader.reloadAppWithURLString(path, "ExampleApp");
        })
      }
    });
  });

var ExampleApp = React.createClass({

  getInitialState() {
    return {
      currentJsVersion: null
    }
  },

  renderCurrentJsVersion() {
    UpdateManager.getCurrentJsVersion()
    .then((version) => {
      this.setState({currentJsVersion: version});
    });
  },

  componentDidMount() {
    this.renderCurrentJsVersion();
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          React Native Update Sample App
        </Text>
        <Text>
        AppID: {appId}
        </Text>
        <Text>
        Current JS version: {this.state.currentJsVersion}
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
