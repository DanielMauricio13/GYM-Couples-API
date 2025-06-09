
// configures your application
import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import Foundation

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if let databaseURL = Environment.get("DATABASE_URL") {
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)

        var postgresConfig = try SQLPostgresConfiguration(url: databaseURL)
        postgresConfig.coreConfiguration.tls = .require(nioSSLContext)

        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }  else {
        print("error")
        app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
       }
//
    app.routes.defaultMaxBodySize = "10mb"
    app.passwords.use(.bcrypt)

//    let yourDatabaseURI = "postgres://ubdrdc00lfof2:pfb4928fc65cc7d14e6d453de3bec38d206deb8b583057a384daf8a58812ee2e7@c67okggoj39697.cluster-czrs8kj4isg7.us-east-1.rds.amazonaws.com:5432/d5ao5apt98iepe"
//
//        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
//        tlsConfig.certificateVerification = .none
//        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)
//
//        var postgresConfig = try SQLPostgresConfiguration(url: yourDatabaseURI)
//        postgresConfig.coreConfiguration.tls = .require(nioSSLContext)
//
//        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
//

    app.migrations.add(AddEmailToFood())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateFood())
    app.migrations.add(CreateExcersises())
    app.migrations.add(CreateFullTraining())
    app.migrations.add(CreateImage())
    app.migrations.add(CreateImage())
    app.middleware.use(LogMiddleware())
    app.migrations.add(CreateCouplesUser())
    app.migrations.add(CreateUserDate())
    if app.environment == .development{
        try await app.autoMigrate()
    }
    
    app.jwt.signers.use(.hs256(key: "jj+XH8YwTiTqRjHakTZPGgkHgjf+EUEPmzXCxBPQapI"))
//    
//    app.apns.configuration = try .init(
//        authenticationMethod: .jwt(
//            key: .private(filePath: "path/to/AuthKey_XXXXXXXXXX.p8"),
//            keyIdentifier: "YOUR_KEY_ID",
//            teamIdentifier: "YOUR_TEAM_ID"
//        ),
//        topic: "com.yourcompany.yourapp", // Your app's bundle identifier
//        environment: .production // or .sandbox
//    )
//    
    try routes(app)
}
