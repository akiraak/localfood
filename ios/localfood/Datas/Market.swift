//
//  Market.swift
//  localfood
//
//  Created by Akira Kozakai on 4/7/22.
//

import Foundation
import SwiftyJSON

class Market {
    let id: Int
    let name: String
    let address: String
    let openingHours: String
    let lat: Float
    let lng: Float

    init(
        id: Int,
        name: String,
        address: String,
        openingHours: String,
        lat: Float,
        lng: Float
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.openingHours = openingHours
        self.lat = lat
        self.lng = lng
    }

    static func create(json: JSON) -> Market? {
        if json["id"].exists() {
            return Market(
                id: json["id"].int!,
                name: json["name"].string!,
                address: json["address"].string!,
                openingHours: json["opening_hours"].string!,
                lat: json["lat"].float!,
                lng: json["lng"].float!
            )
        }
        return nil
    }
}

class Markets {
    static var shared: Markets?
    let markets: [Market]

    private init(markets: [Market]) {
        self.markets = markets
    }

    static func setup(json: JSON) {
        var os: [Market] = []
        if json.type == .array {
            for (_, j):(String, JSON) in json {
                let o = Market.create(json: j)
                if o != nil {
                    os.append(o!)
                }
            }
            if os.count > 0 {
                shared = Markets(markets: os)
            } else {
                shared = nil
            }
        } else {
            shared = nil
        }
    }
}
