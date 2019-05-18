//
//  API1Decodable.swift
//  GoPark
//
//  Created by Michael Wong on 28/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import Foundation

struct API1Decodable: Decodable {
    let bayid: Int?
    let lat: Double?
    let lon: Double?
    let typedesc: String?
    let duration: Int?
    let occRate: String?
}


