//
//  CreateUserTableMigration.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Fluent

struct CreateUserTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users")
            .delete()
    }
}
