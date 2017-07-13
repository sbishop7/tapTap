//
//  TapTapViewController.swift
//  TapMaster
//
//  Created by Seth Bishop on 7/13/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import Foundation
import UIKit

class GameSceneController: UIViewController {
    
    var score = 0
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var tapCellsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapCellsCollection.delegate = self
        tapCellsCollection.dataSource = self
        tapCellsCollection.isScrollEnabled = false
    }
    
   
}

extension GameSceneController: TapTapCellDelegate {
    func handleCellTap(withValue value: Int) {
        score += value
        myScoreLabel.text = String(score)
    }
}

extension GameSceneController: UICollectionViewDelegate {
    
}

private let itemsPerRow: CGFloat = 4
private let sectionInsets = UIEdgeInsets( top: 5.0, left: 5.0, bottom: 5.0, right: 5.0 )

extension GameSceneController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension GameSceneController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TapTapCell", for: indexPath) as? TapTapCell
        cell?.delegate = self
        cell?.restartTimer()
        return cell!
    }
    
}




//func gridRefresh(num: Int) {
//    // Disable & Hide all buttons while we re-populate the grid
//    for view in self.view.subviews as [UIView] {
//        if let node = view as? gameNode {
//            node.isHidden = true
//            node.isEnabled = false
//        }
//    }
//    
//    //Populate the grid & enable nodes
//    for counter in 1...num {
//        let pos = getRandGridPosition(i: UInt32(counter))
//        let node = self.view.viewWithTag(pos) as? gameNode
//        node?.isEnabled = true
//        node?.isHidden = false
//        node?.setTitle(String(describing: type(of: node)), for: .normal)
//        print(node?.currentTitle!)
//    }
//}
//
//func getRandGridPosition(i: UInt32) -> Int {
//    let pos = Int(arc4random_uniform(i) + 1)
//    return pos
//}
//
//override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Dispose of any resources that can be recreated.
//}
//
//override var prefersStatusBarHidden: Bool {
//    return true
//}
