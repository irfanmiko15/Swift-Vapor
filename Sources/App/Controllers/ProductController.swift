//
//  ProductController.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//

import Fluent
import Vapor

struct ProductController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let products = routes.grouped("api", "v1", "products")
        
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = products.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.get(use: index)
        tokenAuthGroup.post(use: create)
        tokenAuthGroup.get(":id",use: show)
        tokenAuthGroup.put(":id",use: update)
        tokenAuthGroup.delete(":id", use: delete)
        
    }

    @Sendable func index(req: Request) async throws -> BaseResponseList<ProductResponse> {
        let user = try req.auth.require(User.self) 
        let userID = try user.requireID()

        let products = try await ProductModel.query(on: req.db)
            .filter(\.$user.$id == userID)  // 🔹 Filter by user ID
            .all()

        let productResponses = products.map { product in
                ProductResponse(id: product.id, name: product.name, price: product.price)
        }
        return BaseResponseList(success: true, statusCode: 200, message: "Success Get Product", errors: [], data: productResponses)
    }
    
    @Sendable func create(req: Request) async throws -> BaseResponse<CreateProductDTO> {
            let user = try req.auth.require(User.self)
            let product = try req.content.decode(CreateProductDTO.self)
            let saveProduct = ProductModel(name: product.name, price: product.price, userID: try user.requireID())
            try await saveProduct.save(on: req.db)
        return BaseResponse(success: true, statusCode: 200, message: "Product created", errors: [], data: product)
    }
    
    @Sendable func show(req: Request) async throws -> ProductModel {
        guard let product = try await ProductModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }
    
    @Sendable func update(req: Request) async throws -> BaseResponse<ProductModel> {
        guard let product = try await ProductModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedProduct = try req.content.decode(ProductModel.self)
        
        product.name = updatedProduct.name
        product.price = updatedProduct.price
        
        try await product.save(on: req.db)
        return BaseResponse(success: true, statusCode: 200, message: "Product updated", errors: [], data: product)
    }
    
    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await ProductModel.find(req.parameters.get("id"), on: req.db) else {
               throw Abort(.notFound)
           }
           
           try await product.delete(on: req.db)
        return HTTPStatus.ok
    }
}

