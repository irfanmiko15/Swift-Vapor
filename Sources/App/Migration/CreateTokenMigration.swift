//
//  CreateTokenMigration.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Fluent

struct CreateTokenTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
       try await database.schema("tokens")
            .id()
            .field("tokenValue", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
       try await database.schema("tokens")
            .delete()
    }
}
