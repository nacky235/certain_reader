import Combine
import UIKit

class MainViewController: UIViewController {
    public let viewModel: MainViewModelProtocol

    private var cancellables = Set<AnyCancellable>()
    var addBtn: UIBarButtonItem!

    init(viewModel: MainViewModelProtocol) {
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

        self.title = "Main"

                // addBtnを設置
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onClick))
                self.navigationItem.rightBarButtonItem = addBtn
        
        loadJSON()
        
    }
    
    
    @objc func onClick() {
        let viewModel = ChapterViewModel(dependency: .default)
        let second = ChapterViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(second, animated: true)
    }
}
