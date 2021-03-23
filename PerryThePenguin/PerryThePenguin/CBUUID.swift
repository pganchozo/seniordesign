//
//  CBUUID.swift
//  PerryThePenguin
//
//  Created by Patricia  Ganchozo on 3/22/21.
//

import Foundation
import CoreBluetooth


struct CBUUIDs{
  static let kBLEService_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
  static let kBLE_Characteristic = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"

  static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
  static let BLE_Characteristic_UUID = CBUUID(string: kBLE_Characteristic)//(Property: Notify)
}
