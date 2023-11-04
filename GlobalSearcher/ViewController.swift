import UIKit
import SwiftUI
import OSLog

/**
 https://developer.apple.com/documentation/uikit/view_controllers/creating_a_custom_container_view_controller
 */

final class SearchContainerViewController: UIViewController {
    private let interaction = Logger(subsystem: "SearchContainerViewController", category: "Interaction")
    private let lifecycle = Logger(subsystem: "SearchContainerViewController", category: "Lifecycle")

    private(set) var viewControllers: [UIViewController]
    private(set) var initialViewControllerIndex: Int
    private weak var currentViewController: UIViewController?

    private var searchButton: UIBarButtonItem!

    init(viewControllers: [UIViewController], initialIndex: Int = 0) {
        lifecycle.info("\(Self.self).\(#function)")

        self.viewControllers = viewControllers
        self.initialViewControllerIndex = initialIndex
        super.init(nibName: nil, bundle: nil)

        let menuItems = viewControllers
            .compactMap { $0.title }
            .enumerated()
            .map { index, item in
                UIAction(
                    title: item,
                    image: UIImage(systemName: "magnifyingglass"),
                    state: index == initialIndex ? .on : .off
                ) { [weak self] action in
                    self?.didSelectItem(atIndex: index)
                }
            }

        // https://developer.apple.com/wwdc20/10052
        self.searchButton = .init(
            systemItem: .search,
            primaryAction: nil,
            menu: UIMenu(
                title: "Search Domains",
                subtitle: nil,
                image: nil,
                identifier: nil,
                options: [.singleSelection],
                preferredElementSize: UIMenu.ElementSize.large,
                children: menuItems
            )
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        lifecycle.info("\(Self.self).\(#function)")
        super.viewDidLoad()

        let initialViewController = viewControllers[initialViewControllerIndex]
        setCurrentViewController(initialViewController)

        navigationItem.rightBarButtonItem = searchButton
    }

    func didSelectItem(atIndex index: Int) {
        let title = viewControllers[index].title ?? "no-title-found"
        interaction.info("\(Self.self).\(#function): \(index), \(title)")

        guard let currentViewController else { preconditionFailure("currentViewController must be set") }

        replace(currentViewController, with: viewControllers[index])
    }

    @MainActor func setCurrentViewController(_ childViewController: UIViewController) {
        guard let childView = childViewController.view else {
            preconditionFailure("Cannot get view form given view controller")
        }

        // forwards the new title to the custom container
        self.title = childViewController.title

        currentViewController = childViewController

        addChild(childViewController)
        childViewController.didMove(toParent: self)
        view.addSubview(childView)

        activateConstraints(of: view, on: childView)
    }

    func activateConstraints(of baseView: UIView, on childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: childView.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: childView.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: childView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: childView.trailingAnchor)
        ])
    }

    func deactivateConstraints(of baseView: UIView, on childView: UIView) {
        NSLayoutConstraint.deactivate([
            baseView.topAnchor.constraint(equalTo: childView.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: childView.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: childView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: childView.trailingAnchor)
        ])
    }

    @MainActor func replace(
        _ fromViewController: UIViewController,
        with toViewController: UIViewController,
        duration: TimeInterval = 0.25
    ) {
        if fromViewController === toViewController { return }

        // forwards the new title to the custom container
        self.title = toViewController.title

        currentViewController = toViewController
        addChild(toViewController)

        // transition(from:to:duration:options:animations:completion:) will add the view of the toViewController to the view hierachy!
        transition(
            from: fromViewController,
            to: toViewController,
            duration: duration,
            options: .transitionCrossDissolve
        ) {
            self.deactivateConstraints(of: self.view, on: fromViewController.view)

            self.activateConstraints(of: self.view, on: toViewController.view)

            self.view.bringSubviewToFront(toViewController.view)

        } completion: { finished in
            fromViewController.removeFromParent()

            // notify the child view controller that the move was completed
            toViewController.didMove(toParent: self)
        }
    }

    override func transition(from fromViewController: UIViewController, to toViewController: UIViewController, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        super.transition(from: fromViewController, to: toViewController, duration: duration, options: options, animations: animations, completion: completion)
        lifecycle.info("\(Self.self).\(#function)")
    }

    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        lifecycle.info("\(Self.self).\(#function)")
    }
}

