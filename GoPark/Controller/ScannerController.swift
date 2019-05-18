//
//  ScannerController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ScannerController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgScannerFrame: UIImageView!
    @IBOutlet weak var btnTorch: UIButton!
    @IBAction func btnTorch(_ sender: Any) {
        onOffTorch = !onOffTorch
        if onOffTorch == true {
            btnTorch.setImage(UIImage(named: "flashOn"), for: .normal)
        }else{
            btnTorch.setImage(UIImage(named: "flashOff"), for: .normal)
        }
        toggleTorch(on: onOffTorch)
    }
    
    let session = AVCaptureSession()
    var onOffScan = false
    var onOffTorch = false
    var segueIdentfier = ""
    var segueConfidence = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblMessage.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ScannerController_lblMessage", comment: "")
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressToScan))
        self.view.addGestureRecognizer(longGesture)
        
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        
        session.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame

        view.bringSubview(toFront: lblMessage)
        view.bringSubview(toFront: imgScannerFrame)
        view.bringSubview(toFront: btnTorch)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        session.addOutput(output)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
        btnTorch.setImage(UIImage(named: "flashOff"), for: .normal) //reset the flash icon to off before switch to another page
        btnTorch.isHighlighted = false
    }
    
    @objc func longPressToScan(sender : UIGestureRecognizer){
        if sender.state == .ended {
            lblMessage.isHidden = false
            imgScannerFrame.image = UIImage(named: "scannerFrameWhite")
            onOffScan = false
        }
        else if sender.state == .began {
            lblMessage.isHidden = true
            imgScannerFrame.image = UIImage(named: "scannerFrameBlue")
            onOffScan = true
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if onOffScan == true {
            print("Get result")
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
            //SqueezeNet ParkingSignModel
            guard let model = try? VNCoreMLModel(for: ParkingSignModel().model) else {return}
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {return}
                guard let firstObservation = results.first else {return}
                print(firstObservation.identifier, firstObservation.confidence)
                DispatchQueue.main.async {
                    //navigaition
                    if firstObservation.confidence > 0.6 {
                        self.lblMessage.isHidden = false //reset the label to not hidden
                        self.imgScannerFrame.image = UIImage(named: "scannerFrameWhite") //reset the scanner frame to blue before the popup
                        self.onOffScan = false //reset the onOffScan to false before the popup
                        self.segueIdentfier = String(firstObservation.identifier)
                        self.segueConfidence = String(firstObservation.confidence)
                        self.performSegue(withIdentifier: "ScannerToResultSegue", sender: nil)
                    }
                }
            }
            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScannerToResultSegue"
        {
            let scannerResultController = segue.destination as? ScannerResultController
            scannerResultController?.identfier = segueIdentfier
            scannerResultController?.confidence = segueConfidence
        }
    }
    

}
