//
//  HostJoinViewController.swift
//  TapMaster
//
//  Created by Mike Hoyt on 7/14/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LobbyViewController: UIViewController {

  var appDelegate: AppDelegate!
  let playerName = UIDevice.current.name

  override func viewDidLoad() {
    super.viewDidLoad()
    
    appDelegate = UIApplication.shared.delegate as! AppDelegate
    
//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(peerChangedStateWIthNotification),
//      name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"),
//      object: nil
//    )
//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(handleReceivedDataWithNotification),
//      name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"),
//      object: nil
//    )
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func hostButtonPressed(_ sender: UIButton) {
    // if appDelegate.multipeerService.session != nil {
      // appDelegate.multipeerService.setupBrowser()
      appDelegate.multipeerService.serviceBrowser.delegate = self
      
      present(appDelegate.multipeerService.serviceBrowser, animated: true, completion: nil)
    // }
  }
  
  @IBAction func joinButtonPressed(_ sender: UIButton) {
    // if appDelegate.multipeerService.session != nil {
    // appDelegate.multipeerService.setupBrowser()
    appDelegate.multipeerService.serviceBrowser.delegate = self
    
    present(appDelegate.multipeerService.serviceBrowser, animated: true, completion: nil)
    // }
  }
}

extension LobbyViewController {
  func peerChangedStateWIthNotification(notification:NSNotification) {
    let userInfo = NSDictionary(dictionary: notification.userInfo!)
    
    let state = userInfo.object(forKey: "state") as! Int
    
    if state != MCSessionState.connecting.rawValue {
      self.navigationItem.title = "Connected"
    }
  }
  
//  func handleReceivedDataWithNotification(notification: NSNotification){
//    
//    let userInfo = notification.userInfo! as Dictionary
//    let receivedData: Data = userInfo["data"] as! Data
//    
//    do {
//      
//      let message = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//      
//      let senderPeerID: MCPeerID = userInfo["peerID"] as! MCPeerID
//      let senderDisplayName = senderPeerID.displayName
//      
//      let card = message.object(forKey: "card")
//      let name = message.object(forKey: "player")
//      
//      print(card)
//      print(name)
//      print(senderDisplayName)
//      
//    } catch let jsonReadError {
//      print("jsonReadError: \(jsonReadError.localizedDescription)")
//    }
//  }
}

extension LobbyViewController: MCBrowserViewControllerDelegate {
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    appDelegate.multipeerService.serviceBrowser.dismiss(animated: true, completion: nil)
    performSegue(withIdentifier: "gameControllerSegue", sender: nil)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    appDelegate.multipeerService.serviceBrowser.dismiss(animated: true, completion: nil)
  }
}
