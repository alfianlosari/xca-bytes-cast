//
//  ResponseParsingTask.swift
//  DynamicTableColumn
//
//  Created by Alfian Losari on 25/09/24.
//

import Foundation
import Highlighter

struct CodeBlockHighlighterParser {
    
    static let shared = CodeBlockHighlighterParser()
   
    let highlighter: Highlighter = {
        let highlighter = Highlighter()!
        highlighter.setTheme("stackoverflow-dark")
        return highlighter
    }()
    
    func parse(text: String) async -> AttributedString {
        .init(highlighter.highlight(text) ?? NSAttributedString(string: text))
    }
    
}
