//
//  Mood.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  Gymm-Final-Api
//
//  Created by Daniel Pinilla on 2/1/25.
//

import Foundation
import Fluent
import Vapor
import Socket

struct Mood: Identifiable, Codable{
    let id: UUID?
    var Name: String
    var emoji: String
    var color: String
}


final class CouplesUser: Model, Content, @unchecked Sendable{
    static let schema = "couplesUser"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "firstName")
    var firstName: String?
    
    @Field(key: "email")
    var email: String?
    
    @Field(key: "password")
    var password: String?
    
    @Field(key: "points")
    var points: Int?

    
    @Field(key: "mood")
    var mood: Mood?
    
    @Field(key: "partnerID")
    var partnerID: Int?
    
    @Field(key: "pairingCode")
    var pairingCode: Int?
    
    
    init() { }
    
//    init(id: UUID? = nil, firstName: String, email: String, password: String, points: Int, birthday: Date ) {
//        self.id = id
//        self.firstName = firstName
//        self.email = email
//        self.password = password
//        self.points = points
//        self.birthDay = birthday
//    }
    
    
    init(id: UUID? = nil, firstName: String, email: String, password: String, points: Int, Birthday: Date, mood: Mood ) {
        self.id = id
        self.firstName = firstName
        self.email = email
        self.password = password
        self.points = points
        self.mood = mood
        
    }
    init(id: UUID? = nil, firstName: String, email: String, password: String, points: Int,    pairingCode: Int,partnerID:Int, mood: Mood ) {
        self.id = id
        self.firstName = firstName
        self.email = email
        self.password = password
        self.points = points
        self.partnerID = partnerID
        self.pairingCode = pairingCode
        self.mood = mood
    }
    
    static func generateUniqueNumber(req: Request) -> EventLoopFuture<Int> {
            let newNumber = Int.random(in: 100000...999999) // Generate random 6-digit number
            
        return CouplesUser.query(on: req.db)
            .filter(\.$pairingCode == newNumber)
                .first()
                .flatMap { existingUser in
                    if existingUser == nil {
                        return req.eventLoop.makeSucceededFuture(newNumber)  // Unique number found
                    } else {
                        return generateUniqueNumber(req: req)  // Try again until unique
                    }
                }
        }
        
   
    
}


