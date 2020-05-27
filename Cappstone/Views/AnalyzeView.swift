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
    
    var bertModel: BERT
    
    let offset: CGFloat = -200
    
    
    var body: some View {
        VStack {
            
            TextField("What is your question?", text: $question)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal])
                .offset(y: offset)
                .modifier(ClearButton(text: $question, yOffset: offset))
            
            
            HStack {
            
                Button(action: {
                    
                    // MARK: Search Document
                    
                    let bertAnswer = self.bertModel.findAnswer(for: self.question, in: self.documentText)
                    self.answer = String(bertAnswer)
                    
                }) {
                    Text("Submit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
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
        AnalyzeView(documentText: "The quick brown fox jumps over the lazy dog.", bertModel: BERT())
    }
}
