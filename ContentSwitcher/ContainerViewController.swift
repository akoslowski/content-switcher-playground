import OSLog
import UIKit

@MainActor func makeMenu(
    viewControllers: [UIViewController],
    onSelect selection: @escaping (Int) -> Void
) -> UIMenu {
    let menuItems =
        viewControllers
        .compactMap { $0.title }
        .enumerated()
        .map { index, item in
            UIAction(
                title: item,
            ) { action in
                selection(index)
            }
        }
    return UIMenu(
        title: "Colors",
        subtitle: nil,
        image: nil,
        identifier: nil,
        options: [],
        preferredElementSize: UIMenu.ElementSize.large,
        children: menuItems
    )
}

final class ContainerViewController: UIViewController {
    private let logger = Logger()

    private(set) var viewControllers: [UIViewController]
    private(set) var initialViewControllerIndex: Int
    private weak var currentViewController: UIViewController?

    private var menuButton: UIBarButtonItem!

    init(viewControllers: [UIViewController], initialIndex: Int = 0) {
        logger.info("\(Self.self).\(#function)")

        self.viewControllers = viewControllers
        self.initialViewControllerIndex = initialIndex
        super.init(nibName: nil, bundle: nil)

        // https://developer.apple.com/wwdc20/10052
        self.menuButton = .init(
            title: nil,
            image: UIImage(systemName: "ellipsis"),
            primaryAction: nil,
            menu: makeMenu(
                viewControllers: viewControllers,
                onSelect: { [weak self] index in
                    self?.didSelectItem(atIndex: index)
                }
            )
        )

        updateSelectedMenuItem(at: initialIndex)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.info("\(Self.self).\(#function)")
    }

    override func viewDidLoad() {
        logger.info("\(Self.self).\(#function)")
        super.viewDidLoad()

        let initialViewController = viewControllers[initialViewControllerIndex]
        setCurrentViewController(initialViewController)

        navigationItem.rightBarButtonItem = menuButton
    }

    func updateSelectedMenuItem(at index: Int) {
        menuButton.menu?.children.enumerated().forEach { item in
            if let action = item.element as? UIAction {
                action.state = item.offset == index ? .on : .off
            }
        }
    }

    func didSelectItem(atIndex index: Int) {
        let title = viewControllers[index].title ?? "no-title-found"
        logger.info("\(Self.self).\(#function): \(index), \(title)")
        initialViewControllerIndex = index
        updateSelectedMenuItem(at: index)

        if let menuItems = menuButton.menu?.children, let item = menuItems[index] as? UIAction {
            item.state = .on
        }

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
            baseView.trailingAnchor.constraint(equalTo: childView.trailingAnchor),
        ])
    }

    func deactivateConstraints(of baseView: UIView, on childView: UIView) {
        NSLayoutConstraint.deactivate([
            baseView.topAnchor.constraint(equalTo: childView.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: childView.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: childView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: childView.trailingAnchor),
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

        // transition(from:to:duration:options:animations:completion:) will
        // add the view of the toViewController to the view hierachy!
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

    override func transition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        options: UIView.AnimationOptions = [],
        animations: (() -> Void)?,
        completion: ((Bool) -> Void)? = nil
    ) {
        super.transition(
            from: fromViewController,
            to: toViewController,
            duration: duration,
            options: options,
            animations: animations,
            completion: completion
        )
        logger.info("\(Self.self).\(#function)")
    }

    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        logger.info("\(Self.self).\(#function)")
    }
}
