//
//  ContentView.swift
//  XCAWAStickerMaker
//
//  Created by Alfian Losari on 14/10/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var vm = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Toggle("Show background", isOn: $vm.showOriginalImage)
            }.padding()
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: width, maximum: width), spacing: spacing)], spacing: spacing) {
                ForEach(vm.stickers) { sticker in
                    imagePickerMenu(badgeText: String(sticker.pos + 1), sticker: sticker)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: 1024)
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("XCA Apple Intelligence WA Sticker Maker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Export") {
                    vm.sendToWhatsApp()
                }
                .disabled(!vm.isAbleToExportAsStickers && vm.isExporting)
            }
        }
        .photosPicker(isPresented: $vm.shouldPresentPhotoPicker, selection: $vm.selectedPhotoPickerItem, matching: .images)
        .onChange(of: vm.selectedPhotoPickerItem) { vm.loadInputImage(fromPhotosPickerItem: $1) }
    }
    
    func imagePickerMenu(badgeText: String, sticker: Sticker) -> some View {
        Menu {
            Button("Select from Photo Library") {
                vm.selectedSticker = sticker
                vm.shouldPresentPhotoPicker = true
            }
            
            if sticker.imageData != nil {
                Button("Share Image") {
                    vm.shareImage(sticker: sticker)
                }
                
                Button("Delete", role: .destructive) {
                    vm.deleteImage(sticker: sticker)
                }
            }
            
        } label: {
            ImageContainerView(badgeText: badgeText, sticker: sticker, showOriginalImage: vm.showOriginalImage)
        }
        .disabled(sticker.isGeneratingImage)
    }
    
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
