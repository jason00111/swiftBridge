/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  NativeModules,
  Button,
  DeviceEventEmitter
} from 'react-native';
import Beacons from 'react-native-beacons-manager'
// import Bleacon from 'bleacon'
// import BeaconBroadcast from 'beaconbroadcast'
import BeaconBroadcast from 'react-native-ibeacon-simulator'

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {
  componentDidMount() {

    console.log('BeaconBroadcast:', BeaconBroadcast)

    const uuid = '3F643DCB-DD1E-4300-8FD6-91543CD0E648'
    BeaconBroadcast.startAdvertisingBeaconWithString(uuid, 'identifier', 1, 2)
    // const major = 5
    // const minor = 5
    // const meausredPower = -59
    //
    // Bleacon.startAdvertising(uuid, major, minor, measuredPower)
    //
    // Bleacon.startScanning()
    //
    // Bleacon.on('discover', function(bleacon) {
    //   console.log('discover:', bleacon)
    // })

    const region = {
      identifier: 'Link',
      uuid: '3F643DCB-DD1E-4300-8FD6-91543CD0E648'
    }

    Beacons.requestWhenInUseAuthorization();

    Beacons.startMonitoringForRegion(region);
    Beacons.startRangingBeaconsInRegion(region);

    Beacons.startUpdatingLocation();

    DeviceEventEmitter.addListener(
      'beaconsDidRange',
      data => {
        console.log('beaconsDidRange data:', data)
      }
    )

    DeviceEventEmitter.addListener(
      'regionDidEnter',
      data => {
        console.log('regionDidEnter data:', data)
      }
    )

    DeviceEventEmitter.addListener(
      'regionDidExit',
      data => {
        console.log('regionDidExit data:', data)
      }
    )
  }

  render() {
    // console.log('NativeModules.CalendarManager:', NativeModules.CalendarManager)
    // if (NativeModules.CalendarManager)
    //   NativeModules.CalendarManager.addEvent('a', 'b', 1, function(o) {
    //     console.log('In Callback')
    //     console.log(o)
    //   })

    // console.log('NativeModules.Sender:', NativeModules.Sender)
    //
    // NativeModules.Sender.initialize()
    // setTimeout(NativeModules.Sender.start, 5000)

    // console.log("NativeModules.Receiver:", NativeModules.Receiver)
    // NativeModules.Receiver.initialize()
    // NativeModules.Receiver.start(function(id) {
    //   console.log('id received:', id)
    // })
    // NativeModules.Receiver.start()

    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
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
