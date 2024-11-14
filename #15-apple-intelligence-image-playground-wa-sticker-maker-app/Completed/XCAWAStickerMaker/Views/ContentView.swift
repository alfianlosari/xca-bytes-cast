//
//  ContentView.swift
//  XCAWAStickerMaker
//
//  Created by Alfian Losari on 14/10/23.
//

import SwiftUI
import PhotosUI
import ImagePlayground

struct ContentView: View {
    
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State var vm = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                generateOptionSection
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
        .imagePlaygroundSheet(
            isPresented: $vm.shouldPresentImagePlayground,
            concepts: vm.imagePlaygroundConcept,
            sourceImage: vm.imagePlaygroundSourceImage,
            onCompletion: { url in
                guard let image = UIImage(contentsOfFile: url.relativePath),
                      let ciImage = CIImage(image: image),
                      let sticker = vm.selectedSticker
                else { return }
                vm.selectedSticker = nil
                vm.onInputImageSelected(ciImage, sticker: sticker)
            },
            onCancellation: {
                vm.selectedSticker = nil
            }
        )
    }
    
    @ViewBuilder
    var generateOptionSection: some View {
        if supportsImagePlayground {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading) {
                    Picker("Image Playground Concept Type Option", selection: $vm.selectedImagePlaygroundConceptType) {
                        ForEach(ImagePlaygroundConceptType.allCases) {
                            Text($0.rawValue).id($0)
                        }
                    }.pickerStyle(.segmented)
                    
                    switch vm.selectedImagePlaygroundConceptType {
                    case .extract:
                        TextField("Enter Title", text: $vm.titleText)
                            .textFieldStyle(.roundedBorder)
                        TextField("Enter Text", text: $vm.paragraphText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(4, reservesSpace: true)

                    case .text:
                        HStack {
                            TextField("Enter a word", text: $vm.textInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            
                            Button(action: vm.addWord) {
                                Text("Submit")
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        
                        if vm.words.count > 0 {
                            ScrollView(.horizontal) {
                                HStack(spacing: 16) {
                                    ForEach(vm.words, id: \.self) { word in
                                        HStack {
                                            Text(word)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .padding(.leading, 8)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                vm.removeWord(word)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        .frame(height: 40)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                    }
                                }.padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                        
                      
                        
                    }
                }
                
                Divider()
                
                VStack {
                    Text("Source Image")
                    ImagePicker {
                        ZStack {
                            if let image = vm.sourceImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .frame(width: width, height: width)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.pink, style: StrokeStyle(lineWidth: 3, dash: [8]))
                        }
                    } onSelectedImage: {
                        self.vm.sourceImage = UIImage(cgImage: vm.imageHelper.render(ciImage: $0))
                    }.id(vm.sourceImage)
                    
                    if vm.sourceImage != nil {
                        Button("Remove") {
                            vm.sourceImage = nil
                        }.tint(.red)
                    }
                    
                }
            }
        } else {
            Text("Apple Intelligence Image Playground is not supported on this device")
                .font(.caption)
        }
    }
    
    func imagePickerMenu(badgeText: String, sticker: Sticker) -> some View {
        Menu {
            Button("Generate using Apple Intelligence") {
                vm.selectedSticker = sticker
                vm.shouldPresentImagePlayground = true
            }.disabled(!supportsImagePlayground)
            
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
