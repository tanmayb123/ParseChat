//
//  LoginView.swift
//  ParseChat
//
//  Created by Tanmay Bakshi on 2015-10-10.
//  Copyright © 2015 Tanmay Bakshi. All rights reserved.
//

import UIKit
import Parse

class LoginView: UIViewController {
    
    @IBOutlet var un: UITextField!
    @IBOutlet var pw: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login() {
        var logins = PFQuery(className: "User")
        var objects = try! logins.findObjects()
        for i in objects {
            var cUN = i.objectForKey("username")! as! String
            var cPW = i.objectForKey("password")! as! String
            if cUN == un.text! && cPW == pw.text! {
                currentSessionUN = cUN
                currentSessionPW = cPW
                self.performSegueWithIdentifier("toChat", sender: self)
                break
            }
        }
    }
    
    @IBAction func register() {
        var logins = PFQuery(className: "User")
        var objects = try! logins.findObjects()
        for i in objects {
            var cUN = i.objectForKey("username")! as! String
            if cUN == un.text! {
                return
            }
        }
        var query = PFObject(className: "User")
        query.setValue(un.text!, forKey: "username")
        query.setValue(pw.text!, forKey: "password")
        try! query.save()
        login()
    }
    
}
