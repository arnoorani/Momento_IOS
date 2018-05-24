//
//  CameraVC.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-03.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit
import Photos
import AWSS3
import Lottie
import FacebookCore
class CameraVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
   
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet fileprivate var capturePreviewView: UIView!
   
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    let cameraController = CameraController()
    
    var myImageArray_names : NSMutableArray = []
    private var myAnimatoinView: LOTAnimationView?
    var myNewImage:UIImageView?
    var myNewData:Data?
    var myString:String?
    var myCameraPosCamVC:Int?
    var myCropButton:Int?
 
     let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
        styleCaptureButton()
        configureCameraController()
     
        
        
        if let accessToken = AccessToken.current {
            print(accessToken.userId as Any)
        }else{
            //self.present(controller, animated: true, completion: nil)

            self.performSegue(withIdentifier: "goToLogin", sender: self)
        }
        
      
        // Do any additional setup after loading the view.
    

    }
    
   
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // self.performSegue(withIdentifier: "ShowEditView", sender: self)
        let data = UIImageJPEGRepresentation(chosenImage, 0.5)
        myCropButton = 2
        
      
        //here is the scaled image which has been changed to the size specified
     
        
        dismiss(animated: true, completion: nil)
        if let actualData = data{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "IDENavController") as! NewImageVIew
            
            controller.myData = actualData
           // controller.myCameraPos = self.myCameraPosCamVC
            controller.myCropButtonInt = myCropButton
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
          
            
        }else{
           
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
  
    
    func styleCaptureButton() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }
    
    
    
    func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
        
        
        
        
        
    }
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            myCameraPosCamVC = 1
            
        case .some(.rear):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            myCameraPosCamVC = 2
            
        case .none:
            return
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        
        
        
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                
                
                
                
                print(error ?? "Image capture error")
                return
            }
            
            let imageData = UIImagePNGRepresentation(image)
            
            self.myNewData = imageData
    
            
            //self.performSegue(withIdentifier: "mySeg", sender: self)
            
            var myImahe:UIImage?
            if(self.myCameraPosCamVC == 2){
                myImahe = self.imageRotatedByDegrees(oldImage:   UIImage(data:self.myNewData!)!, deg: -270)
            }else{
                myImahe = self.imageRotatedByDegrees(oldImage:   UIImage(data:self.myNewData!)!, deg: 90)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "IDENavController") as! NewImageVIew
           
           controller.myData = UIImageJPEGRepresentation(myImahe!, 0.5)
           // controller.myCameraPos = self.myCameraPosCamVC
            controller.myCropButtonInt = 1
            controller.modalTransitionStyle = .crossDissolve
             self.present(controller, animated: true, completion: nil)
           
            
        }
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
    
    
   
    @IBAction func action_ImagePicker(_ sender: Any) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion:nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is NewImageVIew
        {
        var myImahe:UIImage?
        if(myCameraPosCamVC == 2){
          myImahe = imageRotatedByDegrees(oldImage:   UIImage(data:self.myNewData!)!, deg: -270)
        }else{
             myImahe = imageRotatedByDegrees(oldImage:   UIImage(data:self.myNewData!)!, deg: 90)
        }
        
        
    
       
            let vc = segue.destination as? NewImageVIew
            vc?.myData = UIImageJPEGRepresentation(myImahe!, 0.5)
          //  vc?.myCameraPos = self.myCameraPosCamVC
           // vc?.myCropButtonInt = 1
            
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
