//
//  PhotoPicker.swift
//  Gourmetus
//
//  Created by Eduardo Dalencon on 25/10/23.
//

import Foundation
import SwiftUI
import PhotosUI

final class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var imageSelecion: PhotosPickerItem? = nil {
        didSet{
            setImage(from: imageSelecion)
        }
    }
    
    
    private func setImage(from selection: PhotosPickerItem?){
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.selectedImage = uiImage
                    }
                }
            }
        }
    }

}


