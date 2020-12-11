import Combine
import UIKit
import WebKit

class MainViewController: UIViewController {
    public let viewModel: MainViewModelProtocol

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "なろうリーダーv2.0"

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
        
        
    }
    
    @IBAction func readButtonTapped(_ sender: Any) {
        let viewModel = BookViewModel(dependency: .default)
        let next = BookViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let viewModel = SearchViewModel(dependency: .default)
        let next = SearchViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func testButtonTapped(_ sender: Any) {
        let viewModel = WebViewModel(dependency: .default)
        let next = WebViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}
