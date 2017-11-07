//
//  CalendarManager.swift
//  SwiftBridge
//
//  Created by Jason Emberley on 10/31/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth

// CalendarManager.swift

@objc(CalendarManager)
class CalendarManager: NSObject {

  @objc func addEvent(_ name: String, location: String, date: NSNumber, callback: (NSObject) -> () ) -> Void {
    // NSLog("%@ %@ %S", name, location, date);
    print("in CalendarManager addEvent with parameters:")
    print(name)
    print(location)
    print(date)

    callback( [[
      "name": name,
      "location": location,
      "date": date,
    ]] as NSObject!)
  }

}

@objc(Receiver)
class Receiver: NSObject, CLLocationManagerDelegate {
  var beaconRegion:CLBeaconRegion!
  var locationManager:CLLocationManager!
  var foundBeaconCallback:((NSObject, NSObject) -> Void)!

  @objc func initialize() -> Void {
    DispatchQueue.main.sync
    {
      self.locationManager = CLLocationManager()
      self.locationManager.delegate = self

      let uuid = UUID(uuidString: "3F643DCB-DD1E-4300-8FD6-91543CD0E648")! as UUID
      self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "com.agi.beacon")

      self.beaconRegion.notifyOnEntry = true
      self.beaconRegion.notifyOnExit = true

      self.foundBeaconCallback = { (error: NSObject, input: NSObject) -> Void in
        var thing = input
      }
    }
  }

  @objc func start(_ callback: ((NSObject, NSObject) -> ())!) -> Void {
    self.foundBeaconCallback = callback
    // callback(["key": "value"] as NSObject)
    // callback(["key": "value"] as NSObject)

    locationManager.requestWhenInUseAuthorization()
    locationManager.startMonitoring(for: beaconRegion)
    print("just called startMonitoring")
    locationManager.startRangingBeacons(in: beaconRegion)
  }

  // @objc func start() -> Void {
  //   locationManager.requestWhenInUseAuthorization()
  //   locationManager.startMonitoring(for: beaconRegion)
  //   print("just called startMonitoring")
  //   locationManager.startRangingBeacons(in: beaconRegion)
  // }

  func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    print("in didStartMonitoringFor")
    print(region)
    locationManager.requestState(for: region)
  }

  func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
      //
      if state == .inside {
          locationManager.startRangingBeacons(in: beaconRegion)
          print("state is .inside")
      } else {
          locationManager.stopRangingBeacons(in: beaconRegion)
          print("state is not .inside")
      }
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
      //
      print("beacon entered: \(region)")
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
      //
      print("beacon exited: \(region)")
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
      print("in didRangeBeacons, beacons:")
      print(beacons)
      if beacons.count > 0 {
          // foundBeaconCallback(beacons[0].major)
          print("beacons:")
          print(beacons)

          // locationManager.stopRangingBeacons(in: region)

          // self.updateButtonTitle()
      }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("failed: \(error)")
  }

  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
      print("failed: \(error)")
  }

  func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
      print("failed: \(error)")
  }

}

@objc(Sender)
class Sender: NSObject, CBPeripheralManagerDelegate {
  var peripheralManager: CBPeripheralManager!

  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    var state: String

    switch peripheralManager.state {
    case .poweredOn:
      state = "poweredOn"
    case .poweredOff:
      state = "poweredOff"
    case .unauthorized:
      state = "unauthorized"
    case .unknown:
      state = "unknown"
    case .unsupported:
      state = "unsupported"
    default:
      state = "default"
    }

    print("state: \(state)")
  }

  @objc func initialize() -> Void {
    print("about to create peripheralManager")

    peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
  }


  @objc func start() -> Void {
    print("advertising: \(peripheralManager.isAdvertising)")
    print("about to start advertising")

    // let advertisementData = [CBAdvertisementDataLocalNameKey: "Test Device"]

    if case .poweredOn = peripheralManager.state {
      print("bluetooth powered on")
      // peripheralManager.startAdvertising(advertisementData)
      let region = createBeaconRegion()
      advertiseDevice(region: region!)
    } else {
      print("Warning! Can't start advertising while bluetooth not in powered on state")
    }

    print("advertising2: \(peripheralManager.isAdvertising)")
  }

  func advertiseDevice(region : CLBeaconRegion) {
    let peripheralData = region.peripheralData(withMeasuredPower: nil)

    peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
  }
}

func createBeaconRegion() -> CLBeaconRegion? {
    let proximityUUID = UUID(uuidString:
                "3F643DCB-DD1E-4300-8FD6-91543CD0E648")
    let major : CLBeaconMajorValue = 100
    let minor : CLBeaconMinorValue = 1
    let beaconID = "com.example.myDeviceRegion"

    return CLBeaconRegion(proximityUUID: proximityUUID!,
                major: major, minor: minor, identifier: beaconID)
}


// @objc(Sender)
// class Sender: NSObject, CBPeripheralManagerDelegate {
//   // var peripheralManager: CBPeripheralManager!
//
//   @objc func start() -> Void {
//     // peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//   }
// }



// func createBeaconRegion() -> CLBeaconRegion? {
//     let proximityUUID = UUID(uuidString:
//                 "39ED98FF-2900-441A-802F-9C398FC199D2")
//     let major : CLBeaconMajorValue = 100
//     let minor : CLBeaconMinorValue = 1
//     let beaconID = "com.example.myDeviceRegion"
//
//     return CLBeaconRegion(proximityUUID: proximityUUID!,
//                 major: major, minor: minor, identifier: beaconID)
// }

// func advertiseDevice(region : CLBeaconRegion) {
//     let peripheral = CBPeripheralManager(delegate: self, queue: nil)
//     let peripheralData = region.peripheralData(withMeasuredPower: nil)
//
//     peripheral.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
// }
