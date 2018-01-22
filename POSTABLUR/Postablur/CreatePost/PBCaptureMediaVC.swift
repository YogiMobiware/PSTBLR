//
//  PBCaptureMediaVC.swift
//  Postablur
//
//  Created by Yogi on 21/01/18.
//  Copyright © 2018 MobiwareInc. All rights reserved.
//


import UIKit
import AVFoundation
import Foundation

extension AVCaptureVideoOrientation {
    var uiInterfaceOrientation: UIInterfaceOrientation {
        get {
            switch self {
            case .landscapeLeft:        return .landscapeLeft
            case .landscapeRight:       return .landscapeRight
            case .portrait:             return .portrait
            case .portraitUpsideDown:   return .portraitUpsideDown
            }
        }
    }
    
    init(ui:UIInterfaceOrientation) {
        switch ui {
        case .landscapeRight:       self = .landscapeRight
        case .landscapeLeft:        self = .landscapeLeft
        case .portrait:             self = .portrait
        case .portraitUpsideDown:   self = .portraitUpsideDown
        default:                    self = .portrait
        }
    }
    
    init?(orientation:UIDeviceOrientation) {
        switch orientation {
        case .landscapeRight:       self = .landscapeLeft
        case .landscapeLeft:        self = .landscapeRight
        case .portrait:             self = .portrait
        case .portraitUpsideDown:   self = .portraitUpsideDown
        default:
            return nil
        }
    }
}

protocol PBCaptureMediaVCDelegate {
    
    func pbCaptureMediaVCDidTapDismiss(captureVC: PBCaptureMediaVC)
}

class PBCaptureMediaVC: UIViewController,AVCapturePhotoCaptureDelegate
{
    
    @IBOutlet weak var cameraOverlayView: UIView!
    @IBOutlet weak var controlsOverlayView: UIView!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
//    let stillImageOutput = AVCapturePhotoOutput()

    var captureOutput: AVCaptureOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    var permissionGranted: Bool = false
    
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var pickPhotoButton: UIButton!

    @IBOutlet weak var selectPhotoTypeButton: UIButton!
    @IBOutlet weak var selectAudioTypeButton: UIButton!
    @IBOutlet weak var selectVideoTypeButton: UIButton!

    @IBOutlet weak var slidingBarLeftConstraint: NSLayoutConstraint!

    
    
    var delegate: PBCaptureMediaVCDelegate? = nil
    
    // MARK: Inits
    init()
    {
        super.init(nibName: NibNamed.PBCaptureMediaVC.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Overrides
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        self.xButton.clipsToBounds = true
        self.xButton.layer.cornerRadius = self.xButton.frame.size.width / 2
        self.xButton.layer.borderColor = UIColor.white.cgColor
        self.xButton.layer.borderWidth = CGFloat(1)
        
        self.getCameraPermission()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if let previewLayer = self.previewLayer
        {
            previewLayer.frame = self.cameraOverlayView.layer.bounds
        }
        
        self.xButton.layer.cornerRadius = self.xButton.frame.size.width / 2
    }
    
    // MARK: Actions
    @IBAction func actionCameraCapture(_ sender: AnyObject)
    {
        saveToCamera()
    }
    
    @IBAction func actionDismiss(_ sender: UIButton)
    {
        self.dismissSelfieVC()
    }
    
    @IBAction func actionRotateCamera(_ sender: UIButton)
    {
        captureSession.beginConfiguration()
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        captureSession.removeInput(currentInput!)
        
        guard let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front): getCamera(with: .back),
            let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice) else
        {
            // TODO: Something, I have no idea right now
            return
        }
        
