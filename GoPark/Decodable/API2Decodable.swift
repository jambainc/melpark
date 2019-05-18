//
//  API2Decodable.swift
//  GoPark
//
//  Created by Michael Wong on 28/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import Foundation

struct API2Decodable: Decodable {
    let bayid: Int?
    let lat: Double?
    let long: Double?
    let traveltime: Int?
    let cost: Double?
    let duration: Int?
    let sign: String?
    let status: String?
    let occRate: String?
    let nextAvailable: String?
    let humanDesc: String?
}

