import Combine
import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
//    var isSearchBarEmpty: Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
   
    public var viewModel: SearchViewModelProtocol

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
        
//        showSpinner(onView: view)
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = SearchArea.allCases.map { $0.name }
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        showGenres()
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(pushSearchSetting))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartTapped))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
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
                self?.fetch()
            }
            .store(in: &cancellables)
        
        viewModel.genre
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetch()
            }
            .store(in: &cancellables)
//
//        filterContentForSearchText(searchController.searchBar.text!, searchArea: viewModel.searchArea) {
//            self.removeSpinner()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    func fetch() {
        loadingView.isHidden = false
        
        filterContentForSearchText(searchController.searchBar.text!, searchArea: viewModel.searchArea) {
        
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func pushDetailView(novel: Novel) {
        let viewModel = NovelsDetailViewModel(dependency: .default, novel: novel)
        let next = NovelsDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func pushSearchSetting() {
        let pickerView = INPickerViewController(completion: pushData)
        let nc = ModalContainerNavigationViewController(rootViewController: pickerView)
        self.presentPanModal(nc)
    }
    
    func pushData(selected: (biggenre: BigGenre, genre: Genre, order: Order)) {
        viewModel.biggenre.send(selected.biggenre)
        viewModel.genre.send(selected.genre)
        viewModel.order.send(selected.order)
        showGenres()
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
        isSexy = true
        let vm = HSearchViewModel(dependency: .default)
        let vc = HSearchViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    searchArea: SearchArea, completion: @escaping () -> Void) {
        
        var parameters: Parameters {
            switch searchArea {
            case .all:
                return Parameters(word: searchText, title: 1, writer: 1, keyword: 1, order: viewModel.order.value, genre: viewModel.genre.value, biggenre: viewModel.biggenre.value)
            case .title:
                return Parameters(word: searchText, title: 1, writer: 0, keyword: 0, order: viewModel.order.value, genre: viewModel.genre.value, biggenre: viewModel.biggenre.value)
            case .writer:
                return Parameters(word: searchText, title: 0, writer: 1, keyword: 0, order: viewModel.order.value, genre: viewModel.genre.value, biggenre: viewModel.biggenre.value)
            case .keywords:
                return Parameters(word: searchText, title: 0, writer: 0, keyword: 1, order: viewModel.order.value, genre: viewModel.genre.value, biggenre: viewModel.biggenre.value)
            }
        }
        
        viewModel.loadNovels(parameters: parameters) { (novel) in
            self.viewModel.novels.send(novel)
        }
        tableView.reloadData()
        completion()
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
    //NSComparisonPredicate
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            if let text = searchBar.text {
//                if text == "" {
//                    viewModel.loadNovels(parameters: Parameters(word: "")) { novels in
//                        self.viewModel.novels.send(novels)
//                    }
//                } else {
//                    let parameters = Parameters(word: text)
//                    viewModel.loadNovels(parameters: parameters) { novels in
//                        self.viewModel.novels.send(novels)
//                    }
//                }
//            }
//    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if let selectedArea = SearchArea(rawValue: selectedScope) {
            viewModel.searchArea = selectedArea
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        fetch()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
//        searchBarSearchButtonClicked(searchBar)
        if !(searchBar.text?.isEmpty)! {
            fetch()
        }
    }
}



