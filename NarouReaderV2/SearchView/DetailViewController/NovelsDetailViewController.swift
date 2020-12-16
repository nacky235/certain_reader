import Combine
import UIKit
import SafariServices

class NovelsDetailViewController: UIViewController {
    public let viewModel: NovelsDetailViewModelProtocol

    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bigGenreLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    
    init(viewModel: NovelsDetailViewModelProtocol) {
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
        
        configure()

        // Do any additional setup after loading the view.
    }
    
    func configure() {
        titleLabel?.text = viewModel.novel.title
        authorLabel?.text = viewModel.novel.writer
        // [] make biggenre and genre readable by enum?
        bigGenreLabel?.text = viewModel.novel.biggenre.description
        genreLabel?.text = viewModel.novel.genre.description
        storyLabel?.text = viewModel.novel.story
    }
    @objc func addToShelf() {
        if var list = UserDefaults.standard.stringArray(forKey: "novels") {
            if list.filter({ $0 == viewModel.novel.ncode }) == [] {
                list.append(viewModel.novel.ncode)
            }
            UserDefaults.standard.set(list, forKey: "novels")
        } else {
            UserDefaults.standard.setValue([viewModel.novel.ncode], forKey: "novels")
        }
        
    }
}
