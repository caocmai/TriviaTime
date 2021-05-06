//
//  APIManager.swift
//  TriviaTime
//
//  Created by Cao Mai on 5/5/21.
//

import Foundation

protocol NetworkService {
    //  func isTokenValid() -> Bool
    //  func refreshAccessToken(completion: @escaping (() -> Void))
    func fetch<T: Decodable>( at endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
    
    func fetchTEST( at endPoint: EndPoint)
    
}


class APIService: NetworkService {
    
    func fetch<T: Decodable>( at endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endPoint.url else {
            print("❌ \(#function) - Error: Cannot create URL using - \(endPoint.urlString)")
            return
        }
        let method = "GET"
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.cachePolicy = .reloadRevalidatingCacheData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(object))
                    }
                    
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    

    func fetchTEST(at endPoint: EndPoint) {

            guard let url = endPoint.url else {
                print("❌ \(#function) - Error: Cannot create URL using - \(endPoint.urlString)")
                return
            }
            let method = "GET"
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.cachePolicy = .reloadRevalidatingCacheData
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    do {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                }
            }
            task.resume()
        }

}
