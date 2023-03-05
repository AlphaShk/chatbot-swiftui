//
//  Question.swift
//  chatbot
//
//  Created by Denys Shkola on 24.01.2023.
//

import Foundation

struct Question: Encodable {
    let body: String
}

struct QAPair: Decodable {
    let id: Int
    let body: String
    let answers: [Answer]
}
