//
//  RatedItems.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.13
//

import Foundation
import UIKit
import AWSDynamoDB

class RatedItems: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _itemId: String?
    var _category: String?
    var _details: String?
    var _name: String?
    var _ratingCount: NSNumber?
    var _ratingValue: NSNumber?
    
    class func dynamoDBTableName() -> String {

        return "itransitionawstestpr-mobilehub-880254806-RatedItems"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_itemId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_itemId" : "itemId",
               "_category" : "category",
               "_details" : "details",
               "_name" : "name",
               "_ratingCount" : "ratingCount",
               "_ratingValue" : "ratingValue",
        ]
    }
}
