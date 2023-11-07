import UIKit
import SwiftUI
import OSLog

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

open class LoggingViewController: UIViewController {
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
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     WOT???

     Compiling failed: method '__preview__viewDidLoad()' with Objective-C selector '__preview__viewDidLoad' conflicts with method '__preview__viewDidLoad()' from superclass 'LoggingViewController' with the same Objective-C selector

         @__swiftmacro_50GlobalSearcher_PreviewReplacement_ViewController_133_799BAA2E55AA9E211BD324D3BED9BBB6Ll0C0fMf_.swift
     */
    open override func viewDidLoad() {
        super.viewDidLoad()
        lifecycle.info("\(Self.self).\(#function)")
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycle.info("\(Self.self).\(#function)")
        view.backgroundColor = backgroundColor
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycle.info("\(Self.self).\(#function)")
    }

    open override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        lifecycle.info("\(Self.self).\(#function); parent: \(parent)")
    }

    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        lifecycle.info("\(Self.self).\(#function); parent: \(parent)")
    }

    open override func removeFromParent() {
        super.removeFromParent()
        lifecycle.info("\(Self.self).\(#function)")
    }

    open override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        lifecycle.info("\(Self.self).\(#function)")
    }

    open override func endAppearanceTransition() {
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
