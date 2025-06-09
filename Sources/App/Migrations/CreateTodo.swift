import Fluent
import Foundation
import Vapor
struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("lastName", .string, .required)
            .field("firstName", .string, .required)
            .field("age", .int)
            .field("gender", .string)
            .field("weight", .int)
            .field("goal", .string)
            .field("bodyStructure", .string)
            .field("height", .int)
            .field("DailyProtein", .int)
            .field("DailyCalories", .int)
            .field("email", .string)
            .field("password", .string)
            .field("numDays", .int)
            .field("numHours",.string)
            .field("excersises", .json)
            .field("heightFt" ,.int)
            .field("heightInc",.int)
            .field("sugars",.int)
            .field("carbs",.int)
            .field("water",.double)
            .field("burnCalories",.int)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}

struct CreateFood: Migration{
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("foods")
            .id()
            .field("Name" ,.string ,.required)
            .field("Protein", .int)
            .field("Calories" , .int)
            .field("Sugars", .int)
            .field("Carbohydrates",.int)
            
            .create()
    }
    func revert(on database: any Database) -> EventLoopFuture<Void> {
         database.schema("foods").delete()
    }
    
}

struct AddEmailToFood: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("foods")
            .field("email", .string, .required)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("foods")
            .deleteField("email")
            .update()
    }
}
struct CreateExcersises: Migration{
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("excersises")
            .id()
            .field("name" ,.string ,.required)
            .field("sets", .int)
            .field("reps" , .string)
            .field("calories", .int)
            .create()
    }
    func revert(on database: any Database) -> EventLoopFuture<Void> {
         database.schema("excersises").delete()
    }
    
}

struct CreateFullTraining: Migration{
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("training")
            .id()
            .field("email" ,.string ,.required)
            .field("excersises", .json)
            .create()
    }
    func revert(on database: any Database) -> EventLoopFuture<Void> {
         database.schema("training").delete()
    }
    
}
//struct CreateImage: Migration {
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database.schema("images")
//            .id()
//            .field("image_path", .string, .required)
//            .unique(on: "image_path")
//            .create()
//            .flatMap { _ in
//                let directory = DirectoryConfiguration.detect().workingDirectory
//                let imagesDirectory = directory + "Public/images"
//                let fileManager = FileManager.default
//
//                // Check if the directory already exists
//                if !fileManager.fileExists(atPath: imagesDirectory) {
//                    do {
//                        // Create the directory
//                        try fileManager.createDirectory(atPath: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
//                        print("Images directory created successfully at \(imagesDirectory)")
//                    } catch {
//                        // Handle directory creation error
//                        print("Error creating images directory: \(error)")
//                    }
//                } else {
//                    print("Images directory already exists at \(imagesDirectory)")
//                }
//
//                return database.eventLoop.makeSucceededFuture(())
//            }
//    }
//
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        database.schema("images").delete()
//    }
//}
struct CreateImage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("images")
            .id()
            .field("imageData", .data, .required)
            .field("filename", .string, .required)
            .unique(on: "filename")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("images").delete()
    }
}

struct CreateCouplesUser: Migration {
    func revert(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("couplesUser").delete()
    }
    
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("couplesUser")
            .id()
            .field("firstName",.string, .required)
            .field("email", .string,. required)
            .field("password", .string ,.required)
            .field("points" , .int , .required)
            
            .field("mood", .json)
            .field("partnerID", .int)
            .field("pairingCode", .int)
            .create()
    }
                   
            
                   
}
struct CreateUserDate: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("dates")
            .id()
            .field("email", .string, .required)  // ✅ Each row is linked to an email
            .field("name", .string, .required)   // ✅ Event name (e.g., Birthday, Anniversary)
            .field("date", .date, .required)     // ✅ Single date per row
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("dates").delete()
    }
}
