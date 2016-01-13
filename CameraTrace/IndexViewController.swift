//
//  IndexViewController.swift
//  CameraTrace
//
//  Created by 吴迪玮 on 16/1/12.
//  Copyright © 2016年 DNT. All rights reserved.
//

import UIKit
import AVFoundation

class IndexViewController: UIViewController {
    
    @IBOutlet weak var preView: UIView!
    
    var captureOutput:AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    var captureSession:AVCaptureSession = AVCaptureSession()
    var backCamera:AVCaptureDevice?
    var backFacingCameraDeviceInput:AVCaptureDeviceInput?
    var captureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackDevice()
        initCapTure()
    }
    
    func initBackDevice(){
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) && device.position == AVCaptureDevicePosition.Back {
                backCamera = device as? AVCaptureDevice
                backFacingCameraDeviceInput = try? AVCaptureDeviceInput(device: backCamera)
            }
        }
    }
    
    func initCapTure(){
        let outputSettings:[NSObject : AnyObject] = [AVVideoCodecKey:AVVideoCodecJPEG,AVVideoWidthKey:CGRectGetWidth(preView.bounds),AVVideoHeightKey:CGRectGetHeight(preView.bounds)]
        captureOutput.outputSettings = outputSettings
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let backInput = backFacingCameraDeviceInput {
            if captureSession.canAddInput(backInput){
                captureSession.addInput(backInput)
            }
            if captureSession.canAddOutput(captureOutput){
                captureSession.addOutput(captureOutput)
            }
            if captureVideoPreviewLayer == nil {
                captureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            }
            if let captureLayer = captureVideoPreviewLayer {
                captureLayer.frame = CGRectMake(-5, 0, preView.frame.size.width, preView.frame.size.height)
                captureLayer.videoGravity = AVLayerVideoGravityResizeAspect
                preView.layer.insertSublayer(captureLayer, atIndex: 0)
                captureSession.startRunning()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cameraAction(sender: UIButton) {
        
    }

}

