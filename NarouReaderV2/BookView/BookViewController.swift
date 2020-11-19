import Combine
import UIKit

class BookViewController: UIViewController {
    public let viewModel: BookViewModelProtocol

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
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
        
        viewModel.books
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
    }
    
    func transition(selectedRow: Int) -> Void {
        // [] configure 値渡し to chapterviewmodel
        let chapterViewModel = ChapterViewModel(dependency: .default)
        let next = ChapterViewController(viewModel: chapterViewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func fetch() {
        viewModel.fetch()
    }
}

extension BookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // [] configure custom cell
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.books.value[indexPath.row].title
        return cell
    }

}

extension BookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transition(selectedRow: indexPath.row)
    }
}
