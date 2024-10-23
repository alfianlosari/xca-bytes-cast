//
//  ContentView.swift
//  ThreadSafeSendableClass
//
//  Created by Alfian Losari on 16/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm: ViewModel = .init()
    
    var body: some View {
        VStack(spacing: 16) {
            if let user = vm.user {
                Text(user.id)
                Text(user.username)
            } else {
                TextField("Username", text: $vm.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.username)
                    #if !os(macOS)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()
                
                SecureField("Password", text: $vm.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
                    
                Button("Login") {
                    Task { await vm.login() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isLoginButtonDisabled)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

