//
//  NetworkCache.swift
//  NetworkCache
//
//  Created by Alfian Losari on 05/09/24.
//

import Foundation

enum FetchPhase<V> {
    
    case fetching(Task<V, Error>)
    case cached(V)
    
}

actor NetworkCache<V: Decodable> {
    
    private let cache = Cache<FetchPhase<V>>()
    
    var decoder: JSONDecoder = JSONDecoder()
    var urlSession = URLSession.shared
    
    var expiredTimestampProvider: ((V) -> Date?)?
    
    func set(expiredTimestampProvider: ((V) -> Date?)?) {
        self.expiredTimestampProvider = expiredTimestampProvider
    }
    
    func value(from urlRequest: URLRequest) async throws -> V? {
        guard let urlString = urlRequest.url?.absoluteString else {
            throw "Invalid URL"
        }
        
        if let cached = cache[urlString] {
            switch cached {
            case .fetching(let task):
                print("Cache: loaded inflight task cache for \(urlString)")
                return try await task.value
            case .cached(let v):
                print("Cache: loaded response cache for \(urlString)")
                return v
            }
        }
        
        let task = Task<V, Error> {
            let (data, response) = try await self.urlSession.data(for: urlRequest)
            guard let resp = response as? HTTPURLResponse, (200...299).contains(resp.statusCode) else {
                throw "Invalid response status code"
            }
            let value = try self.decoder.decode(V.self, from: data)
            return value
        }
        
        print("Cache: set inflight task cache for \(urlString)")
        cache[urlString] = .fetching(task)
        do {
            print("Cache: fetching data from \(urlString)")
            let value = try await task.value
            print("Cache: set response cache for \(urlString)")
            cache.setValue(.cached(value), forKey: urlString, expiredTimestamp: expiredTimestampProvider?(value))
            return value
        } catch {
            cache[urlString] = nil
            throw error
        }
    }
    
    func invalidateCache() {
        cache.removeAllValues()
    }
}
