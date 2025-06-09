//
//  TrainingImages.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 5/31/24.
//

import Foundation
import Fluent
import Vapor

final class TrainingImages: Model, Content, @unchecked Sendable {
    static let schema = "image"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "image_path")
    var imagePath: String
    
    init() { }

    init(id: UUID? = nil, imagePath: String) {
        self.id = id
        self.imagePath = imagePath
    }
}
struct ImageUploadData: Content {
    var file: File
}
