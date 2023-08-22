//
//  URLSession+Extensions.swift
//  ImageFeedList
//
//  Created by Dassam on 22.07.2023.
//

import UIKit

extension URLSession {
    
    func objectTask<DecodingType: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<DecodingType, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    if !(200..<300 ~= response.statusCode) {
                        completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                        return
                    }
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(DecodingType.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(ParseError.decodeError(error)))
                    }
                }
            }
        })
        return task
    }
}
