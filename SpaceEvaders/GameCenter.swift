//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 7.0, 8.0+
//
//	The MIT License (MIT)
//	Copyright (c) 2014 Tobias Due Munk
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import GameKit
/**
    GameCenter iOS
*/
class GameCenter: NSObject, GKGameCenterControllerDelegate {
    
    /// The local player object.
    let gameCenterPlayer = GKLocalPlayer.localPlayer()
    /// player can use GameCenter
    var canUseGameCenter:Bool = false {
        didSet {
            /* load prev. achievments form Game Center */
            //if canUseGameCenter == true { gameCenterLoadAchievements() }
        }}
    /// Achievements of player
    var gameCenterAchievements=[String:GKAchievement]()
    /// ViewController MainView
    var vc: UIViewController
    
    /**
        Constructor
    */
    init(rootViewController viewC: UIViewController) {
        self.vc = viewC
        super.init()
        loginToGameCenter()
    }
    
    /**
        Login to GameCenter
    */
    func loginToGameCenter() {
        self.gameCenterPlayer.authenticateHandler = {(var gameCenterVC:UIViewController!, var gameCenterError:NSError!) -> Void in
            
            if gameCenterVC != nil {
                self.vc.presentViewController(gameCenterVC, animated: true, completion: { () -> Void in
                    
                })
            } else if self.gameCenterPlayer.authenticated == true {
                //self.self
                self.canUseGameCenter = true
            } else  {
                self.canUseGameCenter = false
            }
            
            if gameCenterError != nil {
                println("Game Center error: \(gameCenterError)")
            }
        }
    }
    /**
        Dismiss Game Center when player open
        :param: GKGameCenterViewController
    
        Override of GKGameCenterControllerDelegate
    */
    internal func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        Load achievement in cache
    */
    private func gameCenterLoadAchievements(){
        if canUseGameCenter == true {
        /* load all prev. achievements for GameCenter for the user to progress can be added */
        var allAchievements=[GKAchievement]()
            
        GKAchievement.loadAchievementsWithCompletionHandler({ (allAchievements, error:NSError!) -> Void in
            if error != nil{
                println("Game Center: could not load achievements, error: \(error)")
            } else {
                for anAchievement in allAchievements  {
                    if let oneAchievement = anAchievement as? GKAchievement {
                        self.gameCenterAchievements[oneAchievement.identifier] = oneAchievement
                    }
                }
            }
        })
        }
    }
    /**
        If achievement is Finished
        :param: achievementIdentifier
    */
    func isAchievementFinished(achievementIdentifier uAchievementId:String) -> Bool{
        if canUseGameCenter == true {
            var lookupAchievement:GKAchievement? = gameCenterAchievements[uAchievementId]
            if let achievement = lookupAchievement {
                if achievement.percentComplete == 100 {
                    return true
                }
            } else {
                gameCenterAchievements[uAchievementId] = GKAchievement(identifier: uAchievementId)
                return isAchievementFinished(achievementIdentifier: uAchievementId)
            }
        }
        return false
    }
    /**
        Add progress to an achievement
    
        :param: Progress achievement Double (ex: 10% = 10.00)
        :param: ID Achievement
    */
    func addProgressToAnAchievement(progress uProgress:Double,achievementIdentifier uAchievementId:String) {
        if canUseGameCenter == true {
            var lookupAchievement:GKAchievement? = gameCenterAchievements[uAchievementId]
            
            if let achievement = lookupAchievement {
                if achievement.percentComplete != 100 {
                    achievement.percentComplete = uProgress
                    
                    if uProgress == 100.0  {
                        /* show banner only if achievement is fully granted (progress is 100%) */
                        achievement.showsCompletionBanner=true
                    }
                    
                    /* try to report the progress to the Game Center */
                    GKAchievement.reportAchievements([achievement], withCompletionHandler:  {(var error:NSError!) -> Void in
                        if error != nil {
                            println("Couldn't save achievement (\(uAchievementId)) progress to \(uProgress) %")
                        }
                    })
                }
                /* Is Finish */
            } else {
                /* never added  progress for this achievement, create achievement now, recall to add progress */
                println("No achievement with ID (\(uAchievementId)) was found, no progress for this one was recoreded yet. Create achievement now.")
                gameCenterAchievements[uAchievementId] = GKAchievement(identifier: uAchievementId)
                /* recursive recall this func now that the achievement exist */
                addProgressToAnAchievement(progress: uProgress, achievementIdentifier: uAchievementId)
            }
        }
    }
    /**
        Reports a given score to Game Center
    
        :param: the Score
        :param: leaderboard identifier
    */
    func reportScore(score uScore: Int,leaderboardIdentifier uleaderboardIdentifier: String ) {
        if canUseGameCenter == true {
            var scoreReporter = GKScore(leaderboardIdentifier: uleaderboardIdentifier)
            scoreReporter.value = Int64(uScore)
            var scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray, {(error : NSError!) -> Void in
                if error != nil {
                    NSLog(error.localizedDescription)
                }
            })
        }
    }
    /**
        Remove One Achievements
    
        :param: ID Achievement
    */
    func resetAchievements(achievementIdentifier uAchievementId:String) {
        if canUseGameCenter == true {
            var lookupAchievement:GKAchievement? = gameCenterAchievements[uAchievementId]
            
            if let achievement = lookupAchievement {
                GKAchievement.resetAchievementsWithCompletionHandler({ (var error:NSError!) -> Void in
                    if error != nil {
                        println("Couldn't Reset achievement (\(uAchievementId))")
                    } else {
                        println("Reset achievement (\(uAchievementId))")
                    }
                })
                
            } else {
                println("No achievement with ID (\(uAchievementId)) was found, no progress for this one was recoreded yet. Create achievement now.")
                gameCenterAchievements[uAchievementId] = GKAchievement(identifier: uAchievementId)
                /* recursive recall this func now that the achievement exist */
                self.resetAchievements(achievementIdentifier: uAchievementId)
            }
        }
    }
    /**
        Remove All Achievements
    */
    func resetAllAchievements() {
        if canUseGameCenter == true {
            
            for lookupAchievement in gameCenterAchievements {
                var achievementID = lookupAchievement.0
                var lookupAchievement:GKAchievement? =  lookupAchievement.1
                
                if let achievement = lookupAchievement {
                    GKAchievement.resetAchievementsWithCompletionHandler({ (var error:NSError!) -> Void in
                        if error != nil {
                            println("Couldn't Reset achievement (\(achievementID))")
                        } else {
                            println("Reset achievement (\(achievementID))")
                        }
                    })
                    
                } else {
                    println("No achievement with ID (\(achievementID)) was found, no progress for this one was recoreded yet. Create achievement now.")
                    gameCenterAchievements[achievementID] = GKAchievement(identifier: achievementID)
                    /* recursive recall this func now that the achievement exist */
                    self.resetAchievements(achievementIdentifier: achievementID)
                }
            }
        }
    }
    /**
        Show Game Center Player
    */
    func showGameCenter() {
        if canUseGameCenter == true {
            var gc = GKGameCenterViewController()
            gc.gameCenterDelegate = self
            self.vc.presentViewController(gc, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Leaderboard", message: "Log in to GameCenter to see scores!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Default, handler: nil))
            vc.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
