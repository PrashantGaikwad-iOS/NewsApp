//
//  APICaller.swift
//  NewsApp
//
//  Created by Prashant Gaikwad on 15/05/21.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    private init() {}
    
    struct Constants {
        static let topHeadlineUrl = URL(string: "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=4434b3d2f3da459e93f62f2762c90cfb")
        static let searchString = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=4434b3d2f3da459e93f62f2762c90cfb&q="
    }
    
    public func getTopstories(completion: @escaping (Result<[Article],Error>) -> Void) {
        guard let url = Constants.topHeadlineUrl else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = Constants.searchString + query
        guard let url = URL(string:urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let description: String?
    let urlToImage: String?
    let url: String?
    let publishedAt: String?
   // let source: Source
}

struct Source: Codable {
    let name: String?
}
