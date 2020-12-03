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
    @IBAction func readButton(_ sender: Any) {
        getNovel(ncode: viewModel.novel.ncode, episodeNumber: 1) { cts in
            
            let viewModel = NovelViewModel(content: cts)
            let vc = NovelViewController(viewModel: viewModel)
            self.present(vc, animated: true, completion: nil)
        }

            
    }
}
