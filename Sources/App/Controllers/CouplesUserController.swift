//
//  CouplesUserController.swift
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


import Fluent
import Vapor

struct CouplesUserController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let excersises = routes.grouped("couplesUser")
        excersises.get(use: index)
        excersises.get("checkEmail", use: checkEmail)
        excersises.get("userCouple", use: getUserInfo)
        excersises.post(use: create)
        excersises.post("postPartner", use:postPartner)
        excersises.get("getPartnerInfo", use: getPartnerInfo)
        excersises.post("updateMood", use: updateMood)
        excersises.delete(":coupleID", use: delete)  // Adding the delete route
//           a
    }
    @Sendable
    func checkEmail(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let email = try req.query.get(String.self, at: "email")
        
        return CouplesUser.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .map { existingUser in
                if let _ = existingUser {
                    return .ok // Email is found in the database
                } else {
                    return .notFound // Email is not found in the database
                }
            }
    }
    
    @Sendable
    func getUserInfo(req: Request) throws -> EventLoopFuture<CouplesUser> {
        let email = try req.query.get(String.self, at: "email")
        let password = try req.query.get(String.self, at: "password")
        
        return CouplesUser.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { user in
                // Direct comparison if passwords are stored as plaintext (⚠️ Not Secure)
                if user.password == password {
                    return user
                } else {
                    throw Abort(.unauthorized, reason: "Invalid credentials")
                }
            }
    }

    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[CouplesUser]>{
        CouplesUser.query(on: req.db).all()
    }
    @Sendable
    func create(req: Request)  throws -> EventLoopFuture<HTTPStatus>{
        let couplesUser = try req.content.decode(CouplesUser.self)
        
        return CouplesUser.generateUniqueNumber(req: req).flatMap { uniqueNumber in
            couplesUser.pairingCode = uniqueNumber  // Assign the unique number
                return couplesUser.save(on: req.db).transform(to: .ok)
            }
        
//        return excersise.save(on: req.db).transform(to: .ok)
    }
    
    @Sendable
    func getPartnerInfo(req: Request) throws -> EventLoopFuture<CouplesUser> {
        let pairingCode = try req.query.get(Int.self, at: "pairingCode")
        
        return CouplesUser.query(on: req.db)
            .filter(\.$pairingCode == pairingCode)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    @Sendable
    func updateMood(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let updatedUser = try req.content.decode(CouplesUser.self) // Decode incoming User object

        return CouplesUser.find(updatedUser.id, on: req.db) // Find user by ID
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.mood = updatedUser.mood // Update mood
                return user.save(on: req.db).transform(to: .ok) // Save and return status
            }
    }
    
    
    @Sendable
    func postPartner(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let updatedUser = try req.content.decode(CouplesUser.self) // Decode incoming user object
        print(updatedUser.partnerID ?? 21)
        return CouplesUser.query(on: req.db) // Step 1: Find updatedUser using UUID
            .filter(\.$email == updatedUser.email)
            .first()
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .flatMap { user in
                
                let pairingCode = updatedUser.partnerID

                // Step 2: Find partner user by pairingCode
                return CouplesUser.query(on: req.db)
                    .filter(\.$pairingCode == pairingCode) // Find the partner by pairingCode
                    .first()
                    .unwrap(or: Abort(.notFound, reason: "Partner user not found"))
                    .flatMap { partnerUser in
                        partnerUser.partnerID = user.pairingCode // Step 3: Update partner's
                        
                        user.partnerID = updatedUser.partnerID
                        return user.save(on: req.db)
                            .and(partnerUser.save(on: req.db)) // Step 4: Save both users
                            .transform(to: .ok)
                    }
            }
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
    
    


