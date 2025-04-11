import SwiftUI
import blinkoo_components
import Combine

@main
struct blinkoo_components_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    let blinkooFeed = BlinkooFeedComponent(originDomain: "https://feed-test.blinkoo.com")
    let blinkooSingleVideo = BlinkooSingleVideoComponent(originDomain: "https://feed-test.blinkoo.com")
    @State var embedView: String? = nil
    
    var body: some View {
        VStack {
            Button("Full Screen Feed") {
                embedView = nil
                presentFeed()
            }
            Button("Full Screen Single Video") {
                embedView = nil
                presentSingleVideo()
            }
            Button("Show Embedded Feed") {
                self.embedView = "feed"
                embedFeed()
            }
            Button("Hide Embedded Feed") {
                self.embedView = nil
                blinkooFeed.close()
            }
            Button("Show Embedded Single Video") {
                self.embedView = "single"
                embedSingleVideo()
            }
            Button("Hide Embedded Single Video") {
                self.embedView = nil
                blinkooSingleVideo.close()
            }
            if (embedView != nil) {
                ViewControllerWrapper(viewController: embedView == "feed" ? blinkooFeed.viewController : blinkooSingleVideo.viewController)
            }
        }
        .padding()
    }
    
    func embedFeed() {
        Task {
            let feedArgs = BlinkooFeedArgs(title: "embed")
            let feedConfiguration = BlinkooFeedConfiguration()
            try await blinkooFeed.show(feedArgs: feedArgs, config: feedConfiguration)
        }
        
    }
    
    func presentFeed() {
        blinkooFeed.close()
        let viewController = blinkooFeed.viewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.isViewOpaque = true
        // Get the RootViewController.
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }
        Task {
            let feedArgs: BlinkooFeedArgs = BlinkooFeedArgs(title: "example title")
            let config = BlinkooFeedConfiguration(isCreatorEnabled: true)
            try await blinkooFeed.showFullScreen(rootViewController: rootViewController, animated: false, feedArgs: feedArgs, config: config)
        }
    }
    
    func embedSingleVideo() {
        Task {
            let postArgs = BlinkooSingleVideoArgs(title: "embed", postId: "73389653-106c-48dc-b54d-e49faa027e60")
            let feedConfiguration = BlinkooFeedConfiguration()
            try await blinkooSingleVideo.show(postArgs: postArgs, config: feedConfiguration)
        }
        
    }
    
    func presentSingleVideo() {
        blinkooSingleVideo.close()
        let viewController = blinkooSingleVideo.viewController
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.isViewOpaque = true
        // Get the RootViewController.
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }
        Task {
            let postArgs = BlinkooSingleVideoArgs(title: "single example", postId: "73389653-106c-48dc-b54d-e49faa027e60")
            let config = BlinkooFeedConfiguration(isCreatorEnabled: true)
            try await blinkooSingleVideo.showFullScreen(rootViewController: rootViewController, animated: false, postArgs: postArgs, config: config)
        }
    }
}

import SwiftUI
import UIKit

struct ViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
