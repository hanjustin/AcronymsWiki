import Fluent
import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    
    let databaseName: String
    let databasePort: Int
    if (app.environment == .testing) {
        databaseName = "vapor-test"
        databasePort = 32574
    } else {
        databaseName = "vapor_database"
        databasePort = 3306
    }
    
    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: databasePort,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? databaseName,
        tlsConfiguration: tls
    ), as: .mysql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    app.logger.logLevel = .debug
    try await app.autoMigrate()

    try routes(app)
}
