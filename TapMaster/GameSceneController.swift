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
    @IBOutlet weak var themScoreLabel: UILabel!
    
//    var winConditionScore = 1000
    // potential implementation for score based win condition

    let multipeerService = MultiServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapCellsCollection.delegate = self
        tapCellsCollection.dataSource = self
        tapCellsCollection.isScrollEnabled = false

        multipeerService.delegate = self
    }
}

extension GameSceneController: TapTapCellDelegate {
    func handleCellTap(withDict dict: NSMutableDictionary) {
        // events: [], value: Int
        score += dict.value(forKey: "value") as! Int
        myScoreLabel.text = String(score)
      
        multipeerService.send(valueInt: &score)
        
//        if score >= winConditionScore {
//            // cleanup game
//        }
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

extension GameSceneController: MultiServiceManagerDelegate {
  func connectedDevicesChanged(manager: MultiServiceManager, connectedDevices: [String]) {
    OperationQueue.main.addOperation {
      // self.connectionsLabel.text = "Connections: \(connectedDevices.count)"
    }
  }
  
    func dictionarySent(manager: MultiServiceManager, dictionary: NSMutableDictionary) {
        // receiving
        print("received \(dictionary) in dictionarySent function (MSMDelegate)")
    }
}
