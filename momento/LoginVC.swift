//
//  LoginVC.swift
//  momento
//
//  Created by Ali Noorani on 2018-05-06.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
class LoginVC: UIViewController,LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
     
        if let accessToken = AccessToken.current {
            print(accessToken.userId as Any)
            UserDefaults.standard.set(accessToken.userId , forKey: MyUniqyeID) //setObject
            dismiss(animated: true
                , completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print ("User Logged Out!")
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        
     
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)

        
       
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
