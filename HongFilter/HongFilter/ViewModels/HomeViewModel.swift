//
//  HomeViewModel.swift
//  FilterTest
//
//  Created by KiWoong Hong on 2022/08/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Vision
import CoreML

class HomeViewModel: ObservableObject {
    
    //ImagePicker뷰 활성/비활성
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    @Published var allImages: [FilterdImage] = []
    @Published var mainView: FilterdImage!
    
    var rmBGView: FilterdImage!
    var inputImage = UIImage()
    var outputImage = UIImage()
    
    let filters: [CIFilter] = [
     //   Origin(),
        CIFilter.sepiaTone(),
        CIFilter.comicEffect(),
        CIFilter.colorInvert(),
        CIFilter.photoEffectFade(),
        CIFilter.colorMonochrome(),
        CIFilter.photoEffectChrome(),
        CIFilter.gaussianBlur(),
        CIFilter.bloom()
    ]
    
    let context = CIContext()
    
    func loadFilter() {
        filters.forEach { (filter) in
            DispatchQueue.global(qos: .userInteractive).async {
                let CiImage = CIImage(data: self.imageData)
                filter.setValue(CiImage!, forKey: kCIInputImageKey)
                
                guard let newImage = filter.outputImage else { return }
                
                let cgimage = self.context.createCGImage(newImage, from: newImage.extent)
                
                let filteredData = FilterdImage(image: UIImage(cgImage: cgimage!), filter: filter)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                        
                    // default is first filter
                    
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
        let backgroundImage = UIImage(named: "bg")!.resized(to: inputImage.size)
        
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
            rmBGView = FilterdImage(image: self.outputImage, filter: Origin())
        }
    }
    
   /*
    func updateEffect() {
        DispatchQueue.global(qos: .userInteractive).async {
            // loading Image Into Filter
            let CiImage = CIImage(data: self.imageData)
            
            let filter = self.mainView.filter
            
            filter.setValue(CiImage!, forKey: kCIInputImageKey)
            
            // retreving Image...
            
            // reading input keys
            if filter.inputKeys.contains("inputRadius") {
                filter.setValue(self.value * 10, forKey: kCIInputRadiusKey)
            }
            if filter.inputKeys.contains("inputIntensity") {
                filter.setValue(self.value, forKey: kCIInputIntensityKey)
            }
            
            guard let newImage = filter.outputImage else { return }
            
            // creating UIImage...
            let cgimage = self.context.createCGImage(newImage, from: newImage.extent)
            
            DispatchQueue.main.async {
                //updating view
                self.mainView.image = UIImage(cgImage: cgimage!)
            }
        }
    }
    */
}

