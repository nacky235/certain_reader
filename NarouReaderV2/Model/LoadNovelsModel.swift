//
//  LoadNovelsModel.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/28.
//

import Foundation

func loadNovels(completion: @escaping (([Novel]) -> Void)) {
    
    let url = URL(string: "https://api.syosetu.com/novelapi/api/?out=json")!
    let urlRequest = URLRequest(url: url)
    var novels: [Novel] = []

    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest) {
        data, urlResponse, error in

//        guard let data = data else { return }
        print("aaa")

        do {
            let novelContainer = try JSONDecoder().decode(NarouContainer.self, from: data!)
            print(novels)
            completion(novelContainer.novels)
        } catch let error {
            print("Error = \(error)")
        }
    }
    
    
    task.resume()
    
}

