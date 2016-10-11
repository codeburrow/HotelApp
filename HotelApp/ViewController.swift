//
//  ViewController.swift
//  HotelApp
//
//  Created by Konstantinos Loutas on 10/07/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var beaconNameLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ourselves as the CLLocationManager delegate for our locationManager
        locationManager.delegate = self
        
        // Setup our fake iPad beacon
        setupBeacon(withUuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    }

    @IBAction func requestPushNotification(_ sender: UIButton) {
//        let notifRequestUrl = "https://hotelapp-web.herokuapp.com/push"
        let notifRequestUrl = "https://hotelapp-web.herokuapp.com/push"
        Alamofire.request(notifRequestUrl).responseString { (response) in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let responseString = response.result.value {
                print("Response string: \(responseString)")
            }
        }
    }
    
}

// MARK: - Managing iBeacons
extension ViewController {
    
    func setupBeacon(withUuidString uuidString: String) {
        
        // Enter Your iBeacon UUID
        let uuid = UUID(uuidString: uuidString)!
        
        // Setup beacon details
        let identifier = "com.CLutas.fakeBeacon.iPadAir"
        let Major:CLBeaconMajorValue = 0
        let Minor:CLBeaconMinorValue = 0
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: Major, minor: Minor, identifier: identifier)
        
        // call delegate when Enter iBeacon Range
        beaconRegion.notifyOnEntry = true
        
        // call delegate when Exit iBeacon Range
        beaconRegion.notifyOnExit = true
        
        // Start monitoring the specified iBeacon Region
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager.startMonitoring(for: beaconRegion)
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
}


// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        // Tells the delegate that a iBeacon Area is being monitored
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        switch  state {
            
        case .inside:
            //The user is inside the iBeacon range.
            locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
            break
            
        case .outside:
            //The user is outside the iBeacon range.
            locationManager.stopRangingBeacons(in: region as! CLBeaconRegion)
            break
            
        default :
            // it is unknown whether the user is inside or outside of the iBeacon range.
            break
            
        }
    }
    
    // MARK: Beacon monitoring
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion with identifier \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion with identifier \(region.identifier)")
    }
    
    // MARK: Beacon ranging
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if !beacons.isEmpty {
            let currentDateTime = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
            lastSeenLabel.text = currentDateTime
            beaconNameLabel.text = region.identifier
        }
    }
    
    // Error handling
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("Ranging failed with error \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed with error \(error.localizedDescription)")
    }
    
}
