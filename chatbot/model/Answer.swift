//
//  Answer.swift
//  chatbot
//
//  Created by Denys Shkola on 24.01.2023.
//

import Foundation

struct Answers: Decodable {
    let answers: [Answer]
}
struct Answer: Decodable {
    let body: String
}
