//
//  ViewModel.swift
//  SearchObservableCombine
//
//  Created by Alfian Losari on 03/08/24.
//

import Combine
import Observation
import Foundation

@MainActor
@Observable class ViewModel {
    
    let api = API()
    
    var state = ViewState<[String]>.idle
    var searchTask: Task<Void, Never>?
    
    @ObservationIgnored var searchTextSubject = CurrentValueSubject<String, Never>("")
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    init() {
        searchTextSubject
            .filter { $0.isEmpty }
            .sink { [weak self] _ in
                guard let self else { return }
                self.searchTask?.cancel()
                self.displayIdleState()
            }.store(in: &cancellables)
            
        
        searchTextSubject
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .sink { [weak self] text in
                guard let self else { return }
                self.searchTask?.cancel()
                self.searchTask = createSearchTask(text)
            }
            .store(in: &cancellables)
    }
    
    var searchText = "" {
        didSet {
            searchTextSubject.send(searchText)
        }
    }
    
    var isSearchNotFound: Bool {
        let isDataEmpty = state.data?.isEmpty ?? false
        return isDataEmpty && searchText.count > 0
    }
    
    func displayIdleState() {
        state = .data(API.stubs)
    }
    
    func createSearchTask(_ text: String) -> Task<Void, Never> {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.state = .loading
            do {
                let data = try await api.search(text: text)
                try Task.checkCancellation()
                self.state = .data(data)
            } catch {
                if error is CancellationError {
                    print("Search is cancelled")
                }
            }
        }
    }
    
}

