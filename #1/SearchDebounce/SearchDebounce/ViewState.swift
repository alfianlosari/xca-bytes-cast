//
//  ViewState.swift
//  ObservableXCombine
//
//  Created by Alfian Losari on 31/07/24.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case data(T)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var data: T? {
        if case .data(let t) = self {
            return t
        }
        return nil
    }
}