        captureSession.addInput(newVideoInput)
        captureSession.commitConfiguration()
    }
    
    @IBAction func actionFlashCamera(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true
        {
            ///turn on flash
        }
        else
        {
            ///turn off flash
        }
    }
    
    @IBAction func pickMediaTypeButtonTapped(_ sender : UIButton)
    {
        if sender == self.selectPhotoTypeButton
        {
            self.animateBarToButton(button: self.selectPhotoTypeButton)
        }
        else if sender == self.selectAudioTypeButton
        {
            self.animateBarToButton(button: self.selectAudioTypeButton)
        }
        else if sender == self.selectVideoTypeButton
        {
            self.animateBarToButton(button: self.selectVideoTypeButton)
        }
    }
    
    // MARK: Public Methods
    func getCameraPermission()
    {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized
        {
            self.permissionGranted = true
            
            self.cameraPermissionGranted()
        }
        else
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) -> Void in
                
                DispatchQueue.main.async{
                    
                    if granted == true
                    {
                        self.permissionGranted = true
                        
                        self.cameraPermissionGranted()
                    }
                    else
                    {
                        self.permissionGranted = false
                        PBUtility.showSimpleAlertForVC(vc: self, withTitle: "Postablur", andMessage: "Please turn on camera permission for Postablur from the Settings")
                        
                        self.captureButton.isEnabled = false
                        self.flipCameraButton.isEnabled = false
                    }
                }
            });
        }
    }
    
    func cameraPermissionGranted()
    {
        var devices:[Any] = []
        if #available(iOS 10, *)
        {
            let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                               mediaType: AVMediaType.video,
                                                                               position: AVCaptureDevice.Position.unspecified)
            
            devices = deviceDescoverySession.devices
            
        }
        else
        {
            devices = AVCaptureDevice.devices()
        }
        
        for device in devices
        {
            if ((device as AnyObject).hasMediaType(AVMediaType.video) && (device as AnyObject).position == AVCaptureDevice.Position.front)
            {
                if let currentDevice = device as? AVCaptureDevice
                {
                    self.captureDevice = currentDevice
                    self.beginSession()
                }
            }
        }
    }
    
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        if #available(iOS 10, *)
        {
            let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                               mediaType: AVMediaType.video,
                                                                               position: AVCaptureDevice.Position.unspecified)
            
            let devices = deviceDescoverySession.devices
            
            return devices.filter {$0.position == position}.first
        }
        else
        {
            let devices = AVCaptureDevice.devices(for: AVMediaType.video)
            
            return devices.filter {$0.position == position}.first
        }
    }
    
    func beginSession()
    {
        do
        {
            guard let captureDevice = self.captureDevice else
            {
                // TODO: Throw some sort of error I guess
                return
            }
            
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            if #available(iOS 10, *)
            {
                let photoOutput = AVCapturePhotoOutput()
                photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
                captureOutput = photoOutput
                
            }
            else
            {
                stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                captureOutput = stillImageOutput
            }
            
            guard let imageOutput = captureOutput else {
                print("cannot iniate capture Session")
                return
            }
            
            if captureSession.canAddOutput(imageOutput)
            {
                captureSession.addOutput(imageOutput)
            }
        }
        catch
        {
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: UIAlertControllerStyle.alert )
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        guard let previewLayer = self.previewLayer else {
            print("no preview layer")
            return
        }
        
        self.cameraOverlayView.layer.addSublayer(previewLayer)
        previewLayer.frame = self.cameraOverlayView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        captureSession.startRunning()
        
        self.view.bringSubview(toFront: self.controlsOverlayView)
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        if #available(iOS 10.0, *)
        {
            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            for device in discoverySession.devices
            {
                if device.position == position
                {
                    return device
                }
            }
            
        }
        else
        {
            // Do pre iOS 10 here
        }
        return nil
    }
    
    func saveToCamera()
    {
        guard permissionGranted == true else {
            return
        }
        
        if #available(iOS 10, *)
        {
            let settingsForMonitoring = AVCapturePhotoSettings()
            settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
            settingsForMonitoring.isHighResolutionPhotoEnabled = false
            
            if let photoOutput = self.captureOutput as? AVCapturePhotoOutput
            {
                if let photoOutputConnection = photoOutput.connection(with: AVMediaType.video)
                {
                    photoOutputConnection.videoOrientation = AVCaptureVideoOrientation(orientation : UIDevice.current.orientation)!
                }
                
                photoOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
            }
        }
        else
        {
            if let videoConnection = stillImageOutput.connection(with: AVMediaType.video)
            {
                if videoConnection.isVideoOrientationSupported == true
                {
                    let orientation = AVCaptureVideoOrientation(orientation: UIDevice.current.orientation)
                    videoConnection.videoOrientation = orientation!
                }
                
                
                stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                    
                    if Error != nil
                    {
                        return
                    }
                    
                    guard let sampleBuffer = CMSampleBuffer else {
                        return
                    }
                    
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    {
                        if var cameraImage = UIImage(data: imageData)
                        {
                            let currentInput = self.captureSession.inputs.first as? AVCaptureDeviceInput
                            
                            if currentInput?.device.position == .front
                            {
                                cameraImage = PBUtility.flipImage(image: cameraImage)
                            }
                             self.goToPreviewScene(withImage: cameraImage)
                        }
                    }
                })
            }
        }
    }
    
    func fixOrientationOfImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by:  CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by:  -CGFloat(Double.pi / 2))
        default:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let CGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: CGImage)
    }
    
    func goToPreviewScene(withImage image: UIImage)
    {
        guard let navController = self.navigationController else
        {
            return
        }
        
        
        let vc = RevealSettingsVC()
        vc.image = image
        navController.pushViewController(vc, animated: true)
    }
    
    // MARK: Private methods
    private func dismissSelfieVC()
    {
        if let delgate = self.delegate
        {
            delgate.pbCaptureMediaVCDidTapDismiss(captureVC: self)
        }
    }
    
    private func animateBarToButton(button : UIButton)
    {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.slidingBarLeftConstraint.constant = button.frame.origin.x
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: AVCapturePhotoCapture Delegate
    @available(iOS 10.0, *)
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?)
    {
        if let photoSampleBuffer = photoSampleBuffer
        {
            if  let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            {
                if var cameraImage = UIImage(data: imageData)
                {
                    
                    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
                    
                    let imgPath = URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("1.jpg"))// Change extension if you want to save as PNG
                    
                    do{
                        try UIImageJPEGRepresentation(cameraImage, 1.0)?.write(to: imgPath, options: .atomic)//Use UIImagePNGRepresentation if you want to save as PNG
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    
                    cameraImage = UIImage(contentsOfFile: imgPath.path)!
                    
//                    let currentInput = self.captureSession.inputs.first as? AVCaptureDeviceInput
//
//                    if currentInput?.device.position == .front
//                    {
//                        cameraImage = PBUtility.flipImage(image: cameraImage)
//                    }
                    self.goToPreviewScene(withImage: cameraImage)
                    
                }
            }
        }
    }

}


