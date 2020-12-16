import Combine
import UIKit

class ChapterViewController: UIViewController {
    public let viewModel: ChapterViewModelProtocol
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "ChapterViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ChapterCell")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ChapterViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetch))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        viewModel.command
            .receive(on: RunLoop.main)
            .sink { [weak self] command in
                switch command {
                case .showSnackbar(let text):
                    let alert = UIAlertController(
                        title: text,
                        message: text,
                        preferredStyle: UIAlertController.Style.alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)

        viewModel.chapters
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
//    func transition(selectedRow: Int) -> Void {
//        let novelViewModel = NovelViewModel(dependency: .default, chapter: viewModel.chapters.value[selectedRow])
//        let next = NovelViewController(viewModel: novelViewModel)
//        navigationController?.pushViewController(next, animated: true)
//    }
    @objc func fetch() {
        viewModel.fetch(viewModel.ncode)
        
    }
}

extension ChapterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.chapters.value.chapterTitle.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.chapters.value.chapterTitle[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chapters.value.chapters[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as? ChapterViewTableViewCell {
            let chapters = viewModel.chapters.value.chapters[indexPath.section]
            
            cell.title.text = chapters[indexPath.row].title
//            cell.episodeNumber.text = viewModel.chapters.value[indexPath.row].episodeNumber.description

            return cell
        }
        return UITableViewCell()
    }
}

extension ChapterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        for i in 0...indexPath.section {
//            if indexPath.section == 0 {
//                cellCount = indexPath.row + 1
//                break
//            }
//            switch i {
//            case 0:
//                cellCount = indexPath.row
//            default:
//                cellCount += viewModel.chapters.value.chapterName[indexPath.section - 1].count
//                if indexPath.row == viewModel.chapters.value.chapterName[indexPath.section].endIndex - 1 {
//                    cellCount += indexPath.row - 1
//                } else {
//                    cellCount += indexPath.row
//                }
//            }
//        }
        
        let ncode = viewModel.ncode
        let link = viewModel.chapters.value.chapters[indexPath.section][indexPath.row].link
        let url = "https://ncode.syosetu.com/" + link
        
        let vm = NovelViewModel(url: url)
        let vc = NovelViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



