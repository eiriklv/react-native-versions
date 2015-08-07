'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  AlertIOS
} = React;

var VersionManager = require('./VersionManager.ios');

// make sure errors in promise chains are visible

var Promise = require('bluebird');

Promise.onPossiblyUnhandledRejection((error) =>{
  throw error;
});

var moduleName = "ExampleApp";

var ExampleApp = React.createClass({

  getInitialState() {
    return {
      currentJsVersion: null
    }
  },

  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          React Native Update Sample App
        </Text>
        <VersionManager appId="20ecc627-bef4-432c-8d65-0e7bd6090151" active={true} moduleName={moduleName} />
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

AppRegistry.registerComponent(moduleName, () => ExampleApp);
