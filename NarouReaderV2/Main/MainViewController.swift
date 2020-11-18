import Combine
import UIKit

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
        title = "Main"

        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem

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
    
    @objc func rightBarButtonTapped() {
        let viewModel = BookViewModel(dependency: .default)
        let second = BookViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(second, animated: true)
    }
}
