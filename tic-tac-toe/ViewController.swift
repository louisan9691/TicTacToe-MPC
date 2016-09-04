//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Louis An on 3/09/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {

    var currentPlayer: String!

    @IBOutlet var fields: [Tic_tac_toeImageView]!
    
    var appDelegate: AppDelegate!
    
    @IBAction func connectWithPlayer(sender: AnyObject) {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            
            self.presentViewController(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    func peerChangedStateWithNotification(notification:NSNotification){
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.objectForKey("state") as! Int
        if state != MCSessionState.Connecting.rawValue{
            self.navigationItem.title = "Connected"
        }
    }
    
    
    
    func handleReceivedDataWithNotification(notification: NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let receivedData: NSData = userInfo["data"] as! NSData
        
        let message = try! NSJSONSerialization.JSONObjectWithData(receivedData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        let senderPeerID: MCPeerID = userInfo["peerID"] as! MCPeerID
        let senderDisplayName = senderPeerID.displayName
        
        if message.objectForKey("string")?.isEqualToString("New Game") == true {
            
            let alert = UIAlertController(title: "Tic-Tac-Toe", message: "\(senderDisplayName) has started a new game", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.resetField()
        }else{
            
            let field:Int? = message.objectForKey("field")?.integerValue
            let player:String? = message.objectForKey("player") as? String
            
            if field != nil && player != nil {
                fields[field!].player = player
                fields[field!].setPerson(player!)
                
                if player ==  "x" {
                    currentPlayer = "o"
                }else{
                    currentPlayer = "x"
                }
                checkResults()
            }
        }
    }
    
    
    
    
    func fieldTapped (recogniser: UITapGestureRecognizer){
        let tappedField = recogniser.view as! Tic_tac_toeImageView
        tappedField.setPerson(currentPlayer)
        
        //Dictionary stores data of player moves
        let messageDict = ["field" :tappedField.tag, "player": currentPlayer]
        
        let messageData = try! NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted)
     
        do{
            try appDelegate.mpcHandler.session.sendData(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
        }catch{
            print(error)
        }
        
        checkResults()
    }
    
    
    //fieldcounts = 9. tag from 0 to 1
    func setupField(){
        for index in 0...fields.count - 1 {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(ViewController.fieldTapped(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            fields[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //Show device name
        appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
        //Set up session
        appDelegate.mpcHandler.setupSession()
        //Advertise self
        appDelegate.mpcHandler.advertiseSelf(true)
        
        //selector "abc:"  ":" represents needed parameters
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.peerChangedStateWithNotification(_:)), name: "MPC_DidChangeStateNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.handleReceivedDataWithNotification(_:)), name: "MPC_DidReceiveDataNotification", object: nil)
        setupField()
        
        currentPlayer = "x"
    }
    
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkResults(){
        var winner = ""
        
        if fields[0].player == "x" && fields[1].player == "x" && fields[2].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[1].player == "o" && fields[2].player == "o"{
            winner = "o"
        }else if fields[3].player == "x" && fields[4].player == "x" && fields[5].player == "x"{
            winner = "x"
        }else if fields[3].player == "o" && fields[4].player == "o" && fields[5].player == "o"{
            winner = "o"
        }else if fields[6].player == "x" && fields[7].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[6].player == "o" && fields[7].player == "o" && fields[8].player == "o"{
            winner = "o"
        }else if fields[0].player == "x" && fields[3].player == "x" && fields[6].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[3].player == "o" && fields[6].player == "o"{
            winner = "o"
        }else if fields[1].player == "x" && fields[4].player == "x" && fields[7].player == "x"{
            winner = "x"
        }else if fields[1].player == "o" && fields[4].player == "o" && fields[7].player == "o"{
            winner = "o"
        }else if fields[2].player == "x" && fields[5].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[2].player == "o" && fields[5].player == "o" && fields[8].player == "o"{
            winner = "o"
        }else if fields[0].player == "x" && fields[4].player == "x" && fields[8].player == "x"{
            winner = "x"
        }else if fields[0].player == "o" && fields[4].player == "o" && fields[8].player == "o"{
            winner = "o"
        }else if fields[2].player == "x" && fields[4].player == "x" && fields[6].player == "x"{
            winner = "x"
        }else if fields[2].player == "o" && fields[4].player == "o" && fields[6].player == "o"{
            winner = "o"
        }

        
        if winner != "" {
            let alert = UIAlertController(title: "Tic-Tac-Toe", message: "The winner is \(winner)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            self.resetField()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func resetField(){
        for index in 0 ... fields.count - 1 {
            fields[index].image = nil
            fields[index].activated = false
            fields[index].player = ""
        }
        currentPlayer = "x"
    }
    
    
    @IBAction func newGame(sender: AnyObject) {
        resetField()
        let messageDict = ["string":"New Game"]
        let messageData = try! NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted)
        do {
            try appDelegate.mpcHandler.session.sendData(messageData, toPeers: appDelegate.mpcHandler.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
        }catch {
            print (error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

