import UIKit
import OSLog

final class RootViewController: LoggingViewController {

    private(set) lazy var button: UIButton =
        .init(
            primaryAction: UIAction(
                title: "Open Search",
                image: UIImage(systemName: "magnifyingglass")
            ) { [weak self] action in
                /**
                 - SearchContext stores information in e.g. UserDefaults.

                 ```
                 let searchContext = SearchContext()

                 JobSearchViewController(context: searchContext)
                 ```
                 */
                guard let self else { return }

                let searchContainerViewController = SearchContainerViewController(
                    viewControllers: makeSearchViewControllers(),
                    initialIndex: 0
                )
                self.show(searchContainerViewController, sender: self)
            }
        )

    init() {
        super.init(title: "Root")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(button)

        navigationItem.rightBarButtonItem = .init(
            systemItem: .search,
            primaryAction: nil,
            menu: makeMenu(
                viewControllers: makeSearchViewControllers(),
                onSelect: { [weak self] index in
                    guard let self else { return }
                    let searchContainerViewController = SearchContainerViewController(
                        viewControllers: makeSearchViewControllers(),
                        initialIndex: index
                    )
                    self.show(searchContainerViewController, sender: nil)
                }
            )
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: button.topAnchor),
            view.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
    }
}
