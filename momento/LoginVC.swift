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
import AWSDynamoDB
class LoginVC: UIViewController,LoginButtonDelegate {
    
    @IBOutlet weak var myUIview: UIView!
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
     
        if let accessToken = AccessToken.current {
            print(accessToken.userId as Any)
            UserDefaults.standard.set(accessToken.userId , forKey: MyUniqyeID) //setObject
            dismiss(animated: true
                , completion: nil)
        }
    }
    
    @IBOutlet weak var logo_imageView: UIImageView!
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print ("User Logged Out!")
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
       
//createEntry()
     
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.delegate = self
        loginButton.frame = self.myUIview.frame
        view.addSubview(loginButton)

        
       
    }
    
   
    


    func createEntry() {
        
  
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let newsItem: AWSDataModel = AWSDataModel()
        newsItem.UniqueID = "007"
        newsItem.Note = "this is a note"
        newsItem.Tittle = "This is a tittle"
        newsItem.Location =  "Location"
        newsItem.CropState = "1"
        newsItem.Vote = 0
        newsItem.UploaderID = "0003"
        
        
        //        newsItem.userId = ""
        //
        //        newsItem.articleId = "YourArticleId"
        //        newsItem.title = "YourTitlestring"
        //        newsItem.author = "YourAuthor"
        //        newsItem.creationDate = NSDate().timeIntervalSince1970 as NSNumber
        
        //Save a new item
        dynamoDbObjectMapper.save(newsItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            
            
            
        })
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
