@testable import podcasts
import XCTest

final class BackgroundSignOutListenerTests: XCTestCase {
    private var signOutListener: BackgroundSignOutListener!
    private var notificationCenter: NotificationCenter!
    private var presentingController: MockPresentingViewController!
    private var navigationManager: MockNavigationManager!

    override func setUp() {
        notificationCenter = NotificationCenter()
        presentingController = MockPresentingViewController()
        navigationManager = MockNavigationManager()

        signOutListener = BackgroundSignOutListener(notificationCenter: notificationCenter,
                                                    presentingViewController: presentingController,
                                                    navigationManager: navigationManager)
    }

    func testSignOutAlertShowsWhenNotUserInitiated() {
        notificationCenter.post(name: TestConstants.signOutNotification, object: nil, userInfo: ["user_initiated": false])

        XCTAssertTrue(presentingController.didPresent)
    }

    func testAlertDoesNotShowWhenUserInitiated() {
        notificationCenter.post(name: TestConstants.signOutNotification, object: nil, userInfo: ["user_initiated": true])
        XCTAssertFalse(presentingController.didPresent)
    }

    func testSignOutAlertDoesNotShowMoreThanOnce() {
        notificationCenter.post(name: TestConstants.signOutNotification, object: nil, userInfo: ["user_initiated": false])
        notificationCenter.post(name: TestConstants.signOutNotification, object: nil, userInfo: ["user_initiated": false])

        XCTAssertEqual(presentingController.presentCount, 1)
    }

    func testSignOutAlertActionWillOpenSignIn() {
        // Trigger the show sign in action
        signOutListener.showSignIn()

        XCTAssertEqual(NavigationManager.signInPage, navigationManager.navigatedPlace)
    }

    private enum TestConstants {
        static let signOutNotification = NSNotification.Name("Server.User.WillBeSignedOut")
    }
}

private class MockNavigationManager: NavigationManager {
    var navigatedPlace: String?
    var navigatedData: NSDictionary?

    override func navigateTo(_ place: String, data: NSDictionary?) {
        navigatedPlace = place
        navigatedData = data
    }
}

private class MockPresentingViewController: UIViewController {
    var didPresent = false
    var presentCount = 0
    var presentedController: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedController = viewControllerToPresent

        didPresent = true
        presentCount += 1
    }
}
