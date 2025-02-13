//
//  CreateProductMigration.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//


import Fluent


struct CreateProductTableMigration: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("products")
                    .id()
                    .field("name", .string, .required)
                    .field("price", .double, .required)
                    .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade))
                    .unique(on: "name")
                    .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("products").delete()
    }
}
