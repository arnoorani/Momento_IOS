//
//  NewLoginVC.swift
//  momento
//
//  Created by Ali Noorani on 2018-05-06.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
class NewLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
print("Data")
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        // loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Data")
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
