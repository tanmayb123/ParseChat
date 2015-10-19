//
//  ViewController.swift
//  ParseChat
//
//  Created by Tanmay Bakshi on 2015-10-10.
//  Copyright © 2015 Tanmay Bakshi. All rights reserved.
//

import UIKit
import Parse

var currentSessionUN = ""
var currentSessionPW = ""

class ChatView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var message: UITextField!
    @IBOutlet var chatWith: UITextField!
    
    var chattingWith = false
    
    var updateTimer = NSTimer()
    let updateDelay = 1.0
    
    var currentData: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(updateDelay, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func update() {
        var query = PFQuery(className: "Chat")
        query.limit = 1000
        var objects = try! query.findObjects()
        currentData = []
        for i in objects {
            var finalDictionary: [String: String] = [:]
            finalDictionary["username"] = i.objectForKey("username")! as! String
            finalDictionary["text"] = i.objectForKey("text")! as! String
            if chattingWith {
                if i.objectForKey("username")! as! String == chatWith.text! && i.objectForKey("to")! as! String == currentSessionUN || i.objectForKey("username")! as! String == currentSessionUN && i.objectForKey("to")! as! String == chatWith.text! {
                    currentData.append(finalDictionary)
                }
            } else {
                if i.objectForKey("to")! as! String == "" {
                    currentData.append(finalDictionary)
                }
            }
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("customChatCell") as! chatCell
        cell.chatText.text = currentData[indexPath.row]["text"]!
        cell.chatUser.text = currentData[indexPath.row]["username"]!
        return cell
    }

    @IBAction func send() {
        var obj = PFObject(className: "Chat")
        obj.setObject(currentSessionUN, forKey: "username")
        obj.setObject(message.text!, forKey: "text")
        obj.setObject(chattingWith ? chatWith.text! : "", forKey: "to")
        try! obj.save()
        message.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func initiatePrivateChat() {
        chattingWith = !chattingWith
        chatWith.text = chattingWith ? chatWith.text! : ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

