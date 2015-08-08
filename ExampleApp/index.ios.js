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
        <VersionManager
          appId="01b7cf82-9483-438a-85dd-cbffb0bbb05c"
          apiId="24950ce85f25fd50"
          apiSecret="83fzYp_-e4MzQCM9yhjt-qVRPJjNVomazyT9_xu6jkw"
          active={true}
          moduleName={moduleName} />
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
