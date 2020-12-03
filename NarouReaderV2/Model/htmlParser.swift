//
//  htmlParser.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/02.
//

import Foundation
import Alamofire
import Kanna

func getNovel(ncode: String, episodeNumber: Int, completion: @escaping (([String]) -> Void)) {
    
     var contents: [String] = []
//GETリクエスト 指定URLのコードを取得
    AF.request("https://ncode.syosetu.com/\(ncode)/\(episodeNumber.description)/").responseString { response in
            if case .success(let value) = response.result {
                
                contents = getNovelsContents(html: value)
//                    print(response)
                completion(contents)
            }
        
        }
    }
    
    func getNovelsContents(html: String) -> [String] {
        
        
        var contents: [String] = []
        
        
        if let doc = try? HTML(html: html, encoding: .utf8) {
            
            let kaisouString = "div[@id='container']/div[@id='novel_contents']/div[@id='novel_color']/div[@id='novel_honbun']/p[@id='L"
            
//                let contentDivNode = doc.body?.xpath("div[@id='container']/div[@id='novel_contents']/div[@id='novel_color']/div[@id='novel_honbun']")
            
            for i in 1...1000 {
                if let line = doc.body?.xpath(kaisouString + "\(i.description)" + "']") {
                    
                    if let content = line.first?.innerHTML {
                        contents.append(content)
//                        print(content)
                    } else { break }
                }
            }
//                print(contents)
        }
        return contents
        
    }
