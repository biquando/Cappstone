//
//  AnalyzeView.swift
//  Cappstone
//
//  Created by Quan Do on 4/30/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import SwiftUI

struct AnalyzeView: View {
    
    var documentText: String
    
    @State var answer: String = ""
    @State var question: String = ""
    
    var bert = BERT()
    
    let offset: CGFloat = -200
    
    
    var body: some View {
        VStack {
            
            TextField("What is your question?", text: $question)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal])
                .offset(y: offset)
            
            
            HStack {
                
                Button(action: {
                    self.question = ""
                }) {
                    Text("Clear")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding([.top, .leading, .bottom])
                        .foregroundColor(.white)
                }
                .offset(y: offset)
                
            
                Button(action: {
                    
                    // All the searching is done here
                    let searchText = self.question
                    let bertAnswer = self.bert.findAnswer(for: searchText, in: self.documentText)
                    self.answer = String(bertAnswer)
                    
                }) {
                    Text("Submit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding([.top, .bottom, .trailing])
                        .foregroundColor(.white)
                }
                .offset(y: offset)
            }
            
            Text(answer)
                .offset(y: offset)
            
        }
    }
    
}

struct AnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzeView(documentText: "The quick brown fox jumps over the lazy dog.")
    }
}
