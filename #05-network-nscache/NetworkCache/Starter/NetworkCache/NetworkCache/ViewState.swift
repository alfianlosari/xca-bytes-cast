import Foundation

enum ViewState<T> {
    
    case idle
    case loading
    case success(T)
    case error(Error)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var data: T? {
        if case .success(let t) = self {
            return t
        }
        return nil
    }
    
    var error: Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
    
}

