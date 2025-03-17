

import UIKit

class PinReviewTableViewController: UIViewController {
//    private let coreData = CoreDataManager()
//    private lazy var datasource: [Content] = coreData.fetchContents()
    private lazy var datasource: [ReviewEntity] = [ReviewEntity(id: UUID(), pinID: UUID(), data: Date(), weather: "맑음", mediaPath: "something", description: "it's my life")]
    private var tableView: UITableView!
    private let emptyView: EmptyGuideView = {
        let view = EmptyGuideView(
            systemImage: UIImage(systemName: "text.document"),
            title: "메모가 없습니다.",
            message: "오른쪽 위 \"+\" 버튼을 눌러 메모를 추가하세요"
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Memo"
        
        setupTableView()
        setupLayout()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .infinite, style: .grouped)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupLayout() {
        [tableView, emptyView].forEach{ view.addSubview($0) }

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Delegate
extension PinReviewTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            if let deleted = self?.datasource.remove(at: indexPath.row).id {
//                self?.coreData.deleteContent(id: deleted)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datasource.isEmpty {
            tableView.isHidden = true
            emptyView.isHidden = false
            return 0
        }
        else {
            tableView.isHidden = false
            emptyView.isHidden = true
            return datasource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = datasource[indexPath.row].description
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
        ])
        
        return cell
        
    }
}


#Preview {
    PinReviewTableViewController()
}
