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
        fetch()
    }
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
            if let readList = UserDefaults.standard.stringArray(forKey: "readList") {
                let isRead: Bool = readList.filter({ $0 == chapters[indexPath.row].link }).isEmpty
                cell.isReadLabel.text = isRead ? "":"読"
            } else {
                cell.isReadLabel.text = ""
            }
            cell.title.text = chapters[indexPath.row].title
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension ChapterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chapter = viewModel.chapters.value.chapters[indexPath.section][indexPath.row]
        
        let vm = NovelViewModel(chapter: chapter)
        let vc = NovelViewController(viewModel: vm)
        let navCon = UINavigationController(rootViewController: vc)
        present(navCon, animated: true, completion: nil)
        
    }
}



