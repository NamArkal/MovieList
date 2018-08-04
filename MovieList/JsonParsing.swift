//
//  JsonParsing.swift
//  MovieList
//
//  Created by Namrata A on 3/13/18.
//  Copyright © 2018 Namrata A. All rights reserved.
//

import Foundation

struct movie : Decodable {
    let vote_count: Int?
    let id: Int?
    let video: Bool?
    let vote_average: Double?
    let title: String?
    let popularity: Double?
    let poster_path: String?
    let original_language: String?
    let original_title: String?
    let genre_ids: [Int]?
    let backdrop_path: String?
    let adult: Bool?
    let overview: String?
    let release_date: String?
}

struct res : Decodable {
    let page: Int?
    let numResults: Int?
    let numPages: Int?
    var movies: [movie]
    
    private enum CodingKeys: String, CodingKey {
        case page = "page", numResults = "total_results", numPages = "total_pages", movies = "results"
    }
}

class JsonParsing {
    var results : res?
    
    func downloadJson(completed: @escaping() -> ()){
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=a360a3f030dca300f6f8f61ce72d537d")
        URLSession.shared.dataTask(with: url!){
            (data, response, err) in
            if err == nil {
                guard let jsondata = data  else {return}
                do{
                    self.results = try JSONDecoder().decode(res.self, from: jsondata)
                    //print ("the poster path is ", self.results?.movies[0].poster_path as Any)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print ("JSON downloading error ")
                }
            }
        }.resume()
    }
}
