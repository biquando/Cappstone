//
//  NewDocument.swift
//  Cappstone
//
//  Created by Quan Do on 4/14/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import SwiftUI
import Foundation
import Vision

struct NewDocument: View {
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var isShowingScannerSheet = false
    @State private var cameraText: String = ""
    @State private var scanAttempted = false
    
    @State private var image: UIImage?
    
    @State private var textInput: String = ""
    @State private var title: String = ""
    
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
            .padding(.top, 80)
            
            
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .offset(y: -10)
                .modifier(ClearButton(text: $title, yOffset: -10))
            
            
            Divider()
            
            
            TextField("Paste text here", text: $textInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .top])
                .modifier(ClearButton(text: $textInput, yOffset: 10))
            
            
            
            Button(action: {
                
                if self.textInput == "" {
                    return
                }
                
                // MARK: Create from Text
                
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
                    .background(self.textInput == "" ? Color.gray : Color.green)
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.white)
            }
            
            
            Text("- or -")
            
            
            Button(action: {
                self.showSheet = true
            }) {
                Text(cameraText == "" && image == nil ? "Upload Photo" : "Change Photo")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
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
            
            
            
            Button(action: {
                if self.cameraText == "" && self.image == nil {
                    return
                }
                
                // MARK: Image Processing
                
                if self.image != nil {
                
                    let cgImage = self.image!.cgImage
                    let myRequestHandler = VNImageRequestHandler(cgImage: cgImage!, options: [:])
                    let textRecognitionRequest = VNRecognizeTextRequest()

                    textRecognitionRequest.recognitionLevel = .accurate
                    textRecognitionRequest.revision = VNRecognizeTextRequestRevision1
                    textRecognitionRequest.usesLanguageCorrection = true

                    do {
                        try myRequestHandler.perform([textRecognitionRequest])
                    } catch {}


                    guard let results = textRecognitionRequest.results as? [VNRecognizedTextObservation] else {
                        return
                    }

                    let maximumCandidates = 1
                    self.cameraText = ""
                    for result in results {
                        guard let candidate = result.topCandidates(maximumCandidates).first else { continue }
                        self.cameraText += candidate.string + " "
                    }
                }
                
                
                
                // MARK: Create from Image
                
                let document = Document(context: self.managedObjectContext)
                document.title = self.title == "" ? "Untitled Document" : self.title
                document.text = self.cameraText
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
                Text(cameraText == "" && image == nil ? "No photo selected" : "Submit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(cameraText == "" && image == nil ? Color.gray : Color.green)
                    .cornerRadius(10)
                    .padding()
                    .foregroundColor(.white)
            }
            .offset(y: -20)
            
            
            if scanAttempted && cameraText == "" && image == nil {
                Text("Couldn't find any text")
                    .foregroundColor(.red)
                    .offset(y: -20)
            }
            
            
            
        }.sheet(isPresented: $showImagePicker) {
            if self.sourceType == .camera {
                self.makeScannerView()
            } else {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
        }.edgesIgnoringSafeArea(.top)
        
    
    }
    
    
    private func openCamera() {
        showImagePicker = true
    }
     
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                self.cameraText = text
                self.scanAttempted = true
                self.image = nil
            }
            self.showImagePicker = false
        })
    }
    
}

struct NewDocument_Previews: PreviewProvider {
    static var previews: some View {
        NewDocument()
    }
}
