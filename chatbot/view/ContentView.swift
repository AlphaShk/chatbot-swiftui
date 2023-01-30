//
//  ContentView.swift
//  chatbot
//
//  Created by Denys Shkola on 09.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var userVM = UserViewModel()
    @StateObject var questionVM = QuestionViewModel()
    
    @State private var textField = ""
    @State private var isRegistered = false
    
    @State var messages = [Message(text: """
                                   Ich bin ChatBot.
                                   Hier kannst du deine Frage stellen,
                                   aber zuerst sollten wir uns kennenlernen.
                                   Wie heißt du?
                                   """, isUser: false)]
    
    var body: some View {
        VStack {
            HStack {
                Text("ChatBot")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.blue)
            }
            
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    if message.isUser {
                        HStack {
                            Spacer()
                            Text(message.text)
                                .padding()
                                .foregroundColor(Color.white)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    } else {
                        HStack {
                            Text(message.text)
                                .padding()
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                    
                }
                .rotationEffect(.degrees(180))
            }
            .rotationEffect(.degrees(180))
            .background(Color.gray.opacity(0.1))
            
            
            
            HStack {
                TextField("Frage stellen", text: $textField)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        
                        if userVM.id != nil {
                            sendQuestion(question: textField)
                        } else {
                            register(name: textField)
                        }
                    }
                
                Button {
                    
                    if userVM.id != nil {
                        sendQuestion(question: textField)
                    } else {
                        register(name: textField)
                    }
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
            .padding()
        }
    }
    
    func register(name: String) {
        
        let receivedName = userVM.test(name: name)
        
        if let name = receivedName {
            
            withAnimation {
                messages.append(Message(text: name, isUser: true))
                self.textField = ""
                messages.append(Message(text: "Hi, " + name, isUser: false))
            }
            
            isRegistered.toggle()
        }
    }
    
    func sendQuestion(question: String) {
        if let id = userVM.id {
            
            withAnimation {
                messages.append(Message(text: question, isUser: true))
            }
            
            let receivedAnswer = questionVM.test(for: question, userID: id)
                
            if let answer = receivedAnswer {
                    
                withAnimation {
                    messages.append(Message(text: answer, isUser: false))
                }
                    
            }
                
        }
        self.textField = ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
