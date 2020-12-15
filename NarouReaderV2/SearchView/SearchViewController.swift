import Combine
import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
   
    public let viewModel: SearchViewModelProtocol

    private var cancellables = Set<AnyCancellable>()
    
    var searchController = UISearchController(searchResultsController: nil)

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
    
    func pushDetailView(novel: Novel) {
        let viewModel = NovelsDetailViewModel(dependency: .default, novel: novel)
        let next = NovelsDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.novels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.novels.value[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDetailView(novel: viewModel.novels.value[indexPath.row])
    }
}

extension SearchViewController: UISearchBarDelegate {
    //NSComparisonPredicate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let text = searchBar.text {
                if text == "" {
                    viewModel.loadNovels(parameters: Parameters(word: "")) { novels in
                        self.viewModel.novels.send(novels)
                    }
                } else {
                    let parameters = Parameters(word: text)
                    viewModel.loadNovels(parameters: parameters) { novels in
                        self.viewModel.novels.send(novels)
                    }
                }
            }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        searchBarSearchButtonClicked(searchBar)
    }
}



