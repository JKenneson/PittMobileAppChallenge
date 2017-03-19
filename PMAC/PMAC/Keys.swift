//
//  Keys.swift
//  RISE
//
//  This class holds a struct which contains simple strings reserved for the 4 keys to save to the user defaults
//
//  Created by Jonathan Kenneson on 3/15/17.
//  Copyright © 2017 Kenneson Studios. All rights reserved.
//

import Foundation


//A collection of the four things we must persist across loads
struct Keys {
    static let totalUserCO2Saved = "totalUserCO2Saved"
    static let totalUserTreesSaved = "totalUserTreesSaved"
    static let treeCO2Saved = "treeCO2Saved"
    static let treeStage = "treeStage"
    static let lastTimeAppOpened = "lastTimeAppOpened"
}
