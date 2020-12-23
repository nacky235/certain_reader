import Combine
import UIKit

class HNovelsListViewController: UIViewController {
    public let viewModel: HNovelsListViewModelProtocol

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "NovelTableViewCell", bundle: nil), forCellReuseIdentifier: "NovelCell")
        }
    }
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HNovelsListViewModelProtocol) {
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

        viewModel.novels
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        // Do any additional setup after loading the view.
        viewModel.load {
            self.tableView.reloadData()
        }
    }
    
    func pushChapterList(novel: HNovel) {
        let vm = HChapterListViewModel(dependency: .default, novel: novel)
        let vc = HChapterListViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HNovelsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.novels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NovelCell", for: indexPath) as? NovelTableViewCell {
            cell.textLabel?.numberOfLines = 0
            
            cell.textLabel?.text = viewModel.novels.value[indexPath.row].title
            cell.textLabel?.font = .boldSystemFont(ofSize: 18)
            cell.detailTextLabel?.text = viewModel.novels.value[indexPath.row].writer
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = UserDefaults.standard.stringArray(forKey: "Hnovels") {
            var sortedList = list.filter { $0 != viewModel.novels.value[indexPath.row].ncode }
            sortedList.insert(viewModel.novels.value[indexPath.row].ncode, at: 0)
            UserDefaults.standard.set(sortedList, forKey: "Hnovels")
        }
        pushChapterList(novel: viewModel.novels.value[indexPath.row])
        }
    }
    

