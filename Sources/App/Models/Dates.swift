//
//  File.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/25/25.
//

import Foundation


import Foundation
import Fluent
import Vapor



final class Dates: Model, Content, @unchecked Sendable {
    static let schema = "dates"
    
    @ID(key: .id)
       var id: UUID?

       @Field(key: "email")
       var email: String

       @Field(key: "name")
       var name: String  // ✅ Name of the event (e.g., Birthday, Anniversary)

       @Field(key: "date")
       var date: Date  // ✅ Single date per row

       init() {}

       init(id: UUID? = nil, email: String, name: String, date: Date) {
           self.id = id
           self.email = email
           self.name = name
           self.date = date
       }
   }
