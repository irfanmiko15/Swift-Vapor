//
//  BaseResponse.swift
//  vapor_postgresql_example
//
//  Created by Irfan Dary Sujatmiko on 12/02/25.
//



import Foundation
import Fluent
import Vapor

struct BaseResponse<T:Content>: Content {
    let success: Bool
    let statusCode: Int
    let message: String
    let errors:[String],
    data: T
    
}
struct BaseResponseList<T:Content>: Content {
    let success: Bool
    let statusCode: Int
    let message: String
    let errors:[String?], data: [T]

}
