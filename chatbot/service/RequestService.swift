//
//  RequestService.swift
//  chatbot
//
//  Created by Denys Shkola on 24.01.2023.
//

import Foundation

struct RequestService {
    
    func sendRequest(urlString: String, method: String, parameters: Data?, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let requestBody = parameters {
            request.httpBody = requestBody
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let postData = data else {
                completion(nil, nil)
                return
            }
            
            completion(postData, nil)
        }
        dataTask.resume()
    }
    
}
