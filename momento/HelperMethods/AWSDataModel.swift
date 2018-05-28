//
//  AWSDataModel.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-04-30.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import Foundation
import AWSDynamoDB
class AWSDataModel: AWSDynamoDBObjectModel, AWSDynamoDBModeling  {
    
    
   @objc var UniqueID: String?
   @objc var Tittle: String?
   @objc var Note: String?
   @objc var Location: String?
    @objc var UploaderID: String?
    
  

   @objc var CropState: String?


    
    
    static func dynamoDBTableName() -> String {
        return "ReleifApp"
    }
    
    static func hashKeyAttribute() -> String {
        return "UniqueID"
    }
    

}
