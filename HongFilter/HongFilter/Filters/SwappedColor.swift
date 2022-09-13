//
//  SwappedColor.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/31.
//

import SwiftUI
import CoreImage

class SwappedRedGreen: CIFilter {
    
    private let kernel: CIKernel
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        return kernel.apply(extent: inputImage.extent,
                            roiCallback: { (index, rect) -> CGRect in
                                           return rect
                           }, arguments: [inputImage])
    }
    
    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        self.kernel = try! CIKernel(functionName: "swappedRG", fromMetalLibraryData: data)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "SwappedRedGreen",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
}

class SwappedRedBlue: CIFilter {
    
    private let kernel: CIKernel
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        return kernel.apply(extent: inputImage.extent,
                            roiCallback: { (index, rect) -> CGRect in
                                           return rect
                           }, arguments: [inputImage])
    }
    
    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        self.kernel = try! CIKernel(functionName: "swappedRB", fromMetalLibraryData: data)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "SwappedRedBlue",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
}

class SwappedGreenBlue: CIFilter {
    
    private let kernel: CIKernel
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        return kernel.apply(extent: inputImage.extent,
                            roiCallback: { (index, rect) -> CGRect in
                                           return rect
                           }, arguments: [inputImage])
    }
    
    override init() {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        self.kernel = try! CIKernel(functionName: "swappedGB", fromMetalLibraryData: data)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "SwappedGreenBlue",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage]
        ]
    }
}



