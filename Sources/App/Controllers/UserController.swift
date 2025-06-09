import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let user = routes.grouped("users")
        user.get("checkEmail", use: checkEmail)
        user.get("checkCredentials", use: checkCredentials)
        user.get("getUserInfo", use: getUserInfo)
//        user.get("getExcersises", use: getExercisesForUser)
        user.get(use:index)
        user.post( use: create)
        user.put(use: update)
        user.group(":userID"){
            user in
            user.delete( use: delete)
        }
    }
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[User]>{
        User.query(on: req.db).all()
    }
    @Sendable
    func create(req: Request)  throws -> EventLoopFuture<HTTPStatus>{
        let song = try req.content.decode(User.self)
        song.password = try req.password.hash(song.password!)
        return song.save(on: req.db).transform(to: .ok)
    }
    @Sendable
    func update(req : Request) throws -> EventLoopFuture<HTTPStatus>{
        let song = try req.content.decode(User.self)
        
        return User.find(song.id, on: req.db).unwrap(or: Abort(.notFound))
            .flatMap{
                $0.firstName = song.firstName
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    @Sendable
    func delete(req:Request) throws -> EventLoopFuture<HTTPStatus>{
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap{$0.delete(on: req.db)}.transform(to: .ok)
        
    }
    
    // For checking if an email is registered
    @Sendable
    func checkEmail(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let email = try req.query.get(String.self, at: "email")
        
        return User.query(on: req.db)
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
    // For retrieving user information
    @Sendable
    func getUserInfo(req: Request) throws -> EventLoopFuture<User> {
        let email = try req.query.get(String.self, at: "email")
        
        return User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    @Sendable
    func checkCredentials(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let email = try req.query.get(String.self, at: "email")
        let password = try req.query.get(String.self, at: "password")
        
        return User.query(on: req.db)
            .filter(\.$email == email)
            .filter(\.$password == password) // Replace with your actual password property
            .first()
            .map { existingUser in
                if let _ = existingUser {
                    return .ok // Email and password match
                } else {
                    return .notFound // Email and password do not match
                }
            }
    }

    
    
}
