//
//  LocationDetail.swift
//  flink
//
//  Created by Ezequiel Barreto on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

struct LocationDetail: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}

class LocationDetailRequests: NSObject{
    static func getLocationDetail(locationId: String) -> Resource<LocationDetail>{
        guard let url = URL (string: AppConfigurator.APIUrl + AppUrls.getLocation.rawValue + locationId) else{
            fatalError("URL incorrect")
        }
    
        return Resource<LocationDetail>(url: url)
    }
}
