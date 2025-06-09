//
//  ImageModel.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 6/17/24.
//

import Foundation
import Fluent
import Vapor

final class ImageModel: Model, Content, @unchecked Sendable {
    static let schema = "images"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "filename")
    var filename: String
    
    @Field(key: "imageData")
    var imageData: Data // Store as Data
    
    init() { }
    
    init(id: UUID? = nil, filename: String, imageData: Data) {
        self.id = id
        self.filename = filename
        self.imageData = imageData
    }
}
