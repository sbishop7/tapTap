//
//  TapTapGameClasses.swift
//  TapMaster
//
//  Created by John Colley on 7/13/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import Foundation
import UIKit


// Consider how to add weight to nodes for balanced gameplay

class gameNode: UIButton {
    func gen(type: String) -> gameNode {
        if type == "score" {
            let node = scoreNode()
            node.value = 10
            return node
        } else if type == "buff" {
            let node = buffNode()
            return node
        }
        let node = deBuffNode()
        return node
    }
}

class scoreNode: gameNode {
    var value: Int = 0
}

class buffNode: gameNode {
    func multi(value: Int) -> Int {
        let multi = value * 10
        return multi
    }
}

class deBuffNode: gameNode {
    func subtract(value: Int) -> Int {
        let sub = value - 10
        return sub
    }
}

// Add MiniGame class
