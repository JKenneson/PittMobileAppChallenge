//
//  AppDelegate.swift
//  PMAC
//
//  Created by Jonathan Kenneson on 2/15/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.isIdleTimerDisabled = true             //Stop the phone from turning off the screen
        
        //Recover the stored user data
        let defaults = UserDefaults.standard
        if let totalUserCO2SavedString = defaults.string(forKey: Keys.totalUserCO2Saved) {
            Globals.totalUserCO2Saved = Double(totalUserCO2SavedString)!
        }
        if let totalUserTreesSavedString = defaults.string(forKey: Keys.totalUserTreesSaved) {
            Globals.totalUserTreesSaved = Int(totalUserTreesSavedString)!
        }
        if let treeCO2SavedString = defaults.string(forKey: Keys.treeCO2Saved) {
            Globals.treeCO2Saved = Double(treeCO2SavedString)!
        }
        if let treeStageString = defaults.string(forKey: Keys.treeStage) {
            Globals.treeStage = Int(treeStageString)!
        }
        if let lastTimeAppOpenedDate = defaults.object(forKey: Keys.lastTimeAppOpened) as? NSDate {
            Globals.lastTimeAppOpened = lastTimeAppOpenedDate
            print("App Last opened: \(String(describing: Globals.lastTimeAppOpened))")
        }
        if let systemFirstLoadBool = defaults.string(forKey: Keys.systemFirstLoad) {
            Globals.systemFirstLoad = Int(systemFirstLoadBool)!
        }
        
        //Decide which screen to show on load
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Pick which view to show based on if we are in first load state or not
        if(Globals.systemFirstLoad == 1) {
            let exampleViewController: StartScreen1 = mainStoryboard.instantiateViewController(withIdentifier: "startScreen1ID") as! StartScreen1
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
            
        }
        else {
            let exampleViewController: StartScreen2 = mainStoryboard.instantiateViewController(withIdentifier: "startScreen2ID") as! StartScreen2
            self.window?.rootViewController = exampleViewController
            self.window?.makeKeyAndVisible()
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Saving the important data to persist across loads
        let defaults = UserDefaults.standard
        defaults.setValue(Globals.totalUserCO2Saved, forKey: Keys.totalUserCO2Saved)
        defaults.setValue(Globals.totalUserTreesSaved, forKey: Keys.totalUserTreesSaved)
        defaults.setValue(Globals.treeCO2Saved, forKey: Keys.treeCO2Saved)
        defaults.setValue(Globals.treeStage, forKey: Keys.treeStage)
        defaults.setValue(Globals.lastTimeAppOpened, forKey: Keys.lastTimeAppOpened)
        defaults.setValue(Globals.systemFirstLoad, forKey: Keys.systemFirstLoad)
        defaults.synchronize()

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        //Saving the important data to persist across loads
        let defaults = UserDefaults.standard
        defaults.setValue(Globals.totalUserCO2Saved, forKey: Keys.totalUserCO2Saved)
        defaults.setValue(Globals.totalUserTreesSaved, forKey: Keys.totalUserTreesSaved)
        defaults.setValue(Globals.treeCO2Saved, forKey: Keys.treeCO2Saved)
        defaults.setValue(Globals.treeStage, forKey: Keys.treeStage)
        defaults.setValue(Globals.lastTimeAppOpened, forKey: Keys.lastTimeAppOpened)
        defaults.setValue(Globals.systemFirstLoad, forKey: Keys.systemFirstLoad)
        defaults.synchronize()

        
    }


}

