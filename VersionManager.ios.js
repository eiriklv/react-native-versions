'use strict';

var React = require('react-native');
var {
  View,
  PropTypes,
  StyleSheet,
  Text,
  TouchableOpacity,
  NativeModules: {
    VersionManager, AppReloader
  }
} = React;

var Modal = require('react-native-modal');

var Versions = React.createClass({
  propTypes: {
    /**
     * Determines whether the updater is active
     */
    active: React.PropTypes.bool,
    /**
     * top level application module name
     */
    moduleName: React.PropTypes.string.isRequired
  },

  getDefaultProps(): Props {
    return {
      active: false,
      moduleName: "ExampleApp"
    }
  },

  closeModal() {
    this.setState({modalVisible: false});
  },

  getInitialState() {
    return {
      modalVisible: false
    }
  },

  updateToVersion(version) {
    VersionManager.downloadVersionAsync(version)
    .then((path) => {
      VersionManager.setCurrentJsVersion(version);
      AppReloader.reloadAppWithURLString(path, this.props.moduleName);
    })
  },

  componentDidMount() {

    VersionManager.configureUpdater({appId: this.props.appId});

    VersionManager.getCurrentJsVersion()
    .catch((err) => {
      console.log(err);
    })
    .then((currentVersion) => {
      VersionManager.discoverLatestVersionAsync()
        .catch((err) => {
          // error fetching the latest version
          console.log(err);
        })
        .then((latestVersionData) => {
          var latestVersion = latestVersionData.version_number;
          if (latestVersion == currentVersion) {
            console.log("Already on the latest version!");
          } else {
            console.log('modal');
            this.setState({modalVisible: true, version: latestVersion})
          }
        });
      });
  },

  render() {
    if (this.props.active) {
      return (
        <Modal forceToFront={true} isVisible={this.state.modalVisible}>
          <Text style={styles.title}>Do you want to update to version {this.state.version}?</Text>
          <TouchableOpacity onPress={() => this.closeModal()}>
            <Text style={styles.button}>Cancel</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => this.updateToVersion(this.state.version)}>
            <Text style={styles.button}>Update now</Text>
          </TouchableOpacity>
        </Modal>
      );
    } else {
      return <View />;
    }
  },
});

var styles = StyleSheet.create({
  title: {
    fontSize: 15,
    fontWeight: "500",
    textAlign: 'center',
    marginBottom: 10
  },
  button: {
    fontSize: 15,
    fontWeight: "500",
    textAlign: 'center',
    borderWidth: 1,
    borderColor: '#aaa',
    borderRadius: 5,
    margin: 5,
    padding: 5
  }
})

module.exports = Versions;
