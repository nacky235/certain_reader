import Combine
import UIKit

class BookViewController: UIViewController {
    public let viewModel: BookViewModelProtocol
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "NovelTableViewCell", bundle: nil), forCellReuseIdentifier: "NovelCell")
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: BookViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe()
    
        loadingView.isHidden = false
        DispatchQueue.main.async {
            self.viewModel.loadNovels {
                self.loadingView.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    
    func pushChapterView(selectedBook: Novel) -> Void {
        let chapterViewModel = ChapterViewModel(dependency: .default, ncode: selectedBook.ncode)
        let next = ChapterViewController(viewModel: chapterViewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func fetch() {
        DispatchQueue.main.async {
            self.viewModel.loadNovels {
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    func subscribe() {
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
        
        viewModel.novels
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension BookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.novels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NovelCell", for: indexPath) as? NovelTableViewCell {
            cell.textLabel?.text = viewModel.novels.value[indexPath.row].title
            guard let genre: Genre = Genre(rawValue: viewModel.novels.value[indexPath.row].genre) else { return cell }
            cell.detailTextLabel?.text = genre.title
            return cell
        }
        return UITableViewCell()
    }
}

extension BookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = UserDefaults.standard.stringArray(forKey: "novels") {
            var sortedList = list.filter { $0 != viewModel.novels.value[indexPath.row].ncode }
            sortedList.insert(viewModel.novels.value[indexPath.row].ncode, at: 0)
            UserDefaults.standard.set(sortedList, forKey: "novels")
        }
        pushChapterView(selectedBook: viewModel.novels.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vm = NovelsDetailViewModel(dependency: .default, novel: viewModel.novels.value[indexPath.row])
        let vc = NovelsDetailViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let list = UserDefaults.standard.stringArray(forKey: "novels") {
            let committedTitle = viewModel.novels.value[indexPath.row].ncode
            let newList = list.filter({ $0 != committedTitle })
            UserDefaults.standard.set(newList, forKey: "novels")
            viewModel.novels.value.remove(at: indexPath.row)
        }
    }
}
