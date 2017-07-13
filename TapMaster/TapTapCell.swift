//
//  TapTapCell.swift
//  TapMaster
//
//  Created by Daniel Thompson on 7/13/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import UIKit

protocol TapTapCellDelegate {
    func handleCellTap(withValue: Int)
}

class TapTapCell: UICollectionViewCell {
    
    var timer = Timer()
    
    @IBOutlet weak var tapButton: UIButton!
    
    var delegate: TapTapCellDelegate?
    
    var value: Int = 10
    
    @IBAction func cellTapped(_ sender: UIButton) {
        delegate?.handleCellTap(withValue: value)
    }
    
    func restartTimer() {
        let n = getTimeDuration()
        value = Int(n) * 5
        tapButton.setTitle(String(format: "%.2f", n), for: .normal)
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    func timerAction(){
        restartTimer()
    }
    
    func getTimeDuration() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 2.0 + 0.5
    }
    
}
