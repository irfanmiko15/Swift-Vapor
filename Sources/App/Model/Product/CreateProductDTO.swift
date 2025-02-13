//
//  CreateProductDTO.swift
//  product_api
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//
import Vapor

struct CreateProductDTO: Content {
    var name: String
    var price: Double
}
