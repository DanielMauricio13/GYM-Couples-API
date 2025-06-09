//
//  LogMiddleware.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 6/4/24.
//

import Foundation
import Vapor
@preconcurrency import JWT
struct LogMiddleware: AsyncMiddleware{
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        print("logged in ")
       return try await next.respond(to: request)
    }
}


struct JWTMiddleware: Middleware {
    let signer: JWTSigner
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let token = request.headers.bearerAuthorization?.token else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        do {
            let payload = try request.jwt.verify(token, as: UserPayload.self)
            request.auth.login(payload)
            return next.respond(to: request)
        } catch {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
    }
}

extension Request {
    var userPayload: UserPayload? {
        return self.auth.get(UserPayload.self)
    }
}

