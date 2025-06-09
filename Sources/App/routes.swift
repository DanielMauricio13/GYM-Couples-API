import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("login") { req -> EventLoopFuture<String> in
      //  let user = try req.content.decode(User.self)
        let email = try req.query.get(String.self, at: "email")
        let password = try req.query.get(String.self, at: "password")
        return User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { fetchedUser in
                if try Bcrypt.verify(password, created: fetchedUser.password!) {
                    let expirationDate = Date().addingTimeInterval(259200) // 3600 seconds = 1 hour
                    let payload = UserPayload(subject: .init(value: fetchedUser.id!.uuidString), expiration: .init(value: expirationDate))
                    return try req.jwt.sign(payload)
                    
                } else {
                    throw Abort(.unauthorized)
                }
            }
    }
   
    
    let signer =  app.jwt.signers.get()!
    let protected = app.grouped(JWTMiddleware(signer: signer))
        
    protected.get("profile") { req -> EventLoopFuture<User> in
        let payload = try req.auth.require(UserPayload.self)
        guard let userId = UUID(uuidString: payload.subject.value) else {
            throw Abort(.badRequest)
        }
        return User.find(userId, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    try app.register(collection: UserController())
    try app.register(collection: foodController())
    try app.register(collection: fullExcersisesController())
    try app.register(collection: TrainingImagesController())
    try app.register(collection: CouplesUserController())
    try app.register(collection: datesController())
}
