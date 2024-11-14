//
//  ViewModel.swift
//  XCAWAStickerMaker
//
//  Created by Alfian Losari on 14/10/23.
//

import Foundation
import Observation
import SwiftUI
import CoreImage
import UIKit
import SwiftWebP
import PhotosUI

@Observable
@MainActor
class ViewModel {
    
    var stickers: [Sticker] = (0...30).map { i in Sticker(pos: i) }
    var isExporting = false
    var showOriginalImage = true
    var shouldPresentPhotoPicker = false
    var selectedPhotoPickerItem: PhotosPickerItem?
    var selectedSticker: Sticker?
    let imageHelper = ImageVisionHelper()
    
    var isAbleToExportAsStickers: Bool {
        let stickersCount = self.stickers.filter { $0.outputImage != nil }.count
        return stickersCount > 1
    }
    
    func deleteImage(sticker: Sticker) {
        updateSticker(sticker) { $0.state = .none }
    }
        
    func onInputImageSelected(_ image: CIImage, sticker: Sticker) {
        let task = Task.detached(priority: .userInitiated) {
            do {
                let imageData = self.generateImageData(image)
                try Task.checkCancellation()
                Task { @MainActor in
                    self.updateSticker(sticker) {
                        $0.state = .completed(imageData)
                    }
                }
            } catch let error {
                if error is CancellationError { return }
                Task { @MainActor in
                    self.updateSticker(sticker) {
                        $0.state = .failure(error)
                    }
                }
            }
        }
        
        self.updateSticker(sticker) { $0.state = .generating(task) }
    }
    
    nonisolated func generateImageData(_ image: CIImage) -> ImageData {
        let inputCIImage = image
        let inputImage = UIImage(cgImage: imageHelper.render(ciImage: inputCIImage))
        let outputImage = self.removeImageBackground(input: inputCIImage)
        let imageData = ImageData(inputCIImage: inputCIImage, inputImage: inputImage, outputImage: outputImage)
        return imageData
    }
    
    nonisolated func removeImageBackground(input: CIImage) -> UIImage? {
        guard let maskedImage = imageHelper.removeBackground(from: input, croppedToInstanceExtent: true) else {
            return nil
        }
        return UIImage(cgImage: imageHelper.render(ciImage: maskedImage))
    }
    
    func sendToWhatsApp() {
        guard isAbleToExportAsStickers else { return }
        let stickersImage = stickers.compactMap { $0.imageData?.outputImage }
        isExporting = true
        
        Task.detached(priority: .userInitiated) {
            let outputImageTrayData = stickersImage[0].scaleToFit(targetSize: .init(width: 96, height: 96))
                .scaledPNGData()
            print("Tray bytes size \(outputImageTrayData.count)")
            
            var json: [String: Any] = [:]
            json["identifier"] = "xcaID"
            json["name"] = "XCA"
            json["publisher"] = "Alfian Losari"
            json["tray_image"] = outputImageTrayData.base64EncodedString()
            
            var stickersArray: [[String: Any]] = []
            for image in stickersImage {
                var stickersDict = [String: Any]()
                let outputPngData = image.scaleToFit(targetSize: .init(width: 512, height: 512))
                    .scaledPNGData()
                print("Sticker size \(outputPngData.count)")
                
                if let imageData = WebPEncoder().encodePNG(data: outputPngData) {
                    stickersDict["image_data"] = imageData.base64EncodedString()
                    stickersDict["emojis"] = ["🤣"]
                    stickersArray.append(stickersDict)
                }
            }
            json["stickers"] = stickersArray
            
            var jsonWithAppStoreLink: [String: Any] = json
            jsonWithAppStoreLink["ios_app_store_link"] = ""
            jsonWithAppStoreLink["android_play_store_link"] = ""
            
            guard let dataToSend = try? JSONSerialization.data(withJSONObject: jsonWithAppStoreLink, options: []) else {
                Task { @MainActor in
                    self.isExporting = false
                }
                return
            }
            
            let pasteboard = UIPasteboard.general
            pasteboard.setItems([["net.whatsapp.third-party.sticker-pack": dataToSend]],
                                      options: [
                                        UIPasteboard.OptionsKey.localOnly: true,
                                        UIPasteboard.OptionsKey.expirationDate: Date(timeIntervalSinceNow: 60)
                                      ])
            
            
            Task { @MainActor in
                self.isExporting = false
                if UIApplication.shared.canOpenURL(URL(string: "whatsapp://")!) {
                    UIApplication.shared.open(URL(string: "whatsapp://stickerPack")!)
                }
            }
        }
    }
    
    func updateSticker(_ sticker: Sticker, updateHandler: (( _ sticker: inout Sticker) -> Void)? = nil) {
        var sticker = sticker
        updateHandler?(&sticker)
        self.stickers[sticker.pos] = sticker
    }
    
    func shareImage(sticker: Sticker) {
        var image: UIImage?
        if showOriginalImage {
            image = sticker.imageData?.inputImage
        } else {
            image = sticker.imageData?.outputImage
        }
        
        guard let image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = rootVC.view
                popoverController.sourceRect = CGRect(
                    x: rootVC.view.bounds.midX,
                    y: rootVC.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popoverController.permittedArrowDirections = []
            }
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func loadInputImage(fromPhotosPickerItem item: PhotosPickerItem?) {
        selectedPhotoPickerItem = nil
        guard let item, let sticker = selectedSticker else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .failure(let error):
                print("Failed to load: \(error)")
                return
                
            case .success(let _data):
                guard let data = _data else {
                    print("Failed to load image data")
                    return
                }
                
                guard var image = CIImage(data: data) else {
                    print("Failed to create image from selected photo")
                    return
                }
                
                if let orientation = image.properties["Orientation"] as? Int32, orientation != 1 {
                    image = image.oriented(forExifOrientation: orientation)
                }
                
                Task { @MainActor in
                    self.onInputImageSelected(image, sticker: sticker)
                }
    
            }
        }
    }
}
