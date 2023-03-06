//
//  UserViewModel.swift
//  chatbot
//
//  Created by Denys Shkola on 24.01.2023.
//

import Foundation

extension ContentView {
    @MainActor class UserViewModel: ObservableObject {
        
        let service = RequestService()
        
        func registerUser(name: String, completion: @escaping (User) -> Void) {
            
            let encoder = JSONEncoder()
            
            var userRequest: Data?
            
            do {
                 userRequest = try encoder.encode(User(name: name))
            } catch {
                print("Error Encoding")
            }
            
                
            service.sendRequest(urlString: K.userUrl, method: "POST", parameters: userRequest) { data, error in
                
                guard let responseData = data else { return }
                do {
                    
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: responseData)
                
                    completion(user)
                } catch {
                    print("Error Decoding")
                }
            }
            
        }
        
        func getUser(by id: UInt64, completion: @escaping (User) -> Void) {
            service.sendRequest(urlString: K.userUrl + "/" + String(id), method: "GET", parameters: nil) { data, error in
                
                guard let userData = data else { return }
                print(userData)
                do {
                    
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: userData)
                
                    completion(user)
                    
                } catch {
                    print("Error Decoding")
                }
                
            }
        }
    }
    
}
