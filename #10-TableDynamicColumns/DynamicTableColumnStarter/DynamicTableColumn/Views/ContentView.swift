//
//  DynamicTable.swift
//  DynamicTableSwiftUI
//
//  Created by Alfian Losari on 25/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm = ViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch vm.viewState {
                case .idle:
                    Text("Select a JSON/CSV file from toolbar to generate table data.")
                case .parsing:
                    ProgressView("Parsing JSON/CSV...")
                case .loaded(let attributedString):
                    #if os(macOS)
                    VSplitView {
                        content(attributedText: attributedString)
                    }
                    #else
                    VStack {
                        content(attributedText: attributedString)
                    }
                    #endif
                case .error(let error):
                    Text("Failed to parse JSON/CSV: \(error.localizedDescription).")
                }
            }
            .animation(.default, value: vm.isBottomBarVisible)
            .fileImporter(
                isPresented: $vm.isPickingFile,
                allowedContentTypes: [.json, .commaSeparatedText],
                allowsMultipleSelection: false,
                onCompletion: vm.processResult)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Select JSON/CSV File") {
                        vm.isPickingFile = true
                    }
                    
                    Button(action: {
                        vm.isBottomBarVisible.toggle()
                    }) {
                        Image(systemName: "rectangle.bottomhalf.inset.filled")
                            .padding()
                    }
                }
            }
            .navigationTitle(Text("XCA ByteCast X - Table with Dynamic Columns JSON/CSV Data"))
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    func content(attributedText: AttributedString) -> some View {
        ZStack {
            VStack {
                Spacer()
                Text("TODO: Render JSON/CSV in Table").frame(alignment: .center)
                Spacer()
            }
        }.frame(maxWidth: .infinity)
        
        if vm.isBottomBarVisible {
            ZStack {
                CodeBlockView(attributedString: attributedText)
            }
            .transition(.move(edge: .bottom))
            .frame(maxHeight: 512)
        }
    }
}
