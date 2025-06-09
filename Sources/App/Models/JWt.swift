//
//  UserPayload.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 6/8/24.
//

import Foundation
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable, Sendable {
    @SendableWrapper internal var subject: SubjectClaim
    @SendableWrapper internal var expiration: ExpirationClaim
    
    public func verify(using signer: JWTSigner) throws {
        try _expiration.wrappedValue.verifyNotExpired()
    }
}

@propertyWrapper
struct SendableWrapper<Value>: @unchecked Sendable {
    var wrappedValue: Value
}

func createJWT(for userID: String, expiresIn: TimeInterval) throws -> String {
    let expirationDate = Date().addingTimeInterval(expiresIn)
    let payload = UserPayload(
        subject: SubjectClaim(value: userID),
        expiration: ExpirationClaim(value: expirationDate)
    )

    let signer = JWTSigner.hs256(key: "secret")
    return try signer.sign(payload)
}
extension SendableWrapper: Codable where Value: Codable {}
extension SendableWrapper: Equatable where Value: Equatable {}
extension SendableWrapper: Hashable where Value: Hashable {}
