//
//  ChapterJSON.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/17.
//

import Foundation


    
    func loadChapters() -> [Chapter] {
        /// ①プロジェクト内にある"chapters.json"ファイルのパス取得
        guard let url = Bundle.main.url(forResource: "chapters", withExtension: "json") else {
            fatalError("ファイルが見つからない")
        }
         
        /// ②employees.jsonの内容をData型プロパティに読み込み
        guard let data = try? Data(contentsOf: url) else {
            fatalError("ファイル読み込みエラー")
        }
         
        /// ③JSONデコード処理
        let decoder = JSONDecoder()
        
        
        do {
            _ = try decoder.decode([Chapter].self, from: data)
        } catch let error {
            print("Error = \(error)")
        }
        
        guard let chapters = try? decoder.decode([Chapter].self, from: data) else {
            fatalError("JOSN読み込みエラー")
        }
        /// ④データ確認
        for chapter in chapters {
            print(chapter)
        }
        
        return chapters
    }
    
    

