//
//  APIManager.swift
//  ToDoList
//
//  Created by Владимир Амелькин on 06.03.2025.
//

import Foundation

// MARK: - APIEndpoint
enum APIEndpoint {
    case fetchTasks
    
    var path: String {
        switch self {
            case .fetchTasks:
                return "https://dummyjson.com/todos"
        }
    }
    
    var method: String {
        switch self {
            case .fetchTasks:
                return "GET"
        }
    }
}

// MARK: - APIManagerProtocol
protocol APIManagerProtocol {}

// MARK: - APIManager
final class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint.path) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            if let data {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                }
                catch(let error) {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            }
        }
        
        task.resume()
    }
}
