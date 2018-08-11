// GCHelper.swift (v. 0.2.6)
//
// Copyright (c) 2015 Jack Cook
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import GameKit

/// Custom delegate used to provide information to the application implementing GCHelper.
public protocol GCHelperDelegate {
    
    /// Method called when a match has been initiated.
    func matchStarted()
    
    /// Method called when the device received data about the match from another device in the match.
    func match(_ match: GKMatch, didReceiveData: Data, fromPlayer: String)
    
    /// Method called when the match has ended.
    func matchEnded()
}

/// A GCHelper instance represents a wrapper around a GameKit match.
open class GCHelper: NSObject, GKMatchmakerViewControllerDelegate, GKGameCenterControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    /// The match object provided by GameKit.
    open var match: GKMatch!
    
    fileprivate var delegate: GCHelperDelegate?
    fileprivate var invite: GKInvite!
    fileprivate var invitedPlayer: GKPlayer!
    fileprivate var playersDict = [String:AnyObject]()
    fileprivate var presentingViewController: UIViewController!
    
    fileprivate var authenticated = false
    fileprivate var matchStarted = false
    
    /// The shared instance of GCHelper, allowing you to access the same instance across all uses of the library.
    open class var sharedInstance: GCHelper {
        struct Static {
            static let instance = GCHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(GCHelper.authenticationChanged), name: NSNotification.Name.GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
    
    // MARK: Internal functions
    @objc internal func authenticationChanged() {
        if GKLocalPlayer.localPlayer().isAuthenticated && !authenticated {
            print("Authentication changed: player authenticated")
            authenticated = true
        } else {
            print("Authentication changed: player not authenticated")
            authenticated = false
        }
    }
    
    fileprivate func lookupPlayers() {
        let playerIDs = match.players.map { $0.playerID } as! [String]
        
        GKPlayer.loadPlayers(forIdentifiers: playerIDs) { (players, error) -> Void in
            if error != nil {
                print("Error retrieving player info: \(error!.localizedDescription)")
                self.matchStarted = false
                self.delegate?.matchEnded()
            } else {
                guard let players = players else {
                    print("Error retrieving players; returned nil")
                    return
                }
                
                for player in players {
                    print("Found player: \(String(describing:player.alias))")
                    self.playersDict[player.playerID!] = player
                }
                
                self.matchStarted = true
                GKMatchmaker.shared().finishMatchmaking(for: self.match)
                self.delegate?.matchStarted()
            }
        }
    }
    
    // MARK: User functions
    
    /// Authenticates the user with their Game Center account if possible
    open func authenticateLocalUser() {
        print("Authenticating local user...")
        if GKLocalPlayer.localPlayer().isAuthenticated == false {
            GKLocalPlayer.localPlayer().authenticateHandler = { (view, error) in
                if error == nil {
                    self.authenticated = true
                } else {
                    print("\(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            print("Already authenticated")
        }
    }
    
    /**
    Attempts to pair up the user with other users who are also looking for a match.
    
    :param: minPlayers The minimum number of players required to create a match.
    :param: maxPlayers The maximum number of players allowed to create a match.
    :param: viewController The view controller to present required GameKit view controllers from.
    :param: delegate The delegate receiving data from GCHelper.
    */
    open func findMatchWithMinPlayers(_ minPlayers: Int, maxPlayers: Int, viewController: UIViewController, delegate theDelegate: GCHelperDelegate) {
        matchStarted = false
        match = nil
        presentingViewController = viewController
        delegate = theDelegate
        presentingViewController.dismiss(animated: false, completion: nil)
        
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        let mmvc = GKMatchmakerViewController(matchRequest: request)!
        mmvc.matchmakerDelegate = self
        
        presentingViewController.present(mmvc, animated: true, completion: nil)
    }
    
    /**
    Reports progress on an achievement to GameKit.
    
    :param: identifier A string that matches the identifier string used to create an achievement in iTunes Connect.
    :param: percent A percentage value (0 - 100) stating how far the user has progressed on the achievement.
    */
    open func reportAchievementIdentifier(_ identifier: String, percent: Double) {
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percent
        achievement.showsCompletionBanner = true
        GKAchievement.report([achievement]) { (error) -> Void in
            if error != nil {
                print("Error in reporting achievements: \(String(describing: error))")
            }
        }
    }
    
    /**
    Reports a high score eligible for placement on a leaderboard to GameKit.
    
    :param: identifier A string that matches the identifier string used to create a leaderboard in iTunes Connect.
    :param: score The score earned by the user.
    */
    open func reportLeaderboardIdentifier(_ identifier: String, score: Int) {
        let scoreObject = GKScore(leaderboardIdentifier: identifier)
        scoreObject.value = Int64(score)
        GKScore.report([scoreObject]) { (error) -> Void in
            if error != nil {
                print("Error in reporting leaderboard scores: \(String(describing:error))")
            }
        }
    }
    
    /**
    Presents the game center view controller provided by GameKit.
    
    :param: viewController The view controller to present GameKit's view controller from.
    :param: viewState The state in which to present the new view controller.
    */
    open func showGameCenter(_ viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        presentingViewController = viewController
        
        let gcvc = GKGameCenterViewController()
        gcvc.viewState = viewState
        gcvc.gameCenterDelegate = self
        presentingViewController.present(gcvc, animated: true, completion: nil)
    }
    
    // MARK: GKGameCenterControllerDelegate
    
    open func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: GKMatchmakerViewControllerDelegate
    
    open func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    open func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        presentingViewController.dismiss(animated: true, completion: nil)
        print("Error finding match: \(error.localizedDescription)")
    }
    
    open func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind theMatch: GKMatch) {
        presentingViewController.dismiss(animated: true, completion: nil)
        match = theMatch
        match.delegate = self
        if !matchStarted && match.expectedPlayerCount == 0 {
            print("Ready to start match!")
            self.lookupPlayers()
        }
    }
    
    // MARK: GKMatchDelegate
    
    open func match(_ theMatch: GKMatch, didReceive data: Data, fromPlayer playerID: String) {
        if match != theMatch {
            return
        }
        
        delegate?.match(theMatch, didReceiveData: data, fromPlayer: playerID)
    }
    
    open func match(_ theMatch: GKMatch, player playerID: String, didChange state: GKPlayerConnectionState) {
        if match != theMatch {
            return
        }
        
        switch state {
        case .stateConnected where !matchStarted && theMatch.expectedPlayerCount == 0:
            lookupPlayers()
        case .stateDisconnected:
            matchStarted = false
            delegate?.matchEnded()
            match = nil
        default:
            break
        }
    }
    
    open func match(_ theMatch: GKMatch, didFailWithError error: Error?) {
        if match != theMatch {
            return
        }
        
        print("Match failed with error: \(String(describing: error?.localizedDescription))")
        matchStarted = false
        delegate?.matchEnded()
    }
    
    // MARK: GKLocalPlayerListener
    
    open func player(_ player: GKPlayer, didAccept inviteToAccept: GKInvite) {
        let mmvc = GKMatchmakerViewController(invite: inviteToAccept)!
        mmvc.matchmakerDelegate = self
        presentingViewController.present(mmvc, animated: true, completion: nil)
    }
}
