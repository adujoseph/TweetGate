//
//  ViewController.swift
//  TweetGate
//
//  Created by MAC on 01/02/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import CoreML
import  SwiftyJSON
import SwifteriOS

class ViewController: UIViewController {

    
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var secondKeywordLabel: UILabel!
    
    @IBOutlet weak var firstKeywordLabel: UILabel!
    
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var checkAnalysisDefaultState: UIButton!
    
    let sentiments = Sentiments()
    
    var sentimentScoreA = 100
    var sentimentScoreB = 100
    
   
    
    let swifter = Swifter(consumerKey:"f8mQbohJcHwxQgNeim5n6Afp4", consumerSecret: "N3XTd7z7HVFPpp6XOR6XlJioQVGBfWclgntNdKfZNC3tmUI3z5")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }


    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
       
    }
    
    
    @IBAction func checkAnalysisPressed(_ sender: UIButton) {
        
        if firstTextField.text != "" {
            if secondTextField.text  != "" {
                //instructionLbel.text = ""
                first()
                second()
                checkScores()
            } else {
                instructionLabel.text = "one of the fields is empty"
            }
        }else {
            instructionLabel.text = "please fill field"
        }
        
        sentimentScoreA = 100
        sentimentScoreB = 100
    }
    
    func first(){
        swifter.searchTweet(using: firstTextField.text! ,  lang: "en", count: 100,  tweetMode: .extended, success: { (results, metadata) in
            // print(results)
            var tweetsArray = [SentimentsInput]()
            
            for i in 0..<100{
                if let tweet = results[i]["full_text"].string {
                    let sortedTweets = SentimentsInput(text: tweet)
                    tweetsArray.append(sortedTweets)
                }
            }
            do{
                let predictions = try self.sentiments.predictions(inputs: tweetsArray)
                //var sentimentScoreA = 0
                for predicts in predictions{
                    let score = predicts.label
                    if score == "Pos"{
                        self.sentimentScoreA += 1
                    } else if score == "Neg"{
                        self.sentimentScoreA -= 1
                    }
                }
               self.firstKeywordLabel.text = "Relevance score is \(self.sentimentScoreA)"
                print(self.sentimentScoreA)
                //self.firstKeywordLabel.text = String(self.sentimentScore)
            } catch{
                print("Error fetching predictions: \(error)")
            }
            
            
        }) { (error) in
            print("error fetching tweets: \(error)")
        }
    }
    
    func second(){
        swifter.searchTweet(using: secondTextField.text! ,  lang: "en", count: 100,  tweetMode: .extended, success: { (results, metadata) in
            // print(results)
            var tweetsArray = [SentimentsInput]()
            
            for i in 0..<100{
                if let tweet = results[i]["full_text"].string {
                    let sortedTweets = SentimentsInput(text: tweet)
                    tweetsArray.append(sortedTweets)
                }
            }
            do{
                let predictions = try self.sentiments.predictions(inputs: tweetsArray)
                // var sentimentScoreB = 0
                for predicts in predictions{
                    let score = predicts.label
                    if score == "Pos"{
                        self.sentimentScoreB += 1
                    } else if score == "Neg"{
                        self.sentimentScoreB -= 1
                    }
                }
              self.secondKeywordLabel.text = "Relevance score is \(self.sentimentScoreB)"
                print(self.sentimentScoreB)
                //self.firstKeywordLabel.text = String(self.sentimentScore)
            } catch{
                print("Error fetching predictions: \(error)")
            }
            
            
        }) { (error) in
            print("error fetching tweets: \(error)")
        }
    }
    
    func checkScores(){
        
        let date = Date.init()
        if let scoreA = firstTextField.text, let scoreB = secondTextField.text{
            if sentimentScoreA > sentimentScoreB {
                print(sentimentScoreA)
                print("Sentiment Score B: \(sentimentScoreB)")
                instructionLabel.text = "\(scoreA) is more popular than \(scoreB) as at \(date)"
            } else {
                instructionLabel.text = "\(scoreB) is more popular than \(scoreA) as at \(date)"
            }
        }
        
    }
    
    
}

