//
//  ViewModel.swift
//  DynamicTableColumn
//
//  Created by Alfian Losari on 27/09/24.
//

import Foundation
import Observation
import TabularData

enum ViewState {
    case idle
    case parsing
    case loaded(DynamicTableData, AttributedString)
    case error(Error)
}

@MainActor
@Observable class ViewModel {
    
    var viewState = ViewState.idle
    var isPickingFile: Bool = false
    var isBottomBarVisible: Bool = true
    let parser = CodeBlockHighlighterParser.shared
    
    func processResult(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            viewState = .parsing
            Task.detached(priority: .userInitiated) {
                guard let url = urls.first,
                      url.startAccessingSecurityScopedResource()
                else { throw "URL Not Accessible" }
                defer { url.stopAccessingSecurityScopedResource() }
                do {
                    let data = try Data(contentsOf: url)
                    var dataFrame: DataFrame?
                    if url.pathExtension == "json" {
                        dataFrame = try DataFrame(jsonData: data)
                    } else if url.pathExtension == "csv" {
                        dataFrame = try DataFrame(csvData: data)
                    }
                    guard let dataFrame else {
                        throw "Invalid input file. Only JSON and CSV files are supported."
                    }
                    
                    let dataFrameWrapper = DynamicTableData(dataFrame: dataFrame)

    
                    let string = String(data: data, encoding: .utf8) ?? ""
                    let limit = 15000
                    var attrText = await self.parser.parse(text: String(string.prefix(limit)))
                    if string.count > limit {
                        attrText.append(AttributedString(stringLiteral: "\n Result is truncated to 15,000 characters..."))
                    }
                    
                    Task { @MainActor in
                        self.viewState = .loaded(dataFrameWrapper, attrText)
                    }
                } catch {
                    Task { @MainActor in
                        self.viewState = .error(error)
                    }
                }
            }
            
        case .failure(let error):
            print("File import failed: \(error.localizedDescription)")
        }
    }
}

extension String: @retroactive Error {}
