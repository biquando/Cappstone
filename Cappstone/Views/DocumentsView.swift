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
    
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        
        NavigationView() {
            VStack {
                
                List {
                    
                    Toggle(isOn: $userData.showFavoritesOnly) {
                        Text("Favorites Only")
                    }
                
                    ForEach(self.documents) { document in
                        
                        if !self.userData.showFavoritesOnly || document.isFavorited {
                        
                            NavigationLink(destination: DocumentDetail(document: document)) {
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
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
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
