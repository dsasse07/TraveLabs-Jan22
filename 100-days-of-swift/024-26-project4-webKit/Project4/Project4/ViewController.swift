//
//  ViewController.swift
//  Project4
//
//  Created by Daniel Sasse on 1/5/22.
//

import UIKit
import WebKit

// Our class extends UIViewController class, and conforms to WKNavigationDelegate protocol
// Classes extend the first thing, the rest are protocols
class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var safeView: UIView!
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["www.apple.com","www.google.com","www.github.com","sasse.vercel.app"]
    var back: UIBarButtonItem!
    var forward: UIBarButtonItem!
    
    /**
    override func loadView() {
        // Create and instance of webview
        webView = WKWebView(frame: safeView.bounds)
        if let webview = webView {
            webview.translatesAutoresizingMaskIntoConstraints = false
            safeView.addSubview(webview)
            let bindings: [String: AnyObject] = ["webView" : webview]
            safeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
            safeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        }
        
        // Assign the views navigation delegate as this
        // Delegation is a programming pattern, used extensively in iOS.
        // It means one thing is acting in place of something else. So here we are saying, when any web navigation occurs,
        // Tell it to use this controller.
        
        // When doing this, the controller must match the protocol of the assigned delegate
        webView.navigationDelegate = self

        // Set the webView as the view for this controller
        safeView = webView
    }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Binds the webview into the subview to remain in safe are and use constraints
        webView = WKWebView(frame: safeView.bounds)
        if let webview = webView {
            webview.translatesAutoresizingMaskIntoConstraints = false
            safeView.addSubview(webview)
            let bindings: [String: AnyObject] = ["webView" : webview]
            safeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
            safeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let flexSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshWebView))
        back = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(goBack))
        forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(goForward))
        
        if !webView.canGoBack {
            back.isEnabled = false
        }
        if !webView.canGoForward{
            forward.isEnabled = false
        }
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, forward, flexSpacer, progressButton, flexSpacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // Force unwrap bc the url was hand typed and we know it was write
        let url = URL(string: "https://" + websites.last!, relativeTo: nil)!
        
        // Create an observer on a key value pair that will indicate when a change is made
        // Takes 4 params:
        // 1. who the observer is (self)
        // 2. What property we want to observer (WKWebView.estimatedProgress)
        //      - uses keypath keyword to tell Swift to confirm that the path is valid
        // 3. What value we want (Here we want the new value just set
        // 4. Context value?
        //      - This gets returned when the change occurs. Can be used to confirm we are seeing the correct change
        
        // NOTE: When a view controller is closed, observers should be removed.
        // After adding an observer, must create a method called observeValue
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)

        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
        
        
        webView.navigationDelegate = self
        // Load the page and permit L/R swipe navigation
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped(){
        let alertController = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alertController, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction){
        guard let domain = action.title else {
            print("Alert did not contain a title")
            return
        }
        guard let url = URL(string: "https://\(domain)", relativeTo: nil) else {
            print("Invalid URL")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath{
            case "estimatedProgress":
                progressView.progress = Float(webView.estimatedProgress)
            case "canGoBack":
                back.isEnabled = webView.canGoBack
            case "canGoForward":
                forward.isEnabled = webView.canGoForward
            default:
                return
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        func cancelRequest(action: UIAlertAction! = nil) { decisionHandler(.cancel) }
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
//        let alertController = UIAlertController(title: "Blocked", message: "Sorry, this website is not on the approved list", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelRequest))
//        present(alertController, animated: true, completion: nil)
    }
    
    @objc func refreshWebView(sender: UIRefreshControl?){
        webView.reload()
    }
    @objc func goBack(){
        webView.goBack()
    }
    @objc func goForward(){
        webView.goForward()
    }
}

