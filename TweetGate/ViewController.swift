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

    
    
    @IBOutlet weak var instructionLbel: UILabel!
    
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
                instructionLbel.text = "one of the fields is empty"
            }
        }else {
            instructionLbel.text = "please fill field"
        }
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
        if sentimentScoreA > sentimentScoreB {
            instructionLbel.text = "\(String(describing: firstTextField.text)) is more popular than \(String(describing: secondTextField.text)) as at \(date) "
        } else {
            instructionLbel.text = "\(String(describing: secondTextField.text)) is more popular than \(String(describing: firstTextField.text)) as at \(date) "

        }
    }
    
    
}

