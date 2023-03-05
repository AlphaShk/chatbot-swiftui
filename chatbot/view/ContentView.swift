//
//  ContentView.swift
//  chatbot
//
//  Created by Denys Shkola on 09.01.2023.
//

import SwiftUI

import Network
struct ContentView: View {
    
    @StateObject private var userVM = UserViewModel()
    @StateObject private var questionVM = QuestionViewModel()
    
    @State private var textField = ""
    @State private var id: Int?
    
    @State private var messages = [Message]()
    
    @State private var isTyping = false
    
    let monitor = NWPathMonitor()
    
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
                
                VStack {
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
                    
                    if isTyping {
                        HStack {
                            TypingIndicator()
                                .padding()
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
                
            }
            .rotationEffect(.degrees(180))
            .background(Color.gray.opacity(0.1))
            .onAppear() {
                if let id = UserDefaults.standard.object(forKey: K.key) as? Int {
                    self.id = id
                    sayHello(id: id)
                    showPrevious(for: id)
                } else {
                    messages.append(Message(text: "Hallo, Ich bin ChatBot. Ich wurde von den Schülern aus der Deutschen Schule Prag programmiert, um einfache Fragen zu beantworten.", isUser: false))
                    messages.append(Message(text: "Wir sollen uns kennenlernen. Wie heißt du?", isUser: false))
                }
            }
            
            
            HStack {
                TextField("Nachricht", text: $textField)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        sendMessage(text: textField)
                    }
                
                Button {
                    sendMessage(text: textField)
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .font(.system(size: 20))
                .padding(.horizontal, 10)
            }
            .padding()
        }
        
    }
    func sendMessage(text: String) {
        if id != nil {
            sendQuestion(question: text)
        } else {
            register(name: text)
        }
    }
    
    func register(name: String) {
    
        withAnimation {
            messages.append(Message(text: name, isUser: true))
        }
        self.textField = ""
        
        userVM.registerUser(name: name) { user in
            
            if let name = user.name, let id = user.id{
                DispatchQueue.main.async {
                    withAnimation {
                        messages.append(Message(text: "Hi, " + name + ".", isUser: false))
                        messages.append(Message(text: "Jetzt kannst du etwas fragen.", isUser: false))
                        messages.append(Message(text: "Ich kann zwar noch nicht etwas logisch und strukturierend antworten, aber niemand ist perfekt.", isUser: false))
                    }
                }
                
                UserDefaults.standard.set(id, forKey: K.key)
                self.id = id
            }
        }
    }
    
    func sayHello(id: Int) {
        userVM.getUser(by: id) { user in
            DispatchQueue.main.async {
                messages.insert(Message(text: "Hi, " + user.name! + ". Hier sind die Fragen, die du früher gestellt hast:", isUser: false), at: 0)
            }
            
        }
    }
    func showPrevious(for id: Int) {
        
        questionVM.getQuestionsByUser(userID: id) { array in
            DispatchQueue.main.async {
                for question in array {
                    messages.append(Message(text: question.body, isUser: true))
                    messages.append(Message(text: question.answers[0].body, isUser: false))
                }
            }
        }
        
    }
    
    func sendQuestion(question: String) {
        if let id = self.id {
            
            withAnimation {
                messages.append(Message(text: question, isUser: true))
                isTyping = true
            }
            
            questionVM.getAnswerString(for: question, userID: id) { answer in
                
                withAnimation {
                    messages.append(Message(text: answer, isUser: false))
                    isTyping = false
                }
            }
                
        }
        self.textField = ""
        
    }
    

}

struct TypingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
                .scaleEffect(isAnimating ? 1 : 0)
            
            Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
                .scaleEffect(isAnimating ? 1 : 0)
            
            Circle()
                .fill(Color.gray)
                .frame(width: 10, height: 10)
                .scaleEffect(isAnimating ? 1 : 0)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.7).repeatForever()) {
                self.isAnimating.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
