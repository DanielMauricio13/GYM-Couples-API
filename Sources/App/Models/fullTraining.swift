//
//  fullTraining.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 5/17/24.
//

import Foundation
import Vapor
import Fluent

final class fullTraining: Model, Content, @unchecked Sendable {
    static let schema = "training"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
   
    @Field(key: "excersises")
    var userExcersises: userExcersise
    init() { }
    
    init(id: UUID? = nil, email:String, userExcersises: userExcersise) {
        self.id = id
        self.email = email
        self.userExcersises = userExcersises
    }
    
}
struct Excersise: Codable {
    var name: String
    var reps: String
    var sets: Int
    var calories_burned: Int
}
struct workout_plans: Codable {
    var day: Int
    var muscle_group: String
    var exercises: [Excersise]
}

final class userExcersise: Codable, @unchecked Sendable{
    var workout_plan:[workout_plans]
}

