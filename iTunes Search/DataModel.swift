//
//  DataModel.swift
//  iTunes Search
//
//  Created by MANOJ REDDY on 20/08/21.
//  Copyright © 2021 MANOJ REDDY. All rights reserved.
//

import Foundation

// https://itunes.apple.com/search?term=coldplay&entity=song

class DataModel {
    
    private var dataTask: URLSessionDataTask?
    
    func loadSongs(searchTerm: String, completion: @escaping(([Song]) -> Void)) {
        
        dataTask?.cancel()
        
        guard let url = buildUrl(forTerm: searchTerm) else {
            
            completion([])
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url){
            
            data, _, _ in
            guard let data = data else {
                
                completion([])
                return
                
            }
            
            if let songResponse = try? JSONDecoder().decode(SongResponse.self, from: data){
                
                completion(songResponse.songs)
            }
        }
        dataTask?.resume()
    
        
    }
    
    private func buildUrl(forTerm searchTerm: String) -> URL? {
        
        guard !searchTerm.isEmpty else {return nil}
        
        let queryItems = [
         URLQueryItem(name: "term", value: searchTerm),
         URLQueryItem(name: "entity", value: "some"),
         
        ]
        var components = URLComponents(string: "https://itunes.apple.com/search")
        components?.queryItems = queryItems
        
        return components?.url
        
    }
}

struct SongResponse: Decodable {
    
    let songs: [Song]
    
    enum Codingkeys: String, CodingKey {
        case songs = "results"
    }
    
}

struct Song: Decodable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl: String
    
    enum Codingkeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl = "artworkUrl60"
    }
}

