//
//  ContentView.swift
//  ChatGPTxd
//
//  Created by Alumno on 10/11/23.
//
import OpenAISwift
import SwiftUI

final class ViewModel: ObservableObject{
    init(){}
    
    private var client: OpenAISwift?
    
    func setup(){
        client = OpenAISwift(authToken: "a350d4953c5ab8cb0439cb178a0f645a")
    }
    
    func send(text: String,
              completion: @escaping (String)-> Void){
        client?.sendCompletion(with: text,
                               maxTokens: 10,
                               completionHandler: { result in
        switch result{
        case.success(let model):
            let output = model.choices?.first?.text ?? ""
            completion(output)
        case.failure:
            break
        }
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models, id:  \.self){ string in
                Text(string)
            }
            Spacer()
            
            HStack{
                TextField("Type Here...", text: $text)
                Button("Send"){
                    send()
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        models.append("Me:  \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: " + response)
                self.text = ""
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
