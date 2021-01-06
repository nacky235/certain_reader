import Combine
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "detailTableViewCell", bundle: nil), forCellReuseIdentifier: "detailCell")
            tableView.register(UINib(nibName: "SwitcherTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitcherCell")
        }
    }
    
    public let viewModel: SettingViewModelProtocol

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SettingViewModelProtocol) {
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

        // Do any additional setup after loading the view.
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "設定"
        case 1:
            return "その他"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SwitcherCell") as? SwitcherTableViewCell {
                    cell.textLabel?.text = "ダークモード"
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SwitcherCell") as? SwitcherTableViewCell {
                    cell.textLabel?.text = "R18版を表示"
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SwitcherCell") as? SwitcherTableViewCell {
                    cell.textLabel?.text = "R18版を表示"
                    return cell
                }
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? detailTableViewCell {
                    cell.textLabel?.text = "ライセンス"
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? detailTableViewCell {
                    cell.textLabel?.text = "ライセンス"
                    return cell
                }
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}
