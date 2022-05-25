//
//  APICaller.swift
//  NewsApp
//
//  Created by Anand on 25/05/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
        
    struct Constants {
        static let topHealinesURL = URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=264af05cc64d48058f7d6283be6a36f0")
    }
    
    private init() {}

    public func getTopStories(completion: @escaping (Result<[String], Error>) -> Void){
        guard let url = Constants.topHealinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                }
                catch {
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
    let source: Source
    let title: String
    let desription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
    
}
