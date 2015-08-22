'use strict';

var React = require('react-native');
var {
  View,
  PropTypes,
  StyleSheet,
  Text,
  TouchableOpacity,
  AlertIOS,
  Modal,
  NativeModules: {
    VersionManager
  }
} = React;

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
      VersionManager.loadJsVersion(version, path, this.props.moduleName);
    })
    .catch((err) => {
      // error downloading the latest version
      console.log(err);
    });
  },

  componentDidMount() {
    if (this.props.active) {
      VersionManager.configure({
        appId: this.props.appId,
        apiId: this.props.apiId,
        apiSecret: this.props.apiSecret
      });

      VersionManager.getCurrentJsVersion()
      .then((currentVersion) => {
        VersionManager.discoverLatestVersionAsync()
        .then((latestVersionData) => {
          var latestVersion = latestVersionData.version_number;
          if (latestVersion == currentVersion) {
            console.log("Already on the latest version!");
          } else {
            console.log("New version detected...");
            this.setState({modalVisible: true, version: latestVersion});
            this.showAlert();
          }
        })
        .catch((err) => {
          // error fetching the latest version
          console.log(err);
        });
      })
      .catch((err) => {
        // error getting current version
        console.log(err);
      });
    }
  },

  renderModal() {
    return (
      
      <Modal animated={true} visible={this.state.modalVisible}>
        <Text style={styles.title}>Do you want to update to version {this.state.version}?</Text>
        <TouchableOpacity onPress={() => this.closeModal()}>
          <Text style={styles.button}>Cancel</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => this.updateToVersion(this.state.version)}>
          <Text style={styles.button}>Update now</Text>
        </TouchableOpacity>
      </Modal>
    );
  },

  showAlert() {
    return AlertIOS.alert(
        'Update available',
        'Version '+this.state.version,
        [
          {text: 'Update', onPress: () => this.updateToVersion(this.state.version)},
          {text: 'Cancel', onPress: () => this.closeModal()},
        ]
      )
  },

  render() {
    return <View />;
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
