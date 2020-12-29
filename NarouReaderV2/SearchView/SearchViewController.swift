import Combine
import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .onDrag
        }
    }
    var searchController = UISearchController(searchResultsController: nil)
    
   
    public var viewModel: SearchViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        definesPresentationContext = true
        subscribe()
        configureNavigationBar()
        configureSearchController()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    func subscribe() {
        let searchBar = searchController.searchBar
        let searchArea = viewModel.searchArea.value
        
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
        
        viewModel.biggenre
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.fetch(searchBar.text!, searchArea: searchArea)
                self?.showGenres()
            }
            .store(in: &cancellables)
        
        viewModel.genre
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.fetch(searchBar.text!, searchArea: searchArea)
                self?.showGenres()
            }
            .store(in: &cancellables)
        
        viewModel.searchArea
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel.fetch(searchBar.text!, searchArea: searchArea)
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    func configureNavigationBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        showGenres()
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(pushSearchSetting))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartTapped))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = SearchArea.allCases.map { $0.name }
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        searchController.searchBar.resignFirstResponder()
//        searchController.searchBar.endEditing(true)
    }
    
    func pushDetailView(novel: Novel) {
        let viewModel = NovelsDetailViewModel(dependency: .default, novel: novel)
        let next = NovelsDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func pushSearchSetting() {
        let pickerView = INPickerViewController(completion: viewModel.pushData)
        let nc = ModalContainerNavigationViewController(rootViewController: pickerView)
        self.presentPanModal(nc)
    }
    
    func showGenres() {
        if viewModel.biggenre.value == .all {
            self.navigationItem.title = "全て"
        } else if viewModel.genre.value == .all && viewModel.biggenre.value != .all {
            self.navigationItem.title = "全て" + " #" + viewModel.biggenre.value.title
        } else {
            self.navigationItem.title = viewModel.genre.value.title + " #" + viewModel.biggenre.value.title
        }
    }
    
    @objc func heartTapped() {
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "heart.fill")
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.novels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            loadingView.isHidden = true
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: .none)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = viewModel.novels.value[indexPath.row].title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.detailTextLabel?.text = Genre(rawValue: viewModel.novels.value[indexPath.row].genre)?.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDetailView(novel: viewModel.novels.value[indexPath.row])
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let selectedArea = SearchArea(rawValue: selectedScope) else { return }
        viewModel.searchArea.send(selectedArea)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.fetch(searchBar.text!, searchArea: viewModel.searchArea.value)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if !(searchBar.text?.isEmpty)! {
            viewModel.fetch(searchBar.text!, searchArea: viewModel.searchArea.value)
        }
    }
}



