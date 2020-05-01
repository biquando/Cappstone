//
//  DocumentDetail.swift
//  Cappstone
//
//  Created by Quan Do on 4/15/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import SwiftUI

struct DocumentDetail: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Document.getAllDocuments()) var documents: FetchedResults<Document>
    
    
    var title: String = ""
    var text: String = ""
    var id: UUID = UUID()
    
    var document: Document
    
    init(document: Document) {
        
        self.document = document
        
        title = document.title!
        text = document.text!
        id = document.id!
        
    }
    
    var body: some View {
        VStack {
            
            NavigationLink(destination: AnalyzeView(documentText: self.text)) {
                Text("Analyze Document")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.white)
            }
            .offset(y: -25)
            
            
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                
                Spacer()
            }.offset(y: -15)
            
            
            
            HStack {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                
                Spacer()
            }
            
            Spacer()
            
            .navigationBarItems(trailing:
                Button(action: {
                    self.document.isFavorited.toggle()
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }) {
                    if self.document.isFavorited {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                }
            )
        }
        
    }
}

struct DocumentDetail_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetail(document: Document())
    }
}
