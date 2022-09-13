//
//  HongFilterViewModel.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Vision
import CoreML

class HongFilterViewModel: ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    @Published var allImages: [HongFilterImage] = []
    @Published var mainView: HongFilterImage!
    
    var rmBGView: HongFilterImage!
    var inputImage = UIImage()
    var outputImage = UIImage()
    
    let filters: [CIFilter] = [
        Origin(),
        SwappedRedGreen(),
        SwappedRedBlue(),
        SwappedGreenBlue(),
        CIFilter.bloom(),
        CIFilter.gaussianBlur(),
        CIFilter.sharpenLuminance(),
        CIFilter.circularWrap(),
        CIFilter.cmykHalftone(),
        CIFilter.dotScreen(),
    ]
    
    let context = CIContext()
    
    func loadFilter() {
        filters.forEach { (filter) in
            DispatchQueue.global(qos: .userInteractive).async {
                let CiImage = CIImage(data: self.imageData)
                filter.setValue(CiImage!, forKey: kCIInputImageKey)
                
                guard let newImage = filter.outputImage else { return }
                
                let cgimage = self.context.createCGImage(newImage, from: newImage.extent)
                
                let filteredData = HongFilterImage(image: UIImage(cgImage: cgimage!), filter: filter)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                    if self.mainView == nil { self.mainView = self.allImages.first }
                }
            }
        }
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
                self.spaceBackground()
            }
        }
    }
    func spaceBackground() {
        let backgroundImage = UIImage(named: "bg")!
        
        let beginImage = CIImage(cgImage: inputImage.cgImage!)
        let background = CIImage(cgImage: backgroundImage.cgImage!).cropped(to: CGRect(x: 0, y: 0, width: inputImage.size.width, height: inputImage.size.height))
        let mask = CIImage(cgImage: outputImage.cgImage!)
        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
                                        kCIInputImageKey: beginImage,
                                        kCIInputBackgroundImageKey:background,
                                        kCIInputMaskImageKey:mask])?.outputImage
        {
            let filteredImageRef = context.createCGImage(compositeImage, from: compositeImage.extent)
            self.outputImage = UIImage(cgImage: filteredImageRef!)
            rmBGView = HongFilterImage(image: self.outputImage, filter: Origin())
        }
    }
}

extension CIFilter {
    static func spaceBackground(inputImage: UIImage, maskImage: UIImage) -> CIFilter {
        let backgroundImage = UIImage(named: "bg")!
        
        let beginImage = CIImage(cgImage: inputImage.cgImage!)
        let background = CIImage(cgImage: backgroundImage.cgImage!)
        let mask = CIImage(cgImage: maskImage.cgImage!)
        
        return CIFilter(name: "CIBlendWithMask",  parameters: [
            kCIInputImageKey: beginImage,
            kCIInputBackgroundImageKey:background,
            kCIInputMaskImageKey:mask])!
        
    }
}
