//
//  LoadChaptersModel.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/19.
//

//import Foundation
//
//func loadChapters(bookId: String, completion: @escaping (([Chapter]) -> Void)) {
//    let url = URL(string: "https://5f45f1b4e165a60016ba9147.mockapi.io/api/v1/chapters")!
//    let urlRequest = URLRequest(url: url)
//    var chapters: [Chapter] = []
//
//    let decoder = JSONDecoder()
//
//    let session = URLSession.shared
//    let task = session.dataTask(with: urlRequest) {
//        data, urlResponse, error in
//
//        guard let data = data else { return }
////        do {
////            let object = try JSONSerialization.jsonObject(with: data, options: [])
////            print(object)
////        } catch let error {
////            print(error)
////        }
//
//        do {
//            chapters = try decoder.decode([Chapter].self, from: data)
////            print(chapters)
//            let newChapters = chapters.filter { (Chapter) -> Bool in
////            Chapter.bookId.description == bookId
//
//            }
////            var newChapters: [Chapter] = []
////            for chapter in chapters {
////                if chapter.bookId.description == bookId {
////                    newChapters.append(chapter)
////                }
////            }
//
////            print(newChapters)
//            completion(newChapters)
//        } catch let error {
//            print("Error = \(error)")
//        }
//
//
//    }
//
//    task.resume()
//
//}
