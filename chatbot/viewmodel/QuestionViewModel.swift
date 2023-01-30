//
//  Model.swift
//  chatbot
//
//  Created by Denys Shkola on 13.01.2023.
//

import Foundation

extension ContentView {
    @MainActor class QuestionViewModel: ObservableObject {
        
        
        let service = RequestService()
        
        func getAnswer(for question: String, userID: Int) -> String? {

            let encoder = JSONEncoder()
            
            var questionRequest: Data?
            
            do {
                 questionRequest = try encoder.encode(Question(body: question))
            } catch {
                print("Error Encoding")
            }
            
            guard let answerResponse = service.sendPostRequest(urlString: K.questionPostUrl + String(userID), parameters: questionRequest) else { return nil }
            
            let decoder = JSONDecoder()
            do {
                
                let answer = try decoder.decode(Answer.self, from: answerResponse).body
                
                return answer
                
            } catch {
                print("Error Decoding")
            }
            
            return nil
        }
    
        func test(for question: String, userID: Int) -> String? {
            
            return "Das kann ich leider noch nicht beantworten"
        }
    }
}
