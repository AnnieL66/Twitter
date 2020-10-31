//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Yaxin Liu on 10/29/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberofTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets(){
        numberofTweet = 20
        // Initialize url and parameters
        let myurl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberofTweet]
        
        // call API
        TwitterAPICaller.client?.getDictionariesRequest(url: myurl, parameters: myParams, success: { (tweets: [NSDictionary]) in
        
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            // reload the data
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retreive tweet! oh no!!")
        })
    }
    
    func loadMoreTweets(){
        let myurl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberofTweet = numberofTweet + 20
        let myParams = ["counts": numberofTweet]
        
        // call API
        TwitterAPICaller.client?.getDictionariesRequest(url: myurl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }

            // reload the data
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retreive tweet! oh no!!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userName.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string:(user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
