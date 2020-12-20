//
//  INPickerViewController.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/20.
//

import UIKit

class INPickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
            if traitCollection.userInterfaceStyle == .dark {
                pickerView.backgroundColor = .darkGray
            }
            
        }
    }
    public enum PickerTypes: String, CaseIterable {
        case biggenre = "大ジャンル"
        case genre = "ジャンル"
    }
    
    let genre: [BigGenre: [Genre]] = [
        .love_romance: [.iseki_world, .real_world],
        .fantasy: [.high_fantasy, .low_fantasy],
        .litelature: [.pure_literature, .human_drama, .history, .suspense, .horror, .action, .comedy],
        .sf: [.vr_game, .space, .science_fiction, .panic],
        .other: [.tale, .poetry, .essay, .replay, .other],
        .nongenre: [.nongenre]
    ]
    
    let genre1: [BigGenre: [String]] = [.love_romance : [Genre.iseki_world.title, Genre.real_world.title]]
    
    

    // タイトルの配列とタイトルがKeyの辞書型、の２つ用意するとわかりやすい
    // let titles: [String] = ["ジャンル", "その他"]
    
    let data: [BigGenre] = [
        .love_romance,
        .fantasy,
        .litelature,
        .sf,
        .other,
        .nongenre
    ]

    // 初期値は全部最初の要素
    private var selectedBigGenre: BigGenre = .love_romance
    private var selectedGenre: Genre = .real_world

    private let completion: ((BigGenre,Genre)) -> Void

    public init(completion: @escaping ((BigGenre,Genre)) -> Void) {
        self.completion = completion

        super.init(nibName: nil, bundle: .main)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
    }

    // Addをタップしたら、completionを返してからdismiss
    @objc func addTapped() {
        completion((selectedBigGenre,selectedGenre))
        dismiss(animated: true)
    }

    // Closeをタップしたらcompletionを返さないから反映されない
    @objc func closeTapped() {
        dismiss(animated: true)
    }
}

extension INPickerViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        PickerTypes.allCases.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let datas = data[PickerTypes.allCases[component]] else { return 0 }
//        return datas.count
        switch component {
        case 0:
            return data.count
        case 1:
            return genre[selectedBigGenre]!.count
        default:
            return 0
        }
    }
}

extension INPickerViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return data[row].title
        case 1:
            let genreArray = genre[selectedBigGenre]!
            return genreArray[row].title
            
        default:
            return nil
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let pickerType = BigGenre.allCases[component]
//        guard let datas = data[] else { return }
//        let data = datas[row]
//
//        selectedData =
        
        switch component {
        case 0:
            selectedBigGenre = data[row]
            pickerView.reloadComponent(1)
        case 1:
            let genresInSelectedBigGenre = genre[selectedBigGenre]!
            let selectedGenreInRows = genresInSelectedBigGenre[row]
            selectedGenre = selectedGenreInRows
        default:
            return
        }
    }
}

