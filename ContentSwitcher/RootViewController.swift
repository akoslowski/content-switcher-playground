import OSLog
import UIKit

final class RootViewController: ColorViewController {

    let tableView = UITableView()

    let containerChildViewControllers = [
        UIColor.systemRed.makeViewController(),
        UIColor.systemOrange.makeViewController(),
        UIColor.systemYellow.makeViewController(),
        UIColor.systemGreen.makeViewController(),
        UIColor.systemBlue.makeViewController(),
        UIColor.systemIndigo.makeViewController(),
        UIColor.systemPurple.makeViewController(),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true

        setUpMenuButton()
        setUpTableView()
    }

    func setUpMenuButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis"),
            primaryAction: nil,
            menu: makeMenu(
                viewControllers: containerChildViewControllers,
                onSelect: { [weak self] index in
                    self?.showContainerViewController(selectedIndex: index)
                }
            )
        )
    }

    func showContainerViewController(selectedIndex: Int) {
        let viewController = ContainerViewController(
            viewControllers: containerChildViewControllers,
            initialIndex: selectedIndex
        )
        show(viewController, sender: self)
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        containerChildViewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)

        let viewController = containerChildViewControllers[indexPath.row]

        cell.textLabel?.text = viewController.title
        cell.textLabel?.textColor = UIColor(white: 1, alpha: 0.9)
        cell.textLabel?.font = .preferredFont(forTextStyle: .title1)
        cell.backgroundColor = viewController.color
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showContainerViewController(selectedIndex: indexPath.row)
    }
}
