//
//  EpisodeDetail.swift
//  flink
//
//  Created by beTech CAPITAL on 08/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

struct EpisodeDetail: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
    
}

class EpisodeRequest: NSObject{
    static func getEpisodeId(episodeId: String) -> Resource<EpisodeDetail>{
        guard let url = URL (string: AppConfigurator.APIUrl + AppUrls.getEpisode.rawValue + episodeId) else{
            fatalError("URL incorrect")
        }
        return Resource<EpisodeDetail>(url: url)
    }
}

