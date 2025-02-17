//
//  ProductModel.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Fluent
import Vapor

final class ProductModel: Codable, Model, Sendable, Content {
    init() {    }
    
    static let schema: String = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Double
    
    @Parent(key: "userID")
    var user: User
    
    init(name: String, price: Double,userID : UUID) {
        self.name = name
        self.price = price
        self.$user.id = userID
    }
}
