//
//  foodController.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


import Fluent
import Vapor

struct foodController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let food = routes.grouped("foods")
        food.get(use: index)
//        food.get("byEmail",use: filterByEmail)
        food.post(use: create)
        food.put(use: update)
        food.delete("all", use: deleteAll)

        food.delete(":foodID",use: delete)
        
    }
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[Food]>{
        Food.query(on: req.db).all()
    }
    
//    @Sendable
//    func filterByEmail(req: Request) throws -> EventLoopFuture<[Food]> {
//        guard let email = req.query[String.self, at: "email"] else {
//            throw Abort(.badRequest, reason: "'email' query parameter is required")
//        }
//
//        return Food.query(on: req.db)
//            .filter(\.$email == email)
//            .all()
//    }
    @Sendable
    func create(req: Request)  throws -> EventLoopFuture<HTTPStatus>{
        let food = try req.content.decode(Food.self)
        
        return food.save(on: req.db).transform(to: .ok)
    }
    @Sendable
    func update(req : Request) throws -> EventLoopFuture<HTTPStatus>{
        let food = try req.content.decode(Food.self)
        
        return Food.find(food.id, on: req.db).unwrap(or: Abort(.notFound))
            .flatMap{
                $0.Name = food.Name
                $0.Calories = food.Calories
                $0.Sugars = food.Sugars
                $0.Carbohydrates = food.Carbohydrates
                $0.Protein = food.Protein
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
           guard let trainingID = req.parameters.get("foodID", as: UUID.self) else {
               throw Abort(.badRequest, reason: "Invalid or missing training ID")
           }
           
           guard let food = try await Food.find(trainingID, on: req.db) else {
               throw Abort(.notFound, reason: "Training record not found")
           }
           
           try await food.delete(on: req.db)
        return .ok
       }
    @Sendable
    func deleteAll(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Food.query(on: req.db)
            .delete()
            .transform(to: .ok)
    }

    
    
    
}
