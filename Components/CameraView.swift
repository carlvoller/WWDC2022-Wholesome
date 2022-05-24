import SwiftUI
import UIKit
import AVFoundation
import Vision

struct CameraView: UIViewRepresentable {
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var cameraView: UIView
        var cameraLayer: AVCaptureVideoPreviewLayer! = nil
        var personCount: Binding<Int>
        var requests = [VNRequest]()
        var captureSession = AVCaptureSession()
        let videoDataOutput = AVCaptureVideoDataOutput()
        let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        
        
        init(cameraView: UIView, personCount: Binding<Int>) {
            self.cameraView = cameraView
            self.personCount = personCount
        }
        
        func setup() {
            setupAVCapture()
            setupVision()
            
            captureSession.startRunning()
        }
        
        @discardableResult
        func setupVision() -> NSError? {
            // Setup Vision parts
            let error: NSError! = nil
            
            guard let modelURL = Bundle.main.url(forResource: "YOLOv3TinyInt8LUT", withExtension: "mlmodel") else {
                return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
            }
            do {
                let compiledUrl = try MLModel.compileModel(at: modelURL)
                let model = try MLModel(contentsOf: compiledUrl)
                
                let visionModel = try VNCoreMLModel(for: model)
                
                let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                    DispatchQueue.main.async(execute: {
                        // perform all the UI updates on the main queue
                        if let results = request.results {
                            self.checkForPersonInScene(results)
                        }
                    })
                })
                self.requests = [objectRecognition]
            } catch let error as NSError {
                print("Model loading went wrong: \(error)")
            }
            return error
        }
        
        func checkForPersonInScene(_ results: [Any]) {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            var pCount = 0
            
            for observation in results where observation is VNRecognizedObjectObservation {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                    continue
                }
                let topLabelObservation = objectObservation.labels[0]
                if topLabelObservation.identifier == "person" {
                    pCount += 1
                }
            }
            personCount.wrappedValue = pCount
            CATransaction.commit()
        }
        
        func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
            let curDeviceOrientation = UIDevice.current.orientation
            let exifOrientation: CGImagePropertyOrientation
            
            switch curDeviceOrientation {
            case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                exifOrientation = .left
            case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                exifOrientation = .upMirrored
            case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                exifOrientation = .down
            case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                exifOrientation = .up
            default:
                exifOrientation = .up
            }
            return exifOrientation
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            let exifOrientation = exifOrientationFromDeviceOrientation()
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
            do {
                try imageRequestHandler.perform(self.requests)
            } catch {
                print(error)
            }
        }
        
        func setupAVCapture() {
            var deviceInput: AVCaptureDeviceInput!
            var bufferSize: CGSize = .zero
            
            // Select a video device, make an input
            guard let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualWideCamera], mediaType: .video, position: .back).devices.first else {
                cameraView.backgroundColor = UIColor.blue
                return
            }
            
            
            
            do {
                deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            } catch {
                print("Could not create video device input: \(error)")
                return
            }
            
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .hd1920x1080
            
            // Add a video input
            guard captureSession.canAddInput(deviceInput) else {
                print("Could not add video device input to the session")
                captureSession.commitConfiguration()
                return
            }
            captureSession.addInput(deviceInput)
            if captureSession.canAddOutput(videoDataOutput) {
                captureSession.addOutput(videoDataOutput)
                // Add a video data output
                videoDataOutput.alwaysDiscardsLateVideoFrames = true
                videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
                videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            } else {
                print("Could not add video data output to the session")
                captureSession.commitConfiguration()
                return
            }
            let captureConnection = videoDataOutput.connection(with: .video)
            // Always process the frames
            captureConnection?.isEnabled = true
            do {
                try  videoDevice.lockForConfiguration()
                let dimensions = CMVideoFormatDescriptionGetDimensions(videoDevice.activeFormat.formatDescription)
                bufferSize.width = CGFloat(dimensions.width)
                bufferSize.height = CGFloat(dimensions.height)
                videoDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
            captureSession.commitConfiguration()
            cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1, y: -1))
            cameraLayer.connection?.automaticallyAdjustsVideoMirroring = false
            cameraLayer.connection?.isVideoMirrored = true
            
            let rootLayer = cameraView.layer
            cameraLayer.frame = cameraView.bounds
            rootLayer.addSublayer(cameraLayer)
        }
    }
    
    var cameraView: UIView = UIView(frame: UIScreen.main.bounds)
    @Binding var personCount: Int
    
    func makeUIView(context: Context) -> UIView {
        
        
        context.coordinator.setup()
        
        return cameraView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cameraView: cameraView, personCount: $personCount)
    }
}
