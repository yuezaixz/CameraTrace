//
//  ViewController.swift
//  ALCameraViewController
//
//  Created by Alex Littlejohn on 2015/06/17.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for traceObject in Trace.getAllTrace() {
            print((traceObject as! Trace).jsonDict())
        }
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        
        if Point.lastPoint == nil {
            UIAlertView.init(title: "定位中", message: "还未定位成功，请稍等", delegate: nil, cancelButtonTitle: nil).show()
            return
        }
        
        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { (image) -> Void in
            if let resultImage = image {
                if let imageData = UIImageJPEGRepresentation(resultImage, 0.5){
                    let photo = Photo(image: imageData)
                    photo.save()
                }
            }
            self.imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
}

