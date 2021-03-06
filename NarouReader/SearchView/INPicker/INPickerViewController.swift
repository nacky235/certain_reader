//
//  INPickerViewController.swift
//  NarouReader
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
    
    let genre: [BigGenre: [Genre]] = [
        .all: [.all],
        .love_romance: [.all ,.iseki_world, .real_world],
        .fantasy: [.all ,.high_fantasy, .low_fantasy],
        .litelature: [.all ,.pure_literature, .human_drama, .history, .suspense, .horror, .action, .comedy],
        .sf: [.all, .vr_game, .space, .science_fiction, .panic],
        .other: [.all, .tale, .poetry, .essay, .replay, .other],
        .nongenre: [.all, .nongenre]
    ]
    
    let data: [BigGenre] = [
        .all,
        .love_romance,
        .fantasy,
        .litelature,
        .sf,
        .other,
        .nongenre
    ]
    
    let orders: [Order] = [
        .hyoka,
        .new,
        .dailypoint,
        .weekly
    ]
    
    let ordersDescription: [String] = [
        Order.hyoka.rawValue,
        Order.new.rawValue,
        Order.dailypoint.rawValue,
        Order.weekly.rawValue
    ]
    
    private var selectedBigGenre: BigGenre = .all
    private var selectedGenre: Genre = .all
    private var selectedOrder: Order = .hyoka

    private let completion: ((BigGenre, Genre, Order)) -> Void

    public init(completion: @escaping ((BigGenre, Genre, Order)) -> Void) {
        self.completion = completion

        super.init(nibName: nil, bundle: .main)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentedControl = UISegmentedControl(items: ordersDescription)
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        selectedOrder = orders[sender.selectedSegmentIndex]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        completion((selectedBigGenre, selectedGenre, selectedOrder))
    }
}

extension INPickerViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
        switch component {
        case 0:
            selectedBigGenre = data[row]
            selectedGenre = genre[selectedBigGenre]![0]
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

