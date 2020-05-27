//
//  DocumentsView.swift
//  Cappstone
//
//  Created by Quan Do on 4/15/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import SwiftUI

struct DocumentsView: View {
    
    @Environment (\.managedObjectContext) var managedObjectContext
    @FetchRequest (fetchRequest: Document.getAllDocuments()) var documents: FetchedResults<Document>
    
    @EnvironmentObject var userData: UserData
    
    var bertModel = BERT()
    
    var body: some View {
        
        NavigationView() {
            VStack {
                
                TextField("Search", text: $userData.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .modifier(ClearButton(text: $userData.searchText))
                
                
                List {
                    
                    Toggle(isOn: $userData.showFavoritesOnly) {
                        Text("Favorites Only")
                    }
                    
                
                    ForEach(self.documents) { document in
                        
                        // Show document based on isFavorited and searchText
                        if !(self.userData.showFavoritesOnly && !document.isFavorited ||
                             self.userData.searchText != "" && document.title!.range(of: self.userData.searchText, options: .caseInsensitive) == nil) {
                        
                            NavigationLink(destination: DocumentDetail(document: document, bertModel: self.bertModel)) {
                                HStack {
                                    Text(document.title!)
                                    
                                    if document.isFavorited {
                                        Spacer()
                                        
                                        Image(systemName: "star.fill")
                                            .imageScale(.medium)
                                            .foregroundColor(.yellow)
                                    }
                                    
                                }
                            }
                        
                        }
                        
                    }.onDelete { indexSet in
                        
                        let deleteItem = self.documents[indexSet.first!]
                        
                        if !deleteItem.isFavorited {
                            self.managedObjectContext.delete(deleteItem)
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                
                }
                .navigationBarTitle("Documents")
                .navigationBarItems(trailing:
                    NavigationLink(destination: NewDocument()) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.green)
                    }
                )
                
            }
        }

    }
}

struct DocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsView()
    }
}
