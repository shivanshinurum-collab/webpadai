import UIKit
import WebKit

final class YouTubePlayerViewController: UIViewController, WKScriptMessageHandler {

    private var webView: WKWebView!
    private var currentVideoID: String?
    var onProgressUpdate: ((Double, Double) -> Void)?
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
        print("message:", message.body)

        guard let str = message.body as? String else { return }

        if let value = Double(str) {
            lastValues.append(value)
            if lastValues.count == 2 {
                let current = lastValues[0]
                let duration = lastValues[1]
                lastValues.removeAll()
                onProgressUpdate?(current, duration)
            }
        }
    }

    private var lastValues: [Double] = []
    
    private var timer: Timer?
    
    func stopProgressTracking() {
        timer?.invalidate()
        timer = nil
    }

    func startProgressTracking() {
        stopProgressTracking()

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            print("polling time")
            self?.webView.evaluateJavaScript("ytGetTime();", completionHandler: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupWebView()

        if let id = currentVideoID {
            loadVideo(id)
            startProgressTracking()
        }
    }

    func load(videoID: String) {
        currentVideoID = videoID

        if webView != nil {
            loadVideo(videoID)
            startProgressTracking()
        }
    }
    
    func play() {
        send("playVideo")
    }

    func pause() {
        send("pauseVideo")
    }

    func mute() {
        send("mute")
    }

    func unmute() {
        send("unMute")
    }

    func seek(to seconds: Double) {
        send("seekTo", args: [seconds, true])
    }

    func setSpeed(_ rate: Double) {
        send("setPlaybackRate", args: [rate])
    }

    func setQuality(_ q: String) {
        send("setPlaybackQuality", args: [q])
    }

    private func send(_ cmd: String, args: [Any] = []) {
        let argsString = args.map { "\($0)" }.joined(separator: ",")
        let js = "yt('\(cmd)', [\(argsString)]);"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        config.websiteDataStore = .default()

        let controller = WKUserContentController()
        controller.add(self, name: "ready")
        controller.add(self, name: "playerTime")
        config.userContentController = controller

        webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadVideo(_ id: String) {

       let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        html, body {
            margin: 0;
            padding: 0;
            background: black;
            overflow: hidden;
            height: 100%;
        }

        #container {
            position: absolute;
            width: 100%;
            height: 120%;
            top: -60px;
            left: 0;
            overflow: hidden;
        }

        iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 120%;
            border: 0;
        }
        </style>
        </head>
        <body>
            <div id="container">
                <iframe
                    id="player"
                        src="https://www.youtube.com/embed/\(id)?enablejsapi=1&playsinline=1&autoplay=1&mute=1&controls=0&rel=0&modestbranding=1&fs=0&iv_load_policy=3&origin=https://localhost"
                    allow="autoplay; encrypted-media; picture-in-picture"
                    allowfullscreen>
                </iframe>
            </div>
        
            <script>
                var player;

                function onYouTubeIframeAPIReady() {
                    player = new YT.Player('player', {
                        events: {}
                    });
                }

                function yt(cmd, args) {
                    if (player) {
                        player[cmd].apply(player, args || []);
                    }
                }

                function ytGetTime() {
                    if (player) {
                        var t = player.getCurrentTime();
                        var d = player.getDuration();

                        window.webkit.messageHandlers.playerTime.postMessage(String(t));
                        window.webkit.messageHandlers.playerTime.postMessage(String(d));
                    }
                }
            </script>

            <script src="https://www.youtube.com/iframe_api"></script>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: URL(string: "https://localhost"))
    }
    
    deinit {
        //stopProgressTracking()
        stopAllProcesses()
        print("YouTubePlayerViewController deallocated")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllProcesses()
    }
    
    
    func stopAllProcesses() {
        
        print("Stopping all YouTube processes")
        
        // 1️⃣ Stop timer
        stopProgressTracking()
        
        // 2️⃣ Pause video
        pause()
        
        // 3️⃣ Stop loading if any
        webView?.stopLoading()
        
        // 4️⃣ Remove script handlers
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "ready")
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "playerTime")
        
        // 5️⃣ Clear delegates (optional but safe)
        webView?.navigationDelegate = nil
        webView?.uiDelegate = nil
    }
    
    
    
}
