//
//  Article+Stubs.swift
//  MultiColumnSplitView
//
//  Created by Alfian Losari on 9/9/24.
//

import Foundation


extension Article {
    
    static func previewData(category: Category = .general) -> [Article] {
        let previewDataURL = Bundle.main.url(forResource: category.rawValue, withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
}
