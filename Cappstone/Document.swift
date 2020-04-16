//
//  Document.swift
//  Cappstone
//
//  Created by Quan Do on 4/15/20.
//  Copyright © 2020 Quan Do. All rights reserved.
//

import Foundation
import CoreData

public class Document: NSManagedObject, Identifiable {
    
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorited: Bool
    
}

extension Document {
    static func getAllDocuments() -> NSFetchRequest<Document> {
        let request:NSFetchRequest<Document> = Document.fetchRequest() as! NSFetchRequest<Document>
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
