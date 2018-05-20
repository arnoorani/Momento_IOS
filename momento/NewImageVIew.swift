//
//  NewImageVIew.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-04.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit

    class NewImageVIew: UIViewController {
  public var myNotesString:String?
        public var myBool:Bool?
        @IBOutlet weak var myImageView: UIImageView!
        public var myData:Data?

        
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let newData = myData{
            
//            let myImahe = imageRotatedByDegrees(oldImage:   UIImage(data:newData)!, deg: 90)
//            myData = UIImageJPEGRepresentation(myImahe, 0.5)
            
            myImageView.image =    UIImage(data:newData)!
            
        }else{
            print("Erorr..")
        }

       //
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
        
    override func viewDidAppear(_ animated: Bool) {
     
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        @IBAction func action_Dismiss(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "IDECamController") as! CameraVC
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
                
        if segue.destination is NotesVC
        {
            let vc = segue.destination as? NotesVC
            vc?.myString = myNotesString
            vc?.hideButton = myBool
            vc?.myData = myData
        }
    }
    
        @IBAction func action_Next(_ sender: Any) {
            myBool = false
            performSegue(withIdentifier: "nextSeg", sender: nil)        }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