// MARK: - Child View Controllers -

struct JobSearchView: View {
    var body: some View {
        VStack {
            List(0..<100) {
                Text("\($0)")
            }
        }
        .navigationTitle("Search Jobs (SwiftUI)")
    }
}

final class JobSearchViewController: UIHostingController<JobSearchView> {
    private let lifecycle: Logger!

    init() {
        lifecycle = Logger(subsystem: "\(Self.self)", category: "Lifecycle")
        lifecycle.info("\(Self.self).\(#function)")
        super.init(rootView: JobSearchView())
        title = "Search Jobs"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycle.info("\(Self.self).\(#function)")
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycle.info("\(Self.self).\(#function)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycle.info("\(Self.self).\(#function)")
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        lifecycle.info("\(Self.self).\(#function); parent: \(parent)")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        lifecycle.info("\(Self.self).\(#function); parent: \(parent)")
    }

    override func removeFromParent() {
        super.removeFromParent()
        lifecycle.info("\(Self.self).\(#function)")
    }

    deinit {
        lifecycle.info("\(Self.self).\(#function)")
    }
}

final class MemberSearchViewController: LoggingViewController {
    init() {
        super.init(title: "Search Members", backgroundColor: .systemRed)
    }
}

final class CompanySearchViewController: LoggingViewController {
    init() {
        super.init(title: "Search Companies", backgroundColor: .systemMint)
    }
}

final class NewsSearchViewController: LoggingViewController {
    init() {
        super.init(title: "Search News", backgroundColor: .systemYellow)
    }
}

final class MessageSearchViewController: LoggingViewController {
    init() {
        super.init(title: "Search Messages", backgroundColor: .systemTeal)
    }
}

final class RootViewController: LoggingViewController {
    private(set) lazy var button: UIButton! = {
        .init(
            primaryAction: UIAction.init(
                title: "Open Search",
                image: UIImage(systemName: "magnifyingglass")
            ) { [weak self] action in
                let searchContainerViewController = SearchContainerViewController(
                    viewControllers: [
                        JobSearchViewController(),
                        MemberSearchViewController(),
                        CompanySearchViewController(),
                        NewsSearchViewController(),
                        MessageSearchViewController()
                    ],
                    initialIndex: 3
                )
                self?.show(searchContainerViewController, sender: self)
            })
    }()

    init() {
        super.init(title: "Root")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: button.topAnchor),
            view.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
    }
}

class LoggingViewController: UIViewController {
    private let lifecycle: Logger!
    let backgroundColor: UIColor

    init(title: String, backgroundColor: UIColor = .white) {
        lifecycle = Logger(subsystem: "\(Self.self)", category: "Lifecycle")
        lifecycle.info("\(Self.self).\(#function)")
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     WOT???

     Compiling failed: method '__preview__viewDidLoad()' with Objective-C selector '__preview__viewDidLoad' conflicts with method '__preview__viewDidLoad()' from superclass 'LoggingViewController' with the same Objective-C selector

         @__swiftmacro_50GlobalSearcher_PreviewReplacement_ViewController_133_799BAA2E55AA9E211BD324D3BED9BBB6Ll0C0fMf_.swift
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycle.info("\(Self.self).\(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycle.info("\(Self.self).\(#function)")
        view.backgroundColor = backgroundColor
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycle.info("\(Self.self).\(#function)")
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        lifecycle.info("\(Self.self).\(#function); parent: \(parent)")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        lifecycle.info("\(Self.self).\(#function); parent: \(parent)")
    }

    override func removeFromParent() {
        super.removeFromParent()
        lifecycle.info("\(Self.self).\(#function)")
    }

    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        lifecycle.info("\(Self.self).\(#function)")
    }

    override func endAppearanceTransition() {
        super.endAppearanceTransition()
        lifecycle.info("\(Self.self).\(#function)")
    }

    deinit {
        lifecycle.info("\(Self.self).\(#function)")
    }
}

//@available(iOS 17, *)
//#Preview(traits: .portrait, body: {
//    UINavigationController(rootViewController: RootViewController())
//})
