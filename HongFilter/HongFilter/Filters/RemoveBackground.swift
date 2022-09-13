//
//  RemoveBackground.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/31.
//

import SwiftUI
import CoreImage
import CoreML
import Vision

class RemoveBackground: CIFilter {
    
    private let kernel: CIKernel
    
    var request: VNCoreMLRequest?
    
    @objc dynamic var inputImage: CIImage?
    var maskImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        let removeBG = RemoveBG(inputImage: UIImage(ciImage: inputImage), outputImage: UIImage(ciImage: inputImage))
        print(removeBG.inputImage)
        let newBG = UIImage(named: "bg")!
        let beginImage = CIImage(cgImage: removeBG.inputImage.cgImage!)
        let background = CIImage(cgImage: newBG.cgImage!)
        let mask = CIImage(cgImage: removeBG.outputImage.cgImage!)
        
        return CIFilter(name: "CIBlendWithMask", parameters: [
            kCIInputImageKey: beginImage,
            kCIInputBackgroundImageKey:background,
            kCIInputMaskImageKey:mask])?.outputImage
    }
    
    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        self.kernel = try! CIKernel(functionName: "origin", fromMetalLibraryData: data)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Origin",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
   
    
}

class RemoveBG {
    
    var outputImage: UIImage
    var inputImage: UIImage
    
    init(inputImage: UIImage, outputImage: UIImage) {
        self.inputImage = inputImage
        self.outputImage = outputImage
        
        runVisionRequest()
    }
    
    func runVisionRequest() {
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else { return }
        
        let request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill
        
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(cgImage: self.inputImage.cgImage!, options: [:])
            do {
                try handler.perform([request])
            }catch {
                print(error)
            }
        }
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        
        DispatchQueue.main.async {
            
            if let observations = request.results as? [VNCoreMLFeatureValueObservation],
               let segmentationmap = observations.first?.featureValue.multiArrayValue {
                let segmentationMask = segmentationmap.image(min: 0, max: 1)
                self.outputImage = segmentationMask!.resized(to: self.inputImage.size)
                self.maskInputImage()
            }
        }
    }

    func maskInputImage(){
            
        let bgImage = UIImage(named: "bg")!

        let beginImage = CIImage(cgImage: (inputImage.cgImage!))
            let background = CIImage(cgImage: bgImage.cgImage!)
        let mask = CIImage(cgImage: (self.outputImage.cgImage!))
            
            if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
                                            kCIInputImageKey: beginImage,
                                            kCIInputBackgroundImageKey:background,
                                            kCIInputMaskImageKey:mask])?.outputImage
            {
                
                let ciContext = CIContext(options: nil)
                let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
                
                self.outputImage = UIImage(cgImage: filteredImageRef!)
            }
    }
    
}

