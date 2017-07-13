//
//  ViewController.swift
//  MPCProof
//
//  Created by Daniel Thompson on 7/13/17.
//  Copyright © 2017 Daniel Thompson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var pressedLabel: UILabel!
    
    let multipeerService = MultiServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeerService.delegate = self
    }
    
    
    @IBAction func oneTapped(_ sender: UIButton) {
        var intValue = Int((sender.titleLabel?.text)!)!
        changePressedLabel(withValue: intValue)
        multipeerService.send(valueInt: &intValue)
    }
    
    @IBAction func twoTapped(_ sender: UIButton) {
        var intValue = Int((sender.titleLabel?.text)!)!
        changePressedLabel(withValue: intValue)
        multipeerService.send(valueInt: &intValue)
    }
    
    func changePressedLabel(withValue: Int){
        pressedLabel.text = String(withValue)
    }
    
}

extension ViewController: MultiServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: MultiServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices.count)"
        }
    }
    
    func valueSent(manager: MultiServiceManager, value: Int) {
        OperationQueue.main.addOperation {
            self.changePressedLabel(withValue: value)
        }
    }
    
}

