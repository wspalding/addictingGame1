//
//  GameViewController.swift
//  RainBowWalls2
//
//  Created by William Spalding on 1/27/17.
//  Copyright © 2017 William Spalding. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    var sceneInstance = GameScene()
    var highScoreList = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0] ,[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
    
    @IBOutlet weak var spacelabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        sceneInstance = scene
        
        if let highScores = UserDefaults.standard.object(forKey: "myHighscores") as? [[Int]]
        {
            highScoreList = highScores
        }
        
        difficultyLabel.text = difficultyText
        hightScoreLabel.text = highScoreText
        spacelabel.isHidden = true
        

    }

    //@IBOutlet weak var clearButton: UIButton!
    //@IBAction func clearButtonPressed(_ sender: UIButton)
    //{
        //sceneInstance.clearWalls()
    //}
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButtonPressed(_ sender: UIButton)
    {
        startButton.isHidden = true
        //clearButton.isHidden = true
        difficultyLabel.isHidden = true
        incramentDifficultyLabel.isHidden = true
        upButton.isHidden = true
        downButton.isHidden = true
        hightScoreLabel.isHidden = true
        
        sceneInstance.isGameOver = false
        startTimer()
    }
    
    //an array for each difficulty

//    var highScoreList: [[Int]] {
//        if let highScores = UserDefaults.standard.object(forKey: "myHighscores") as? [[Int]]
//        {
//            return highScores
//        }
//        else
//        {
//            return [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],
//            [0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
//        }
//    }
    
    var difficultyText : String
    {
        return " \(difficultyNames[Int(sceneInstance.difficulty)]) "
    }
    
    var highScoreText : String
    {
        var text = "High Scores: \n"
        var i = 0
        while(i < 5)
        {
            text += "\(highScoreList[Int(sceneInstance.difficulty)][i]) "
            if(i < 4)
            {
                text += "\n"
            }
            i += 1
        }
        return text
    }
    
    func updateHighScore()
    {
        if(seconds > highScoreList[Int(sceneInstance.difficulty)][4])
        {
            let temp = seconds
            var i = 0
            while(i < 5)
            {
                if(seconds > highScoreList[Int(sceneInstance.difficulty)][i])
                {
                    let temp2 = highScoreList[Int(sceneInstance.difficulty)][i]
                    highScoreList[Int(sceneInstance.difficulty)][i] = seconds
                    seconds = temp2
                }
                i += 1
            }
            seconds = temp
        }
        UserDefaults.standard.set(highScoreList, forKey: "myHighscores")
    }
    
    @IBOutlet weak var hightScoreLabel: UILabel!
    @IBAction func difficultyUp(_ sender: UIButton)
    {
        if(sceneInstance.difficulty >= 0 && sceneInstance.difficulty < 10)
        {
            sceneInstance.difficulty += 1
            difficultyLabel.text = difficultyText
            hightScoreLabel.text = highScoreText
        }
    }
    @IBAction func difficultyDown(_ sender: UIButton)
    {
        if(sceneInstance.difficulty > 0 && sceneInstance.difficulty <= 10)
        {
            sceneInstance.difficulty -= 1
            difficultyLabel.text = difficultyText
            hightScoreLabel.text = highScoreText
        }
    }
    @IBOutlet weak var difficultyLabel: UILabel!
    let difficultyNames = ["nothing", "easy" , "less easy", "not easy" , "medium" ,
                           "not hard" , "hard" , "harder" , "very hard" ,"even harder" , "don't be bad"]
    @IBOutlet weak var incramentDifficultyLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    var seconds = 0
    var timer = Timer()
    func startTimer()
    {
        seconds = 0
        timerLabel.text = "Time: \(seconds)"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.countUp), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    @objc func countUp()
    {
        if(sceneInstance.isGameOver)
        {
            stopTimer()
            startButton.isHidden = false
            //clearButton.isHidden = false
            difficultyLabel.isHidden = false
            incramentDifficultyLabel.isHidden = false
            upButton.isHidden = false
            downButton.isHidden = false
            hightScoreLabel.isHidden = false
            updateHighScore()
            hightScoreLabel.text = highScoreText
        }
        else
        {
            seconds += 1
            timerLabel.text = "Time: \(seconds)"
        }
    }
    func stopTimer()
    {
        timer.invalidate()
        //TimerLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) //load highscores
    {
        if let highScores = UserDefaults.standard.object(forKey: "myHighscores") as? [[Int]]
        {
            highScoreList = highScores
        }
    }
    
    
    
    override var shouldAutorotate: Bool
    {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return .allButUpsideDown
        } else {return .all}
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool
    {
        return true
    }
}
