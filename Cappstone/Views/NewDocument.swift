//
//  NewDocument.swift
//  Cappstone
//
//  Created by Quan Do on 4/14/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import SwiftUI
import Foundation

struct NewDocument: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var image: UIImage?
    
    @State private var textInput: String = ""
    @State private var title: String = ""
    @State private var colorTheme: Color = .blue
    
    @Environment (\.managedObjectContext) var managedObjectContext
    @FetchRequest (fetchRequest: Document.getAllDocuments()) var documents: FetchedResults<Document>
    
    @Environment(\.presentationMode) var presentation

    
    var body: some View {
        
        
        VStack {
            
            HStack {
                Text("New Document")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .offset(y: -10)
            
            
            Divider()
            
            
            TextField("Paste text here", text: $textInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .top])
            
            
            
            Button(action: {
                let document = Document(context: self.managedObjectContext)
                document.title = self.title == "" ? "Untitled Document" : self.title
                document.text = self.textInput
                document.id = UUID()
                print(document.id!)
                document.isFavorited = false
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
                
                self.presentation.wrappedValue.dismiss()
                
            }) {
                Text("Create Document")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(colorTheme)
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.white)
            }
            
            
            Text("- or -")
            
            
            Button(action: {
                self.showSheet = true
            }) {
                Text("Upload Photo")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(colorTheme)
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.white)
            }
                
            .actionSheet(isPresented: $showSheet) {
                ActionSheet(title: Text("Upload Photo"),
                            buttons: [
                                .default(Text("Photo Library")) {
                                    self.showImagePicker = true
                                    self.sourceType = .photoLibrary
                                },
                                .default(Text("Camera")) {
                                    self.showImagePicker = true
                                    self.sourceType = .camera
                                },
                                .cancel()
                ])
            }
            
            
            
        }.sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }.edgesIgnoringSafeArea(.top)
        
    
    }
}

struct NewDocument_Previews: PreviewProvider {
    static var previews: some View {
        NewDocument()
    }
}
