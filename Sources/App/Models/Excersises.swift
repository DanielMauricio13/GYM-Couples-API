//
//  Excersises.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


import Fluent
import Vapor

final class Excersises: Model, Content, @unchecked Sendable {
    static let schema = "excersises"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "sets")
    var numSets: Int
    
    @Field(key: "reps")
    var numReps: String
    
    @Field(key: "calories")
    var caloriesBurned: Int
    
    
    init() { }
    
    init(id: UUID? = nil, name: String,numSets: Int, numReps: String,  caloriesBurned: Int) {
        self.id = id
        self.name = name
        self.numSets = numSets
        self.numReps = numReps
        self.caloriesBurned = caloriesBurned
    }
    
}



