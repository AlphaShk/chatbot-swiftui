//
//  UserViewModel.swift
//  chatbot
//
//  Created by Denys Shkola on 24.01.2023.
//

import Foundation

extension ContentView {
    @MainActor class UserViewModel: ObservableObject {
        
        @Published var id: Int?
        
        let service = RequestService()
        
        func registerUser(name: String) -> String? {
            
            let encoder = JSONEncoder()
            
            var userRequest: Data?
            
            do {
                 userRequest = try encoder.encode(User(name: name))
            } catch {
                print("Error Encoding")
            }
            
            guard let userResponse = service.sendPostRequest(urlString: K.userPostUrl, parameters: userRequest) else { return nil }
            
            let decoder = JSONDecoder()
            do {
                
                let user = try decoder.decode(User.self, from: userResponse)
                if let userId = user.id {
                    id = Int(userId)
                }
                return user.name
                
            } catch {
                print("Error Decoding")
            }
            
            return nil
        }
        
        func test(name: String) -> String? {
            id = 3
            
            return name
        }
    }
    
}
