//
//  Webservice.swift
//  flink
//
//  Created by beTech CAPITAL on 06/03/20.
//  Copyright © 2020 Ezequiel Barreto. All rights reserved.
//

import Foundation

enum NetworkError: Error{
    case decodingError
    case domainError
    case urlError
    case notFound
}

enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
}

struct Resource <T:Codable>{
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource{
    init(url: URL) {
        self.url = url
    }
}


class Webservice{

    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void){
        print("url de envio")
        print(resource.url)
        URLSession.shared.dataTask(with: resource.url){ (data, response, error) in
            guard let data = data, error == nil else{
                completion(.failure(.domainError))
                return
            }
            
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result{
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }else{
                
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}
