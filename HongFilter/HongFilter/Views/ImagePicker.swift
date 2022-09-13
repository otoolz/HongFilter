//
//  ImagePicker.swift
//  HongFilter
//
//  Created by KiWoong Hong on 2022/08/28.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var picker: Bool
    @Binding var imageData: Data
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let picker = PHPickerViewController(configuration: PHPickerConfiguration())
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if !results.isEmpty {
                if results.first!.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    results.first!.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        
                        DispatchQueue.main.async {
                            self.parent.imageData = (image as! UIImage).pngData()!
                            self.parent.picker.toggle()
                        }
                    }
                }
            } else {
                self.parent.picker.toggle()
            }
        }
    }
}
