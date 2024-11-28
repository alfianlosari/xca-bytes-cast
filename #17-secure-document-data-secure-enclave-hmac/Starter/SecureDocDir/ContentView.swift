//
//  ContentView.swift
//  SecureDocDir
//
//  Created by Alfian Losari on 27/11/24.
//

import SwiftUI
import CryptoKit

struct ContentView: View {
    
    let dataManager = DocumentDataManager()
    
    @State var balance: String = ""
    
    var body: some View {
        VStack {
            Text("Enter Balance")
                .font(.headline)
            
            TextField("Balance", text: Binding(
                get: { balance },
                set: { newValue in
                    if newValue.allSatisfy({ $0.isNumber || $0 == "." }) {
                        balance = newValue
                    }
                }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if let numericBalance = Double(balance) {
                Text("Your balance: \(numericBalance, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Text("N/A")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            Button("Save") {
                save()
            }
            
            Button("Load") {
                load()
            }
        }
        .padding()
        .onAppear() {
            load()
        }
    }
    
    func save() {
        do {
            guard let balance = Double(balance) else { return }
            let userBalance = Balance(userId: 123456, amount: balance)
            let data = try JSONEncoder().encode(userBalance)
            try dataManager.save(data: data, filename: "balance")
            print("Saved: \(userBalance)")
        } catch {
            print(error)
        }
    }
    
    func load() {
        do {
            let decryptedData = try dataManager.load(filename: "balance")
            let balance = try JSONDecoder().decode(Balance.self, from: decryptedData)
            print("Loaded: \(balance)")
            self.balance = "\(balance.amount)"
        } catch {
            print(error)
        }
    }
    
}

#Preview {
    ContentView()
}

extension String: @retroactive Error {}
