//
//  WebSocketClient.swift
//  WSClient
//
//  Created by Alfian Losari on 22/12/24.
//

import Foundation
import Network

struct WebSocketConfiguration {
    var additionalHeaders: [String: String]
    var pingInterval: TimeInterval
    var pingTryReconnectCountLimit: Int

    init(additionalHeaders: [String : String] = [:], pingInterval: TimeInterval = 20, pingTryReconnectCountLimit: Int = 3) {
        self.additionalHeaders = additionalHeaders
        self.pingInterval = pingInterval
        self.pingTryReconnectCountLimit = pingTryReconnectCountLimit
    }
}

enum ConnectionState {
    case disconnected
    case connecting
    case connected
}

@globalActor actor WebSocketActor {
    static let shared = WebSocketActor()
}

typealias WebSocketClientMessage = URLSessionWebSocketTask.Message

@WebSocketActor
class WebSocketClient: NSObject, Sendable {

    private let session: URLSession
    private let url: URL
    private let configuration: WebSocketConfiguration
    
    private var monitor: NWPathMonitor?
    private var wsTask: URLSessionWebSocketTask?
    private var pingTask: Task<Void, Never>?
    private var pingTryCount = 0
    
    var onReceive: ((Result<WebSocketClientMessage, Error>) -> Void)?
    var onConnectionStateChange: ((ConnectionState) -> Void)?
    
    private(set) var connectionState = ConnectionState.disconnected {
        didSet {
            onConnectionStateChange?(connectionState)
        }
    }
    
    nonisolated init(url: URL, configuration: WebSocketConfiguration, session: URLSession = .init(configuration: .default)) {
        self.url = url
        self.configuration = configuration
        self.session = session
    }
    
    func connect() {
        guard wsTask == nil else {
            print("WebSocket Task is already exists")
            return
        }
        
        var request = URLRequest(url: url)
        configuration.additionalHeaders.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        wsTask = session.webSocketTask(with: request)
        wsTask?.delegate = self
        wsTask?.resume()
        
        connectionState = .connecting
        receiveMessage()
        startMonitorNetworkConnectivity()
        schedulePing()
        
    }
    
    func send(_ message: WebSocketClientMessage) async throws {
        guard let task = wsTask, connectionState == .connected else {
            throw NSError(domain: "WebSocketClient", code: 1, userInfo: [NSLocalizedDescriptionKey: "WebSocket is not connected"])
        }
        try await task.send(message)
    }
    
    func disconnect() {
        disconnect(shouldRemoveNetworkMonitor: true)
    }
    
    private func disconnect(shouldRemoveNetworkMonitor: Bool) {
        self.wsTask?.cancel()
        self.wsTask = nil
        self.pingTask?.cancel()
        self.pingTask = nil
        self.connectionState = .disconnected
        if shouldRemoveNetworkMonitor {
            self.monitor?.cancel()
            self.monitor = nil
        }
    }
    
    private func reconnect() {
        self.disconnect(shouldRemoveNetworkMonitor: false)
        self.connect()
    }
    
    private func receiveMessage() {
        self.wsTask?.receive { result in
            Task { @WebSocketActor [weak self] in
                guard let self else { return }
                self.onReceive?(result)
                if self.connectionState == .connected {
                    self.receiveMessage()
                }
            }
        }
    }
    
    private func startMonitorNetworkConnectivity() {
        guard monitor == nil else { return }
        monitor = .init()
        monitor?.pathUpdateHandler = { path in
            Task { @WebSocketActor [weak self] in
                guard let self else { return }
                if path.status == .satisfied, self.wsTask == nil {
                    self.connect()
                    return
                }
                
                if path.status != .satisfied {
                    self.disconnect(shouldRemoveNetworkMonitor: false)
                }
            }
        }
        monitor?.start(queue: .main)
    }
    
    private func schedulePing() {
        pingTask?.cancel()
        pingTryCount = 0
        pingTask = Task { [weak self] in
            while true {
                try? await Task.sleep(for: .seconds(self?.configuration.pingInterval ?? 5))
                guard !Task.isCancelled, let self, let task = self.wsTask else { break }
                
                if task.state == .running, self.pingTryCount < self.configuration.pingTryReconnectCountLimit {
                    self.pingTryCount += 1
                    print("Ping: Send")
                    task.sendPing { error in
                        if let error {
                            print("Ping Failed: \(error.localizedDescription)")
                        } else {
                            print("Ping: Pong Received")
                            Task { @WebSocketActor [weak self] in
                                self?.pingTryCount = 0
                            }
                        }
                    }
                } else {
                    self.reconnect()
                    break
                }
            }
        }
    }
    
}


extension WebSocketClient: URLSessionWebSocketDelegate {
    
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        Task { @WebSocketActor [weak self] in
            self?.connectionState = .connected
        }
    }
    
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        Task { @WebSocketActor [weak self] in
            self?.connectionState = .disconnected
        }
    }
    
}
