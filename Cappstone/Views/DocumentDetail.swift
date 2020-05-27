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
    var bertModel: BERT
    
    init(document: Document, bertModel: BERT) {
        
        self.document = document
        self.bertModel = bertModel
        
        title = document.title!
        text = document.text!
        id = document.id!
        
    }
    
    var body: some View {
        ScrollView {
        
            VStack {
                
                
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
                .padding(.bottom, 30)
                
                
                    
                NavigationLink(destination: AnalyzeView(documentText: self.text, bertModel: self.bertModel)) {
                    Text("Analyze Document")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .foregroundColor(.white)
                }
                .offset(y: -25)
                    
                    
                
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
}

struct DocumentDetail_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetail(document: Document(), bertModel: BERT())
    }
}
