//
//  File.swift
//  EERouter
//
//  Created by Shakhmar Sarsenbay on 12.03.2018.
//  Copyright © 2018 Shakhmar Sarsenbay. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController1: UIViewController {
    
    let manager = CMMotionManager()
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a ni
            
            
            if manager.isDeviceMotionAvailable{
            
                manager.deviceMotionUpdateInterval = 0.02
                manager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (data:CMDeviceMotion?, error:Error?) in
                    print("Acceleration x \(data!.userAcceleration.x)")
                    print("Rotation x \(data!.rotationRate.x)")
                    print("Gravity z \(data!.gravity.z)")

                })
            
            }
    }
    
}
