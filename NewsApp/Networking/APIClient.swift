//
//  GetApi.swift
//  NewsApp
//
//

import Foundation


public final class APIClient {
    public static let shared = APIClient()
    let session: URLSession
    
    public init (session: URLSession = .shared){
        self.session = session
    }
    
    func fetch<T: Decodable>(
        _ urlString: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.badURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error {
                completion(.failure(.transport(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.emptyResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpStatus(httpResponse.statusCode, data)))
                return
            }
            
            if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
                          !contentType.contains("application/json") {
                           completion(.failure(.wrongContentType(contentType)))
                           return
            }
            
            guard let data, !data.isEmpty else {
                completion(.failure(.emptyResponse))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
                return
            } catch {
                completion(.failure(.decoding(error)))
                return
            }
        }.resume()
    }
}
