//
//  Test.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/31.
//

import SwiftUI
import CoreImage

class Test: CIFilter {
    
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
        self.kernel = try! CIKernel(functionName: "test", fromMetalLibraryData: data)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Test",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage]
            /*
             "inputVerticalAmount": [kCIAttributeIdentity: 0,
                                     kCIAttributeClass: "NSNumber",
                                     kCIAttributeDefault: 20,
                                     kCIAttributeDisplayName: "Vertical Amount",
                                     kCIAttributeMin: 0,
                                     kCIAttributeSliderMin: 0,
                                     kCIAttributeSliderMax: 100,
                                     kCIAttributeType: kCIAttributeTypeScalar]
             */
        ]
    }
}
