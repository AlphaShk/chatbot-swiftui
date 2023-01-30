//
//  RequestService.swift
//  chatbot
//
//  Created by Denys Shkola on 24.01.2023.
//

import Foundation

struct RequestService {
    
    func sendPostRequest(urlString: String, parameters: Data?) -> Data? {
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let requestBody = parameters else { return nil }
        
        request.httpBody = requestBody
        
        var postResponse: Data?
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
                
            guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else { return }
                
            guard let responseData = data else { return }
                
            do {
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? Data {
                    
                    postResponse = jsonResponse
                    
                } else {
                    print("url error response")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
            
        return postResponse
        
    }
}
