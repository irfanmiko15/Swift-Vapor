import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "DATABASE_HOST",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? "DATABASE_PORT",
            username: Environment.get("DATABASE_USERNAME") ?? "DATABASE_USERNAME",
            password: Environment.get("DATABASE_PASSWORD") ?? "DATABASE_PASSWORD",
            database: Environment.get("DATABASE_NAME") ?? "DATABASE_NAME",
            tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    app.migrations.add(CreateUserTableMigration())
    app.migrations.add(CreateProductTableMigration())
    app.migrations.add(CreateTokenTableMigration())
    try routes(app)
}
