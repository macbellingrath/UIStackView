//
//  ViewController.swift
//  Multibrowser
//
//  Created by Mac Bellingrath on 8/13/15.
//  Copyright © 2015 Mac Bellingrath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    weak var activeWebView: UIWebView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addWebView")
        let delete = UIBarButtonItem(barButtonSystemItem: .Trash , target: self, action: "deleteWebView")
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    func setDefaultTitle(){
        
            title = "Multibrowser"

        
    }
    func addWebView(){
        
        let webView = UIWebView()
        webView.delegate = self
        
        stackView.addArrangedSubview(webView)
        let url = NSURL(string: "http://www.apple.com")!
        webView.loadRequest(NSURLRequest(URL: url))
        
        webView.layer.borderColor = UIColor.blueColor().CGColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: "webViewTapped:")
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    func deleteWebView(){
        if let webview = activeWebView {
            if let index = stackView.arrangedSubviews.indexOf(webview){
                stackView.removeArrangedSubview(webview)
                
               //important
                webview.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0{
                    setDefaultTitle()
                } else {
                    var currentIndex = Int(index)
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? UIWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    func selectWebView(webView: UIWebView) {
        for view in stackView.arrangedSubviews{
            view.layer.borderWidth = 0
        }
        activeWebView = webView
        webView.layer.borderWidth = 3
        updateUIUsingWebView(webView)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let webView = activeWebView, address = addressBar.text {
            if let url = NSURL(string: address){
                webView.loadRequest(NSURLRequest(URL: url))
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    func webViewTapped(recognizer: UITapGestureRecognizer){
        if let selectedWebView  = recognizer.view as? UIWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func updateUIUsingWebView(webView: UIWebView){
        title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        addressBar.text = webView.request?.URL?.absoluteString ?? ""
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView == activeWebView {
            updateUIUsingWebView(webView)
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.horizontalSizeClass == .Compact {
            stackView.axis = .Vertical
            
        } else {
            stackView.axis = .Horizontal
        }
    }
    


}

