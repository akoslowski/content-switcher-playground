import OSLog
import UIKit

open class ColorViewController: UIViewController {
    private let logger: Logger
    let color: UIColor
    let name: String

    init(color: UIColor = .white) {
        logger = Logger(subsystem: "\(Self.self)", category: "Lifecycle")
        self.color = color
        self.name = color.accessibilityName.capitalized
        super.init(nibName: nil, bundle: nil)
        self.title = name
        logger.info("\(self.name).\(#function)")
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        logger.info("\(self.name).\(#function)")
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.info("\(self.name).\(#function)")
        view.backgroundColor = color
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.info("\(self.name).\(#function)")
    }

    open override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        logger.info("\(self.name).\(#function); parent: \(parent)")
    }

    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        logger.info("\(self.name).\(#function); parent: \(parent)")
    }

    open override func removeFromParent() {
        super.removeFromParent()
        logger.info("\(self.name).\(#function)")
    }

    open override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        logger.info("\(self.name).\(#function)")
    }

    open override func endAppearanceTransition() {
        super.endAppearanceTransition()
        logger.info("\(self.name).\(#function)")
    }

    deinit {
        logger.info("\(self.name).\(#function)")
    }
}

extension UIColor {
    @MainActor func makeViewController() -> ColorViewController {
        ColorViewController(color: self)
    }
}
