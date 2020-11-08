//
//  TweetViewController.swift
//  Twitter
//
//  Created by Yaxin Liu on 11/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetContext: UITextView!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if(!tweetContext.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetContext.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetContext.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
}
