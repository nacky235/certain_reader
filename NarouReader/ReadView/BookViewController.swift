import Combine
import UIKit

class BookViewController: UIViewController {
    public let viewModel: BookViewModelProtocol
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "NovelTableViewCell", bundle: nil), forCellReuseIdentifier: "NovelCell")
            tableView.register(UINib(nibName: "EmptyStateTableViewCell", bundle: nil), forCellReuseIdentifier: "GentleCell")
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
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
        self.title = "保存済みの小説"
        
        subscribe()
    
        loadingView.isHidden = false
        DispatchQueue.main.async {
            self.viewModel.loadNovels {
                
            }
            self.loadingView.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    
    func pushChapterView(selectedBook: Novel) -> Void {
        let chapterViewModel = ChapterViewModel(dependency: .default, ncode: selectedBook.ncode)
        let next = ChapterViewController(viewModel: chapterViewModel)
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func fetch() {
        DispatchQueue.main.async {
            self.viewModel.loadNovels {
                self.refreshControl.endRefreshing()
                self.loadingView.isHidden = true
            }
        }
        tableView.reloadData()
        
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
        
        viewModel.novels
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let vc = tabBarController?.viewControllers?[1]
        tabBarController?.selectedViewController = vc
    }
}

extension BookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.novels.value.isEmpty {
            return 1
        }
        return viewModel.novels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.novels.value.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GentleCell", for: indexPath) as? EmptyStateTableViewCell {
                cell.view.bounds = CGRect(origin: CGPoint(x: 0, y: -(navigationController?.navigationBar.bounds.height)!), size: tableView.bounds.size)
                tableView.allowsSelection = false
                cell.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside) 
                cell.sizeToFit()
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NovelCell", for: indexPath) as? NovelTableViewCell {
                
                tableView.allowsSelection = true
                cell.textLabel?.text = viewModel.novels.value[indexPath.row].title
                guard let genre: Genre = Genre(rawValue: viewModel.novels.value[indexPath.row].genre) else { return cell }
                cell.detailTextLabel?.text = genre.title
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension BookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = UserDefaults.standard.stringArray(forKey: "novels") {
            var sortedList = list.filter { $0 != viewModel.novels.value[indexPath.row].ncode }
            sortedList.insert(viewModel.novels.value[indexPath.row].ncode, at: 0)
            UserDefaults.standard.set(sortedList, forKey: "novels")
        }
        pushChapterView(selectedBook: viewModel.novels.value[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vm = NovelsDetailViewModel(dependency: .default, novel: viewModel.novels.value[indexPath.row])
        let vc = NovelsDetailViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if viewModel.novels.value.isEmpty {
//
//            return
//        }
//        if let list = UserDefaults.standard.stringArray(forKey: "novels") {
//            let committedTitle = viewModel.novels.value[indexPath.row].ncode
//            let newList = list.filter({ $0 != committedTitle })
//            UserDefaults.standard.set(newList, forKey: "novels")
//            viewModel.novels.value.remove(at: indexPath.row)
//        }
//    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        guard let list = UserDefaults.standard.stringArray(forKey: "novels"), list != [] else {
            return nil }
        
//            // シェアのアクションを設定する
//            let shareAction = UIContextualAction(style: .normal  , title: "share") {
//                (ctxAction, view, completionHandler) in
//                 print("シェアを実行する")
//                completionHandler(true)
//            }
//            // シェアボタンのデザインを設定する
//            let shareImage = UIImage(systemName: "square.and.arrow.up")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
//            shareAction.image = shareImage
//            shareAction.backgroundColor = UIColor(red: 0/255, green: 125/255, blue: 255/255, alpha: 1)

            // 削除のアクションを設定する
            let deleteAction = UIContextualAction(style: .destructive, title:"delete") {
                (ctxAction, view, completionHandler) in
                
                let committedTitle = self.viewModel.novels.value[indexPath.row].ncode
                let newList = list.filter({ $0 != committedTitle })
                UserDefaults.standard.set(newList, forKey: "novels")
                self.viewModel.novels.value.remove(at: indexPath.row)
                completionHandler(true)
            }
            // 削除ボタンのデザインを設定する
            let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
            deleteAction.image = trashImage
            deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)

            // スワイプでの削除を無効化して設定する
            let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
            swipeAction.performsFirstActionWithFullSwipe = false
            
            return swipeAction

        }
}
