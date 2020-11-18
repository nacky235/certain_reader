import Combine
import UIKit

class ChapterViewController: UIViewController {
    public let viewModel: ChapterViewModelProtocol
    
    @IBOutlet weak var tableView: UITableView!
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

        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        viewModel.fetch()
    }
    
    func transition(selectedRow: Int) -> Void {
        let novelViewModel = NovelViewModel(dependency: .default, chapter: viewModel.chapters.value[selectedRow])
        let second = NovelViewController(viewModel: novelViewModel)
        navigationController?.pushViewController(second, animated: true)
    }
    
    
}

extension ChapterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chapters.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.chapters.value[indexPath.row].title
        return cell
    }

}

extension ChapterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.transition(chapter: viewModel.chapters.value[indexPath.row])
        
        transition(selectedRow: indexPath.row)
        print("OK")
        
    }
}



