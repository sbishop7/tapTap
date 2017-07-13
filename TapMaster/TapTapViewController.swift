//
//  TapTapViewController.swift
//  TapMaster
//
//  Created by Seth Bishop on 7/13/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import Foundation
import UIKit

class TapTapViewController: UIViewController {
    var homeScore = 0
    var awayScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gridRefresh(num: 4)
    }
    
    func gridRefresh(num: Int) {
        // Disable & Hide all buttons while we re-populate the grid
        for view in self.view.subviews as [UIView] {
            if let node = view as? gameNode {
                node.isHidden = true
                node.isEnabled = false
            }
        }
        
        //Populate the grid & enable nodes
        for counter in 1...num {
            let pos = getRandGridPosition(i: UInt32(counter))
            let node = self.view.viewWithTag(pos) as? gameNode
            node?.isEnabled = true
            node?.isHidden = false
            node?.setTitle(String(describing: type(of: node)), for: .normal)
            print(node?.currentTitle!)
        }
    }
    
    func getRandGridPosition(i: UInt32) -> Int {
        let pos = Int(arc4random_uniform(i) + 1)
        return pos
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
