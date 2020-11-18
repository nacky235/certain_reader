import Combine
import UIKit

class NovelViewController: UIViewController {
    private let viewModel: NovelViewModelProtocol

    @IBOutlet private weak var textField: UITextView!

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
        
        viewModel.chapter
            .receive(on: RunLoop.main)
            .sink { [weak self] ch in
                self?.textField?.text = ch.content
            }
            .store(in: &cancellables)
    }
}
