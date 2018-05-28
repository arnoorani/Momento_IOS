//
//  NewImageVIew.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-04.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import Lottie
class NewImageVIew: UIViewController,ClassBVCDelegate {
    func sendData(_ myNewStrinf: String?) {
        myNotesString = myNewStrinf
    }
    
  public var myNotesString:String?
        
    @IBOutlet weak var myCropButton: UIButton!
    var myCropButtonInt:Int?
        
        public var myBool:Bool?
        @IBOutlet weak var myImageView: UIImageView!
        public var myData:Data?
        public var CropState:String?
        private var myAnimatoinView: LOTAnimationView?
        private var myAnimatoinView_send: LOTAnimationView?

        @IBOutlet weak var crossView: UIView!
        
        @IBOutlet weak var sendView: UIView!
        
        
        
        override func viewDidLoad() {
        super.viewDidLoad()
            
            
             CropState = "0"
    
       createAnimatedView()
        createAnimatedView_upload()
            print(myCropButtonInt)
//            if(myCropButtonInt == 1){
//                myCropButton.isHidden = true
//            }else{
//                 myCropButton.isHidden = false
//            }
            
//        
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
           // controller.myCameraPosCamVC = myCameraPos
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
       
        
        if segue.destination is NotesVC
        {
            
            let vc = segue.destination as? NotesVC
            vc?.delegate = self
            vc?.myString = myNotesString
            vc?.hideButton = myBool
            vc?.myData = myData
            vc?.myCrop = CropState
    
           
        }
    }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            dismiss(animated: true
                , completion: nil)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "IDECamController") as! CameraVC
//            controller.myCameraPosCamVC = myCameraPos
//            controller.modalTransitionStyle = .crossDissolve
//            present(controller, animated: true, completion: nil)
        }
      @objc func handleNext(_ sender: UITapGestureRecognizer){
            myBool = false
            performSegue(withIdentifier: "nextSeg", sender: nil)
        }
        func createAnimatedView(){
            
            if(myAnimatoinView?.isAnimationPlaying == true){
                
            }else{
                myAnimatoinView = LOTAnimationView(name: "reload")
                myAnimatoinView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                myAnimatoinView!.contentMode = .scaleAspectFill
                myAnimatoinView!.frame = CGRect(x:crossView.frame.origin.x ,y:crossView.frame.origin.y,width:crossView.frame.size.width*3,height:crossView.frame.size.height*3)
                myAnimatoinView!.center = crossView.center
               // myAnimatoinView!.play()
                myAnimatoinView!.play(fromProgress: 0.4,
                                    toProgress: 1,
                                    withCompletion: nil)
               
                myAnimatoinView!.loopAnimation = true
              view.addSubview(myAnimatoinView!)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                myAnimatoinView?.addGestureRecognizer(tap)
                myAnimatoinView?.isUserInteractionEnabled = true
               

            }
        }
        
        func createAnimatedView_upload(){
            
            if(myAnimatoinView_send?.isAnimationPlaying == true){
                
            }else{
                myAnimatoinView_send = LOTAnimationView(name: "share_for_graminsta_app")
                myAnimatoinView_send!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                myAnimatoinView_send!.contentMode = .scaleAspectFill
                myAnimatoinView_send!.frame = CGRect(x:0 ,y:0,width:sendView.frame.size.width*2,height:sendView.frame.size.height*2)
                myAnimatoinView_send!.center = sendView.center
                 myAnimatoinView_send!.play()
//                myAnimatoinView_send!.play(fromProgress: 0.4,
//                                      toProgress: 1,
//                                      withCompletion: nil)
                
                myAnimatoinView_send!.loopAnimation = true
                view.addSubview(myAnimatoinView_send!)
                
               let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleNext(_:)))
                myAnimatoinView_send?.addGestureRecognizer(tap)
                myAnimatoinView_send?.isUserInteractionEnabled = true
                
                
            }
        }
        
      
    @IBAction func action_Crop(_ sender: Any) {
        
        if(myImageView.contentMode == .scaleAspectFill){
              myImageView.contentMode = .scaleAspectFit
            myCropButton.setImage( #imageLiteral(resourceName: "Crop Off Icon"),for:.normal)

              CropState = "1"
              print(CropState)
        }else{
            CropState = "0"
              print(CropState)
            myImageView.contentMode = .scaleAspectFill
            myCropButton.setImage( #imageLiteral(resourceName: "Crop On Icon"),for:.normal)

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
