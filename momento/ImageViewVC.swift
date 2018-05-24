//
//  ImageViewVC.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-03.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSCore
import Lottie
import AWSS3
class ImageViewVC: UIViewController {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var crossView: UIView!
    var myData:Data?
    var myString_name:String?
    var myString_Notes:String?
    var myString_Location:String?
    var myCrop:Bool?
    var myString_ImageID:String?

    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    private var myAnimatoinView: LOTAnimationView?
    private var myAnimatoinView_cross: LOTAnimationView?
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var myViewBlur: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//           print(myCrop)
        createAnimatedView_cross()
        performScan()
        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    
                    print("Failed")
                }
                    
                else{
                    
                    DispatchQueue.main.async {
                        self.myAnimatoinView?.removeFromSuperview()
                    }
                    
                    print("Success")
                    self.createEntry()
                }
            })
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func action_Refresh(_ sender: Any) {
        
        performScan()
    }
    
    func performScan(){
        self.createAnimatedView()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        dynamoDBObjectMapper.scan(AWSDataModel.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                
                let mybook:AWSDynamoDBPaginatedOutput = paginatedOutput
                let myModel:AWSDataModel = mybook.items[Int(arc4random_uniform(UInt32(mybook.items.count)) + 0)] as! AWSDataModel
                
                self.myString_ImageID = myModel.UniqueID!
                let url = URL(string: "https://s3.amazonaws.com/reliefapp/")?.appendingPathComponent(myModel.Tittle!)
                
                
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                self.uploadImageData(with: self.myData!)
                
                DispatchQueue.main.async(execute: {
                    
                    self.myTextView.text = myModel.Note
                    
                    if(myModel.CropState)!{
                        self.myImageView.contentMode = .scaleAspectFit
                    }else{
                        self.myImageView.contentMode = .scaleAspectFill
                        }
                    
                    self.myImageView.image = UIImage(data: data!)
                    
                    
                    
                })
                
      
                
                
            }
            return ()
            
        })
        
        print("Running!")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for  _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    func createEntry() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let newsItem: AWSDataModel = AWSDataModel()
        newsItem.UniqueID = self.randomStringWithLength(len: 9) as String
        newsItem.Note = myString_Notes
        newsItem.Tittle = self.myString_name
        newsItem.Location = self.myString_Location
        newsItem.CropState = myCrop
        newsItem.UploaderID = UserDefaults.standard.string(forKey: MyUniqyeID) ?? "001"
        
        
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
            
            
            print("An item was saved.")
        })
    }
    
    
    func createAnimatedView(){
        
        if(myAnimatoinView?.isAnimationPlaying == true){
            
        }else{
            myAnimatoinView = LOTAnimationView(name: "image_icon_tadah!")
            myAnimatoinView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            myAnimatoinView!.contentMode = .scaleAspectFill
            myAnimatoinView!.frame = CGRect(x:0 ,y:0,width:100,height:100)
            myAnimatoinView!.center = view.center
            myAnimatoinView!.play()
            myAnimatoinView!.loopAnimation = true
            view.addSubview(myAnimatoinView!)
        }
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        dismiss(animated: true
  //          , completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "IDECamController") as! CameraVC

                    controller.modalTransitionStyle = .crossDissolve
                    present(controller, animated: true, completion: nil)
    }
    func createAnimatedView_cross(){
        
        if(myAnimatoinView?.isAnimationPlaying == true){
            
        }else{
            myAnimatoinView_cross = LOTAnimationView(name: "reload")
            myAnimatoinView_cross!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            myAnimatoinView_cross!.contentMode = .scaleAspectFill
            myAnimatoinView_cross!.frame = CGRect(x:0 ,y:0,width:crossView.frame.size.width*3,height:crossView.frame.size.height*3)
            myAnimatoinView_cross!.center = crossView.center
            // myAnimatoinView!.play()
            myAnimatoinView_cross!.play(fromProgress: 0.4,
                                  toProgress: 1,
                                  withCompletion: nil)
            
            myAnimatoinView_cross!.loopAnimation = true
            view.addSubview(myAnimatoinView_cross!)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            myAnimatoinView_cross?.addGestureRecognizer(tap)
            myAnimatoinView_cross?.isUserInteractionEnabled = true
            
            
        }
    }
    
    @IBAction func likeButton_action(_ sender: Any) {
        
        
       UpdateAWS_Number()
         
        
    }
    func UpdateAWS_Number(){
        let dynamoDbObjectMapper = AWSDynamoDB.default()
        let key:AWSDynamoDBAttributeValue = AWSDynamoDBAttributeValue()
        key.s = myString_ImageID
        let updatedValue: AWSDynamoDBAttributeValue = AWSDynamoDBAttributeValue()
        updatedValue.n = "1"
        let updateInput: AWSDynamoDBUpdateItemInput = AWSDynamoDBUpdateItemInput()
        updateInput.tableName = "ReleifApp"
        updateInput.key = ["UniqueID": key]
        //
        let valueUpdate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        valueUpdate.value = updatedValue
        valueUpdate.action = AWSDynamoDBAttributeAction.add
        updateInput.attributeUpdates = ["count": valueUpdate]
        updateInput.returnValues = AWSDynamoDBReturnValue.updatedNew
        dynamoDbObjectMapper.updateItem(updateInput).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if (task.error == nil) {
            }
            
            return nil
            
        })
        
    }
    
    func uploadImageData(with data: Data) {
        
        myString_name = self.randomStringWithLength(len: 4) as String
        let myFileName:String? = myString_name
        //myImageArray_names.add(myFileName)
        let expression = AWSS3TransferUtilityUploadExpression()
        let transferUtility = AWSS3TransferUtility.default()
        expression.progressBlock = progressBlock
        
        transferUtility.uploadData(
            data,
            bucket: S3BucketName,
            key:myFileName!,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    
                    
                }
                
                if let _ = task.result {
                    
                    print("Upload Starting!")
                    
                    // Do something with uploadTask.
                }
                
                return nil;
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
