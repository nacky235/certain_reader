import Combine
import UIKit

class HNovelsDetailViewController: UIViewController {
    public let viewModel: HNovelsDetailViewModelProtocol

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "title")
            tableView.register(UINib(nibName: "AuthorCell", bundle: nil), forCellReuseIdentifier: "author")
            tableView.register(UINib(nibName: "OutlineCell", bundle: nil), forCellReuseIdentifier: "outline")
            
        }
    }
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HNovelsDetailViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add , target: self, action: #selector(addToShelf))
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

        // Do any additional setup after loading the view.
    }
    
    @objc func addToShelf() {
        if var list = UserDefaults.standard.stringArray(forKey: "Hnovels") {
            if list.filter({ $0 == viewModel.hNovel.ncode }) == [] {
                list.append(viewModel.hNovel.ncode)
            }
            UserDefaults.standard.set(list, forKey: "Hnovels")
        } else {
            UserDefaults.standard.setValue([viewModel.hNovel.ncode], forKey: "Hnovels")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension HNovelsDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "title") as? TitleCell {
                cell.textLabel?.text = viewModel.hNovel.title
                return cell
            }
            
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "author") as? AuthorCell {
                cell.textLabel?.text = viewModel.hNovel.writer
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "outline") as? OutlineCell {
                cell.contentLabel.text = viewModel.hNovel.story
                return cell
            }
        default:
                return UITableViewCell()
            }
        return UITableViewCell()
    }
}
    
    

