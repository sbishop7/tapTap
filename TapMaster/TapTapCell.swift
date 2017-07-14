//
//  TapTapCell.swift
//  TapMaster
//
//  Created by Daniel Thompson on 7/13/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import UIKit

protocol TapTapCellDelegate {
    func handleCellTap(withDict: NSMutableDictionary)
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
    
    var tapDictionary = NSMutableDictionary()
    
    var cellState: CellState?
    
    @IBAction func cellTapped(_ sender: UIButton) {
        delegate?.handleCellTap(withDict: tapDictionary)
    }
    
    func restartTimer() {
        let n: CGFloat = getTimeDuration()
        value = determineCellValue(duration: n)
        tapDictionary.setValue(value, forKey: "value")
        // some sort of buff attribute value
        tapDictionary.setValue([], forKey: "events")
        
        formatTapButton(value: value, bgColor: 1.0, bgAlpha: 1.0, bgImage: #imageLiteral(resourceName: "Spaceship"))
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
            return randomInt(min: 100, max: 200)
        }
        return value
    }
    
    func randInvert(val: Int) -> Int {
        var value = val
        let rand = randomInt(min: 1, max: 100)
        if rand >= 50 {
            value = -abs(val)
        }
        return value
    }
    
    func formatTapButton(value: Int, bgColor: CGFloat, bgAlpha: CGFloat, bgImage: UIImage?) {
        var strokeTextAttributes = [
            NSStrokeWidthAttributeName: -3.0,
            NSStrokeColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 25)
            ] as [String: Any]
        if value > 0 {
            strokeTextAttributes[NSForegroundColorAttributeName] = UIColor.green
        } else {
            strokeTextAttributes[NSForegroundColorAttributeName] = UIColor.red
        }
            let tapButtonNormalAttributedTitle = NSAttributedString(string: String(value),
                                                             attributes: strokeTextAttributes)
            tapButton.setAttributedTitle(tapButtonNormalAttributedTitle, for: .normal)
        
        tapButton.backgroundColor = UIColor(white: bgColor, alpha: bgAlpha)
        tapButton.setBackgroundImage(bgImage, for: .normal)
    }
    
    func getTimeDuration() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 2.0 + 0.5
    }
    
    func randomInt(min:Int, max:Int) -> Int {
        return randInvert(val: Int(arc4random_uniform(UInt32(max - min))) + min + 1)
    }
    
}
