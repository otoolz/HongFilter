//
//  HongFilterViewModel.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI
import CoreImage

class HongFilterViewModel: ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    @Published var allImages: [HongFilterImage] = []
    @Published var mainView: HongFilterImage!
    
    let filters = [
        Origin(),
        CIFilter.gaussianBlur(),
        CIFilter.bloom()
    ]
    
    let context = CIContext()
    
    // func load(filter: CIFilter) async { }
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
}
