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



class TableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myItems:AWSDynamoDBPaginatedOutput?
    
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        
        
        ScanData()
        
        
        // UpdateAWS_Number()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func ScanData(){
        
        
        let myUniueID:String = UserDefaults.standard.string(forKey: MyUniqyeID)!
        print(myUniueID)
        
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
                     var test:Int = (self.myItems?.items.count)!
                    if(test > 0){
                       
                        self.myTableView.reloadData()
                    }else{
                         print("EMPTY")
                    }
                  
                }
               
               
                for book in paginatedOutput.items as! [AWSDataModel] {
                    // Do something with book.
print("Running!")
                    print(book.UniqueID  as Any)
                }
                
                
            }
            return ()
        })
        
        
        
       
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCustomView") as! TableViewCell
        

     
                if self.myItems?.items[0] != nil{
                    let myModelItems:AWSDataModel = (self.myItems?.items[0] as? AWSDataModel)!
                    print(myModelItems)
                    cell.myLableView.text = myModelItems.Location
                    cell.myTextView.text = myModelItems.Note
                    
                    let url = URL(string: "https://s3.amazonaws.com/reliefapp/")?.appendingPathComponent(myModelItems.Tittle!)
                    let data = try? Data(contentsOf: url!)
                    cell.myCellImageView.image = UIImage(data: data!)
                    
                }
            
            
//

        
        
        
       
      
        //cell.myLabel.text = "i'm changing the label"
        // let text = data[indexPath.row] //2.
        cell.myBlurView.alpha = 0
        cell.myLableView.alpha = 0
        cell.myTextView.alpha = 0
        
        
        return cell //4.
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
