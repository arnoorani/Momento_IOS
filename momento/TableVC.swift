//
//  TableVC.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-07.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSCore
import AWSS3
import Lottie


class TableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myItems:AWSDynamoDBPaginatedOutput?
    
       private var myAnimatoinView: LOTAnimationView?
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        
     let myUniueID:String = UserDefaults.standard.string(forKey: MyUniqyeID) ?? "-"
        createAnimatedView()
        queryData(with: myUniueID)
       
        
        
        // UpdateAWS_Number()
        
        
        
        // Do any additional setup after loading the view.
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
            self.myTableView.addSubview(myAnimatoinView!)
        }
        
        
    }
    func queryData(with myUniueID: String) {
        // 1) Configure the query
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "UploaderID-UploadDate-index"
        queryExpression.scanIndexForward = false
        queryExpression.keyConditionExpression = "#UploaderID = :UploaderID AND #UploadDate >= :UploadDate"
        //        queryExpression.expressionAttributeValues = [":val" : "10156328806913134", ":val1":  "0000-0-00 00:00:0"]
        queryExpression.expressionAttributeNames = [
            "#UploaderID": "UploaderID",
            "#UploadDate": "UploadDate"
        ]
        queryExpression.expressionAttributeValues = [
            ":UploaderID": myUniueID,
            ":UploadDate": "0"
        ]
        
        
        
        
        
        // 2) Make the query
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.query(AWSDataModel.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                self.myItems = output
                DispatchQueue.main.async {
                    let test:Int = (self.myItems?.items.count)!
                    if(test > 0){
                        
                        self.myTableView.reloadData()
                    }else{
                        print("EMPTY")
                    }
                   self.myAnimatoinView?.removeFromSuperview()
                }
//                for news in output!.items {
//                    let newsItem = news as? AWSDataModel
//                    print("\(newsItem!.Tittle!)")
//                }
            }
        }
    }
    func ScanData(with myUniueID: String){
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        scanExpression.filterExpression = "UploaderID = :val"
        scanExpression.expressionAttributeValues = [":val": myUniueID]
        
        print(UserDefaults.standard.string(forKey: MyUniqyeID) ?? "001")
        
        
        
        
        
        dynamoDBObjectMapper.scan(AWSDataModel.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
              

                self.myItems = paginatedOutput
               
                
                DispatchQueue.main.async {
                    let test:Int = (self.myItems?.items.count)!
                    if(test > 0){
                       
                        self.myTableView.reloadData()
                    }else{
                         print("EMPTY")
                    }
                  
                }
               
               
//                for book in paginatedOutput.items as! [AWSDataModel] {
//                    // Do something with book.
//print("Running!")
//                
//                }
                
                
            }
            return ()
        })
        
        
        
       
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.myItems?.items.count != nil{
            return self.myItems!.items.count
        
        }else{
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCustomView") as! TableViewCell
        

     
                if self.myItems?.items[indexPath.row] != nil{
                    let myModelItems:AWSDataModel = (self.myItems?.items[indexPath.row] as? AWSDataModel)!
                    print(myModelItems)
                    cell.myLableView.text = myModelItems.Location
                    cell.myTextView.text = myModelItems.Note
                    cell.myLable_Count.text = myModelItems.Vote?.stringValue
                    
                    let url = URL(string: "https://s3.amazonaws.com/reliefapp/")?.appendingPathComponent(myModelItems.Tittle!)
                    let data = try? Data(contentsOf: url!)
                   
                   
                    cell.myCellImageView.image =  self.resizeImage(image: UIImage(data: data!)!, targetSize: CGSize(width:355, height:190))
                    cell.myCellImageView.clipsToBounds = true
                    
                }
            
            
//

        
        
        
       
      
        //cell.myLabel.text = "i'm changing the label"
        // let text = data[indexPath.row] //2.
        cell.myBlurView.alpha = 0
        cell.myLableView.alpha = 0
        cell.myTextView.alpha = 0
        
        
        return cell //4.
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        if(cell.myLableView.alpha == 0){
            UIView.animate(withDuration: 0.25) {
                cell.myBlurView.alpha = 1
                cell.myLableView.alpha = 1
                cell.myTextView.alpha = 1
            }
            
            
        }else{
            
            UIView.animate(withDuration: 0.25) {
                cell.myBlurView.alpha = 0
                cell.myLableView.alpha = 0
                cell.myTextView.alpha = 0
                
                
                
            }
            
            
        }
        
        
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
