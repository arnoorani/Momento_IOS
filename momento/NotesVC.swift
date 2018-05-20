//
//  NotesVC.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-03.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSCore
import Lottie
import CoreLocation
class NotesVC: UIViewController,UITextViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var myBlurView: UIView!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var button_UploadImage: UIButton!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var label_myCity: UILabel!
    
    let locationManager = CLLocationManager()
    var myString:String?
    var hideButton:Bool?
    var myData:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let newData = myData{
            
            //let myImahe = imageRotatedByDegrees(oldImage:   UIImage(data:newData)!, deg: 90)
            myData = newData
            
          //  myImageView.image =   myImahe
            
        }else{
            print("Erorr..")
        }
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if(hideButton == false){
            button_UploadImage.backgroundColor = .clear
            button_UploadImage.layer.cornerRadius = 5
            button_UploadImage.layer.borderWidth = 0.5
            button_UploadImage.layer.borderColor = UIColor.black.cgColor
        }else{
            button_UploadImage.isHidden = true
        }
        
        
        
        
        
        myTextView.layer.cornerRadius = 5
        myTextView.layer.borderColor = UIColor.gray.withAlphaComponent(1).cgColor
        myTextView.layer.borderWidth = 0.5
        myTextView.clipsToBounds = true
        myTextView.delegate = self
        
        if(myString == nil || (myString?.isEmpty)!){
            myTextView.text = "Enter you're note here.."
            myTextView.textColor = UIColor.lightGray
            button_UploadImage.setTitle("Upload just the image!", for: .normal)
        }else{
            myTextView.text = myString
            myTextView.textColor = UIColor.black
            button_UploadImage.setTitle("Looks Good..Upload!", for: .normal)
        }
        
        
        
        
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.75
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myBlurView.addSubview(blurEffectView)
        // print(myString)
        
        
        
        // Do any additional setup after loading the view.
    }
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    self.displayLocationInfo(placemark: firstLocation!)
                                                    //   completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    // completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            //completionHandler(nil)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    func displayLocationInfo(placemark: CLPlacemark) {
        if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            
            let myLocation:String? = placemark.locality!.appending(", ").appending(placemark.country!)
            label_myCity.text = myLocation
           
            //  println(placemark.locality ? placemark.locality : "")
            // println(placemark.postalCode ? placemark.postalCode : "")
            //println(placemark.administrativeArea ? placemark.administrativeArea : "")
            //println(placemark.country ? placemark.country : "")
        }
    }
    
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    //TextView Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter you're note here.."
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        
        
        
        
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Enter you're note here.."
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        characterCount.text = String(300 - newText.count)
        
        
        
        return newText.count <= 300
        
        return true
    }
    
    
    func performScan(){
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        dynamoDBObjectMapper.scan(AWSDataModel.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for book in paginatedOutput.items as! [AWSDataModel] {
                    // Do something with book.
                    
                    
                    
                    
                }
            }
            return ()
            
        })
    }
    
    
    
    
    func createEntry() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models you downloaded from Mobile Hub
        let newsItem: AWSDataModel = AWSDataModel()
        newsItem.UniqueID = "001"
  
        newsItem.Tittle = "New Tittle"
        
        
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
        
        
        
        
        
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    

    @IBAction func action_uploadMoment(_ sender: Any) {
        
          performSegue(withIdentifier: "segToImg", sender: nil)  
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is ImageViewVC
        {
            let vc = segue.destination as? ImageViewVC
            vc?.myString_Notes = myTextView.text
           vc?.myString_Location = label_myCity.text
            vc?.myData = myData
        }
    }
    
    @IBAction func action_Dismiss(_ sender: Any) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IDENavController") as! NewImageVIew
        
        if(myTextView.text != "Enter you're note here.."){
            controller.myNotesString = myTextView.text
        }
        controller.myData = myData
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
        
        //        dismiss(animated: true
        //            , completion: nil)
        
        
        
        
        
        
        
    }
    /*
     @IBAction func action_UploadButton(_ sender: Any) {
     }
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
