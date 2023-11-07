import UIKit
import SwiftUI
import OSLog

func makeMenu(
    viewControllers: [UIViewController],
    onSelect selection: @escaping (Int) -> Void
) -> UIMenu {
    let menuItems = viewControllers
        .compactMap { $0.title }
        .enumerated()
        .map { index, item in
            UIAction(
                title: item,
                image: UIImage(systemName: "magnifyingglass"),
                state: .off
            ) { action in
                selection(index)
            }
        }

    // https://developer.apple.com/wwdc20/10052
    return UIMenu(
            title: "Search Domains",
            subtitle: nil,
            image: nil,
            identifier: nil,
            options: [], // .singleSelection
            preferredElementSize: UIMenu.ElementSize.large,
            children: menuItems
        )
}

func makeSearchViewControllers() -> [UIViewController] {
    [
        JobSearchViewController(),
        MemberSearchViewController(),
        CompanySearchViewController(),
        NewsSearchViewController(),
        MessageSearchViewController()
    ]
}

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

        // https://developer.apple.com/wwdc20/10052
        self.searchButton = .init(
            systemItem: .search,
            primaryAction: nil,
            menu: makeMenu(
                viewControllers: viewControllers,
                onSelect: { [weak self] index in
                    self?.didSelectItem(atIndex: index)
                }
            )
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        lifecycle.info("\(Self.self).\(#function)")
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
