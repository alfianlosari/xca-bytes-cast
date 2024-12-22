import Foundation

let openAIApiKey = "YOUR_API_KEY"

let client = WebSocketClient(
    url: URL(string: "wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-12-17")!,
    configuration: .init(
        additionalHeaders: [
            "Authorization":"Bearer \(openAIApiKey)", "OpenAI-Beta":"realtime=v1"
        ], pingInterval: 30, pingTryReconnectCountLimit: 2))

Task { @WebSocketActor in
    client.connect()
    client.onReceive = { result in
        switch result {
        case .success(let message):
            switch message {
            case .string(let text):
                print("ChatGPT Realtime WebSocket Server: received \(text)")
            default: break
            }
            
        case .failure(let error):
            print(error)
        }
    }
    
    client.onConnectionStateChange = { state in
        print("Connection state: \(state)")
    }
    
}


while true {
    print("Prompt something:", terminator: " ")
    if let input = readLine(), !input.isEmpty {
        let event: [String: Any] = [
            "type": "response.create",
            "response": [
                "modalities": ["text"],
                "instructions": "Assist the user",
                "input": [[
                    "type": "message",
                    "role": "user",
                    "content": [
                        ["type" : "input_text",
                         "text" : input]
                    ]
                ]]
            ]
        ]
        
        Task { @WebSocketActor in
           do {
               let jsonData = try JSONSerialization.data(withJSONObject: event, options: [.fragmentsAllowed])
               if let jsonString = String(data: jsonData, encoding: .utf8) {
                      print(jsonString)
                   try await client.send(.string(jsonString))
                  }
               
            } catch {
                print("Error serializing JSON: \(error)")
            }
        }
        
    } else {
        print("Failed to read input. Please try again\n\n")
    }
}

RunLoop.main.run(until: .distantFuture)


