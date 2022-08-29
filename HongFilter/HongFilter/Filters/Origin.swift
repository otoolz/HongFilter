//
//  Origin.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/29.
//

import SwiftUI
import CoreImage

class Origin: CIFilter {
    
    private let kernel: CIKernel
    // inputkey에 대한 것도 추가를 해줘야 필터로 쓰던가 할ㄹ듯
    
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
        self.kernel = try! CIKernel(functionName: "origin", fromMetalLibraryData: data)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
