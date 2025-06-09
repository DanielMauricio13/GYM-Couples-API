//
//  Food.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


import Fluent
import Vapor

final class Food: Model, Content, @unchecked Sendable {
    static let schema = "foods"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "Name")
    var Name: String
    
    @Field(key: "Protein")
    var Protein: Int
    
    @Field(key: "Calories")
    var Calories: Int
    
    @Field(key: "Sugars")
    var Sugars: Int
    
    @Field(key: "Carbohydrates")
    var Carbohydrates: Int
    
    @Field(key: "email")
    var email: String
    
  
    
    init() { }
    
    init(id: UUID? = nil, Name: String,Calories: Int, Protein: Int,  Sugars: Int,Carbohydrates: Int, email:String) {
        self.id = id
        self.Name = Name
        self.Calories = Calories
        self.Protein = Protein
        self.Sugars = Sugars
        self.Carbohydrates = Carbohydrates
        self.email = email
       
    }
    
}

