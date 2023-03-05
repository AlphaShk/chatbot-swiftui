//
//  Constans.swift
//  chatbot
//
//  Created by Denys Shkola on 13.01.2023.
//

import Foundation

public class K {
    
    private static let rootUrl = "https://chatbot.regmik.ua"
    private static let apiVersion = "/api/v1"
    
    public static let userUrl = rootUrl + apiVersion + "/users"
    public static let questionPostUrl = rootUrl + apiVersion + "/questions/users/"

    public static let key = "userID"
}
