import Combine
import UIKit

class HChapterListViewController: UIViewController {
    public let viewModel: HChapterListViewModelProtocol

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "ChapterViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ChapterCell")
        }
    }
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HChapterListViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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

        // Do any additional setup after loading the view.
    }
}

extension HChapterListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.chapters.chapterTitle.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.chapters.chapterTitle[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chapters.chapters[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCell", for: indexPath) as? ChapterViewTableViewCell {
            let chapters = viewModel.chapters.chapters[indexPath.section]
            if let readList = UserDefaults.standard.stringArray(forKey: "readList") {
                let isRead: Bool = readList.filter({ $0 == chapters[indexPath.row].link }).isEmpty
                cell.readMark.image = isRead ? .none : UIImage(systemName: "book.closed")
            } else {
                cell.readMark.image = .none
            }
            cell.title.text = chapters[indexPath.row].title
            return cell
        }
        return UITableViewCell()
    }
}
