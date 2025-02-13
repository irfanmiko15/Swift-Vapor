//
//  ProductModel.swift
//  product_api
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Fluent
import Vapor

final class ProductModel: Codable, Model, Sendable {
    static let schema: String = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}
