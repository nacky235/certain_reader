import Combine
import UIKit
import SafariServices

class NovelsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "title")
            tableView.register(UINib(nibName: "AuthorCell", bundle: nil), forCellReuseIdentifier: "author")
            tableView.register(UINib(nibName: "GenresCell", bundle: nil), forCellReuseIdentifier: "genres")
            tableView.register(UINib(nibName: "OutlineCell", bundle: nil), forCellReuseIdentifier: "outline")
        }
    }
    public let viewModel: NovelsDetailViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NovelsDetailViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        subscribe()
    }
    
    func configureNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addToShelf))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
        
        viewModel.novel
            .receive(on: RunLoop.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func addToShelf() {
        if var list = UserDefaults.standard.stringArray(forKey: "novels") {
            if list.filter({ $0 == viewModel.novel.value.ncode }) == [] {
                list.append(viewModel.novel.value.ncode)
            }
            UserDefaults.standard.set(list, forKey: "novels")
        } else {
            UserDefaults.standard.setValue([viewModel.novel.value.ncode], forKey: "novels")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension NovelsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "title") as? TitleCell {
                cell.textLabel?.text = viewModel.novel.value.title
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "author") as? AuthorCell {
                cell.textLabel?.text = viewModel.novel.value.writer
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "genres") as? GenresCell {
                cell.textLabel?.text = Genre(rawValue: viewModel.novel.value.genre)?.title
                cell.detailTextLabel?.text = BigGenre(rawValue: viewModel.novel.value.biggenre)?.title
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "outline") as? OutlineCell {
                cell.contentLabel.text = viewModel.novel.value.story
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}


