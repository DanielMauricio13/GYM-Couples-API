//
//  fullExcersisesController.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 5/14/24.
//

import Fluent
import Vapor

struct fullExcersisesController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let excersises = routes.grouped("training")
        excersises.get(use: index)
        excersises.get("userExcersises", use: getUserInfo)
        excersises.post(use: create)
        excersises.delete(":trainingID", use: delete)  // Adding the delete route
           
        
       
    }
    @Sendable
    func getUserInfo(req: Request) throws -> EventLoopFuture<fullTraining> {
        let email = try req.query.get(String.self, at: "email")
        
        return fullTraining.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[fullTraining]>{
        fullTraining.query(on: req.db).all()
    }
    @Sendable
    func create(req: Request)  throws -> EventLoopFuture<HTTPStatus>{
        let excersise = try req.content.decode(fullTraining.self)
        
        return excersise.save(on: req.db).transform(to: .ok)
    }
    @Sendable
func delete(req: Request) async throws -> HTTPStatus {
       guard let trainingID = req.parameters.get("trainingID", as: UUID.self) else {
           throw Abort(.badRequest, reason: "Invalid or missing training ID")
       }
       
       guard let training = try await fullTraining.find(trainingID, on: req.db) else {
           throw Abort(.notFound, reason: "Training record not found")
       }
       
       try await training.delete(on: req.db)
    return .ok
   }
    
}
    
    


