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
  AlertIOS,
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

  updateToVersion(version) {
    UpdateManager.downloadVersionAsync(version)
    .then((path) => {
      UpdateManager.setCurrentJsVersion(version);
      AppReloader.reloadAppWithURLString(path, "ExampleApp");
    })
  },

  componentDidMount() {
    UpdateManager.getCurrentJsVersion()
    .then((currentVersion) => {
      this.renderCurrentJsVersion()
      UpdateManager.discoverLatestVersionAsync()
        .catch((err) => {
          // error fetching the latest version
          console.log(err);
        })
        .then((latestVersionData) => {
          var latestVersion = latestVersionData.version_number;
          if (latestVersion == currentVersion) {
            console.log("Already on the latest version!");
          } else {
            AlertIOS.alert(
              'Application update available',
              `Would you like to upgrade to version ${latestVersion}?`,
              [
                {text: 'Cancel', onPress: () => console.log('Cancelled')},
                {text: 'Update', onPress: () => this.updateToVersion(latestVersion)},
              ]
            )

          }
        });
      });

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
