//
//  LoadChaptersModel.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/19.
//

import Foundation

func loadChapters(completion: @escaping (([Chapter]) -> Void)) {
    let url = URL(string: "https://5f45f1b4e165a60016ba9147.mockapi.io/api/v1/chapters")!
    let urlRequest = URLRequest(url: url)
    var chapters: [Chapter] = []
    
    let decoder = JSONDecoder()
    
    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest) {
        data, urlResponse, error in
        
        guard let data = data else { return }
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            print(object)
        } catch let error {
            print(error)
        }
        
        do {
            chapters = try decoder.decode([Chapter].self, from: data)
            print(chapters)
            completion(chapters)
        } catch let error {
            print("Error = \(error)")
        }
        

    }
    
    task.resume()
    
}
