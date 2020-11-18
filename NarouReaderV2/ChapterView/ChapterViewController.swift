import Combine
import UIKit

class ChapterViewController: UIViewController {
    public let viewModel: ChapterViewModelProtocol
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
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

        viewModel.fetch()
    }
    
    func transition(selectedRow: Int) -> Void {
        let novelViewModel = NovelViewModel(dependency: .default, chapter: viewModel.chapters.value[selectedRow])
        let next = NovelViewController(viewModel: novelViewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func fetch() {
        viewModel.fetch()
    }
}

extension ChapterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chapters.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // [] configure custom cell
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.chapters.value[indexPath.row].title
        return cell
    }
}

extension ChapterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transition(selectedRow: indexPath.row)
    }
}



