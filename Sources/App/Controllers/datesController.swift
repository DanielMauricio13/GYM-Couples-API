//
//  File.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/26/25.
//


import Foundation
import Fluent
import Vapor

struct datesController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let excersises = routes.grouped("dates")
        excersises.get(use: index)
        excersises.get("userDates", use: getDates)
        excersises.post(use: create)
        excersises.post("newDate", use: addDate)
        excersises.delete(":coupleID", use: delete)  // Adding the delete route
//           a
    }
   
    
//    @Sendable
//    func getUserDates(req: Request) throws -> EventLoopFuture<[Dates]> {
//        let email1 = try req.query.get(String.self, at: "email1")
//        let email2 = try req.query.get(String.self, at: "email2")
//        
//        return Dates.query(on: req.db)
//            .group(.or) { group in
//                group.filter(\.$email == email1)
//                     .filter(\.$email == email2)
//            }
//            .all()
//    }
    
    
    

    // ✅ Define a response struct that conforms to Content
    struct DatesResponse: Content {
        let dates: [Date]
    }

    @Sendable
    func getDates(req: Request) async throws -> [Dates] {
        let email1 = try req.query.get(String.self, at: "email")
        let email2 = try req.query.get(String.self, at: "email2")

        return try await Dates.query(on: req.db)
            .group(.or) { group in
                group.filter(\.$email == email1)
                     .filter(\.$email == email2)
            }
            .all()
    }



    

    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[Dates]>{
        Dates.query(on: req.db).all()
    }
    @Sendable
    func create(req: Request)  throws -> EventLoopFuture<HTTPStatus>{
        let song = try req.content.decode(Dates.self)
       
        return song.save(on: req.db).transform(to: .ok)
    }
    
    @Sendable
    func addDate(req: Request) async throws -> HTTPStatus {
        struct AddDateRequest: Content {
            let email: String
            let name: String
            let date: Date
        }

        let requestData = try req.content.decode(AddDateRequest.self)

        // ✅ Create a new row for each date event
        let newRecord = Dates(email: requestData.email, name: requestData.name, date: requestData.date)
        try await newRecord.create(on: req.db)

        return .ok
    }

    
   



    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let coupleID = req.parameters.get("coupleID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid UUID format")
        }

        return CouplesUser.find(coupleID, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .flatMap { user in
                return user.delete(on: req.db).transform(to: .noContent)
            }
    }
    
}
    
    


