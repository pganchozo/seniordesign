//
//  ViewController.swift
//  PerryThePenguin
//
//  Created by terry zhen on 11/1/20.
//

import UIKit
import CoreBluetooth
import Foundation



class ViewController: UIViewController {

//    @IBOutlet var scanningLabel: UILabel!
    
    var simpleBluetoothIO: SimpleBluetoothIO!
    
    private var centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral!
    private var lidarCharacteristic: CBCharacteristic!
    
    override func viewDidLoad() {
        
//        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID:  "00000001-6A3B-6A49-FFC5-75CCA7D03E2D", delegate: self)
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)


    }
    
    @IBAction func startScanning() -> Void {
        
      centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
            debugPrint("scanning...")
    }
    
    @IBAction func launchGPS(_ sender: Any) {
        guard (storyboard?.instantiateViewController(identifier: "gps_vc") as? GpsViewController) != nil else {
            return
        }
    }
    
    @IBAction func launchScan(_ sender: Any) {
        guard (storyboard?.instantiateViewController(identifier: "textspeech_vc") as? TextSpeechViewController) != nil else {
            return
        }
    }
}


extension ViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {

    switch central.state{
        case .poweredOff:
            print("Is powered off.")
        case .poweredOn:
            startScanning()
        case .unsupported:
            print("Unsupported")
        case .unauthorized:
            print("Unauthorized")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
          }
        }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        bluefruitPeripheral = peripheral
        bluefruitPeripheral.delegate = self

        print("Peripheral Discovered: \(peripheral)")
        print("Peripheral name: \(peripheral.name)")
        print("Advertisement Data: \(advertisementData)")

        centralManager?.connect(bluefruitPeripheral!, options: nil)
          //centralManager?.stopScan()
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
    }

//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
//      bluefruitPeripheral.discoverServices([CBUUIDs.BLEServices])
//    }
}

extension ViewController: CBPeripheralDelegate {
    

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    
    if ((error) != nil) {
      print("Error discovering services: \(error!.localizedDescription)")
      return
    }

    guard let services = peripheral.services else { return }
    for service in services {
      peripheral.discoverCharacteristics(nil, for: service)
    }
    
    print("Discovered Services: \(services)")
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    
    
    guard let characteristics = service.characteristics else {
      return
    }
    
    print("Found")

    for characteristic in characteristics {
        
        if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_UUID) {
        
            lidarCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: lidarCharacteristic!)

            print("Lidar Characteristic: \(lidarCharacteristic)")
      }
    }
  }
}

