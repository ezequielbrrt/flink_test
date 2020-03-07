//
//  CharacterRM.swift
//  flink
//
//  Created by beTech CAPITAL on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation


// MARK: SERVICE-RESPONSE
struct ServiceResponse: Codable{
    let info: Info
    let results: [ResultCharacter]
}

// MARK: Info
struct Info: Codable {
    let count, pages: Int
    let next, prev: String
}

// MARK: CHARACTER
struct ResultCharacter: Codable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}


// MARK: LOCATION
struct Location: Codable {
    let name: String
    let url: String
}

// MARK: CLASS
class CharactersOptions: NSObject{
    static var get: Resource<ServiceResponse> = {
        guard let url = URL (string: AppConfigurator.APIUrl + AppUrls.getCharacters.rawValue) else{
            fatalError("URL incorrect")
        }
        return Resource<ServiceResponse>(url: url)
    }()
    
    static func getCharacterNP(page: String) -> Resource<ServiceResponse>{
        return Resource<ServiceResponse>(url: URL(string:page)!)
    }
    
    static func getCharacterByName(name: String) -> Resource<ServiceResponse>{
        guard let url = URL(string: AppConfigurator.APIUrl + AppUrls.getCharacters.rawValue  + "?name=" + name) else{
            fatalError("URL incorrect")
        }
        print(url)
        return Resource<ServiceResponse>(url: url)
    }
}
