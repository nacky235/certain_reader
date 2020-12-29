import Combine
import UIKit
import WebKit

class NovelViewController: UIViewController {
    private let viewModel: NovelViewModelProtocol

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            tableView.register(UINib(nibName: "ToNextTableViewCell", bundle: nil), forCellReuseIdentifier: "toNext")
        }
    }
    

    private var cancellables = Set<AnyCancellable>()
    

    init(viewModel: NovelViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGestures()
        configureNavigationBar()
        
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
        
        viewModel.content
            .receive(on: RunLoop.main)
            .sink { [weak self] ch in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
            
    }
    
    
    @objc func close () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            toNextContent()
        case .right:
            toLastContent()
        default:
            break
        }
    }
    
    func configureNavigationBar() {
        let rightbarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        self.navigationItem.rightBarButtonItem = rightbarButtonItem
        self.navigationItem.title = viewModel.chapter.value.title
        self.navigationItem.hidesBackButton = true
    }
    
    func configureGestures() {
        //swipe left
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        
        //swipe right
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
    }
}

extension NovelViewController: UITableViewDelegate {
    
}

extension NovelViewController: UITableViewDataSource, ToNextContent {
    func toNextContent() {
        if let currentChapterLink = URL(string: viewModel.chapter.value.link), let ep = Int(currentChapterLink.lastPathComponent) {
            
            let nextEp = ep + 1
            let nextChapterLink = currentChapterLink.deletingLastPathComponent().appendingPathComponent(nextEp.description, isDirectory: true)
            let chapter = Chapter(link: nextChapterLink.absoluteString)
            
            let vm = NovelViewModel(chapter: chapter)
            let vc = NovelViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func toLastContent() {
        if let currentChapterLink = URL(string: viewModel.chapter.value.link), let ep = Int(currentChapterLink.lastPathComponent), ep != 1 {
            
            let nextEp = ep - 1
            let nextChapterLink = currentChapterLink.deletingLastPathComponent().appendingPathComponent(nextEp.description, isDirectory: true)
            let chapter = Chapter(link: nextChapterLink.absoluteString)
            
            let vm = NovelViewModel(chapter: chapter)
            let vc = NovelViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: false)
        } 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.content.value.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case viewModel.content.value.count:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "toNext") as? ToNextTableViewCell {
                cell.delegate = self
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TextTableViewCell {
                cell.label.text = viewModel.content.value[indexPath.row]
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.content.value.count {
            var chapter = viewModel.chapter.value
            chapter.isRead = true
            viewModel.chapter.send(chapter)
        }
    }
    
    
}
