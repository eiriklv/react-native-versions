'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  AlertIOS
} = React;

var VersionManager = require('react-native-versions');

// make sure errors in promise chains are visible

var Promise = require('bluebird');

Promise.onPossiblyUnhandledRejection((error) =>{
  throw error;
});

var moduleName = "ExampleApp";

var ExampleApp = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          React Native Update Sample App - 1
        </Text>
        <VersionManager
          appId="d94bfbe9f1e87663b103"
          apiId="d0036fe2162b9a81"
          apiSecret="nVw5icQMfzO-CjVrnLcG51dj21GNYVN26b66RRWJGq4"
          active={true/*__DEV__ ? false : true*/}
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
