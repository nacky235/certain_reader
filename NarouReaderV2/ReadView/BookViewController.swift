import Combine
import UIKit

class BookViewController: UIViewController {
    public let viewModel: BookViewModelProtocol

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "BookViewTableViewCell", bundle: nil), forCellReuseIdentifier: "BookCell")
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
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch()
    }
    
    func transition(selectedBook: Novel) -> Void {
        //[] 値渡し　to chapterViewcontroller
        
        let chapterViewModel = ChapterViewModel(dependency: .default, ncode: selectedBook.ncode)
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookViewTableViewCell {
            
            if let genre: Genre = Genre(rawValue: viewModel.books.value[indexPath.row].genre) {
                cell.genre.text = genre.title
            }
            
            if let biggenre: BigGenre = BigGenre(rawValue: viewModel.books.value[indexPath.row].biggenre) {
                cell.bigGenre.text = biggenre.title
            }
            cell.title.text = viewModel.books.value[indexPath.row].title
            cell.author.text = viewModel.books.value[indexPath.row].writer
            
            return cell
        }
        
        return UITableViewCell()
    }

}

extension BookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transition(selectedBook: viewModel.books.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.books.value.remove(at: indexPath.row)
        if var list = UserDefaults.standard.stringArray(forKey: "novels") {
            list.remove(at: indexPath.row)
            UserDefaults.standard.set(list, forKey: "novels")
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}