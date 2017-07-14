//
//  TapTapCell.swift
//  TapMaster
//
//  Created by Daniel Thompson on 7/13/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import UIKit

protocol TapTapCellDelegate {
    func handleCellTap(withDict: NSDictionary)
}

enum CellState {
    case normal
    case disabled
    case telekinesis
}

class TapTapCell: UICollectionViewCell {
    
    var timer = Timer()
    
    @IBOutlet weak var tapButton: UIButton!
    
    var delegate: TapTapCellDelegate?
    
    var value: Int = 10
    
    var tapDictionary = NSDictionary()
    
    var cellState: CellState?
    
    @IBAction func cellTapped(_ sender: UIButton) {
        delegate?.handleCellTap(withDict: tapDictionary)
    }
    
    func restartTimer() {
        let n: CGFloat = getTimeDuration()
        value = determineCellValue(duration: n)
        
        tapDictionary.setValue(value, forKey: "value")
        // some sort of buff attribute value
        // tapDictionary.setValue([], forKey: "events")
        
        tapButton.setTitle(String(format: "%.2f", value), for: .normal)
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        
    }
    
    func timerAction(){
        restartTimer()
    }
    
    func determineCellValue(duration: CGFloat) -> Int {
        if duration > 2.0 {
            return randomInt(min: 1, max: 50) / 5
        }
        if 1.5 < duration && duration <= 2.0 {
            return randomInt(min: 25, max: 75) / 3
        }
        if 1.0 < duration && duration <= 1.5 {
            return randomInt(min: 50, max: 100) / 2
        }
        if 0.5 <= duration && duration <= 1.0 {
            return randomInt(min: 100, max: 200) / 1
        }
        return 0
    }
    
    func getTimeDuration() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 2.0 + 0.5
    }
    
    func randomInt(min:Int, max:Int) -> Int {
        return Int(arc4random_uniform(UInt32(max + min))) + min + 1
    }
    
}
