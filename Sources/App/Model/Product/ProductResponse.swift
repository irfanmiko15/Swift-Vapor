//
//  ProductResponse.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//
import Vapor

struct ProductResponse: Content {
    var id: UUID?
    var name: String
    var price: Double
}
