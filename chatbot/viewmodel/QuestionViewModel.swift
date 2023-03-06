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
        
        func getAnswerString(for question: String, userID: UInt64, completion: @escaping (String) -> Void) {

            let encoder = JSONEncoder()
            
            var questionRequest: Data?
            
            do {
                 questionRequest = try encoder.encode(Question(body: question))
            } catch {
                print("Error Encoding")
            }
            
            service.sendRequest(urlString: K.questionPostUrl + String(userID), method: "POST", parameters: questionRequest) { data, error in
                
                guard let answerData = data else { return }
                let decoder = JSONDecoder()
                do {
                    
                    let answer = try decoder.decode(Answers.self, from: answerData).answers[0].body
                    completion(answer)
                    
                } catch {
                    print("Error Decoding")
                }
            }
        }
        
        func getQuestionsByUser(userID: UInt64, completion: @escaping ([QAPair]) -> Void) {
            service.sendRequest(urlString: K.userUrl + "/" + String(userID) + "/questions", method: "GET", parameters: nil) { data, error in
                
                guard let qaData = data else { return }
                let decoder = JSONDecoder()
                do {
                    
                    let array = try decoder.decode([QAPair].self, from: qaData)
    
                    completion(array)
                    
                } catch {
                    print("Error Decoding")
                }
            }
        }
    
    }
}
