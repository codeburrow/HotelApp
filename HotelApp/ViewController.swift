//
//  ViewController.swift
//  HotelApp
//
//  Created by Konstantinos Loutas on 10/07/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var beaconInRangeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - iBeacon Functionality
extension ViewController {
    
    func setupBeacon(withUuidString uuidString: String) {
        
        // Enter Your iBeacon UUID
        let uuid = UUID(uuidString: uuidString)!
        
        // Use identifier like your company name or website
        let identifier = "com.alphansotech"
        
        let Major:CLBeaconMajorValue = 100
        let Minor:CLBeaconMinorValue = 1
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: Major, minor: Minor, identifier: identifier)
        
        // call delegate when Enter iBeacon Range
        beaconRegion.notifyOnEntry = true
        
        // call delegate when Exit iBeacon Range
        beaconRegion.notifyOnExit = true
        
        // Request permission to use location services
        locationManager.requestAlwaysAuthorization()
        
        // Start monitoring the specified iBeacon Region
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
}

