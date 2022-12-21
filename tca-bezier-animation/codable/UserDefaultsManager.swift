//
//  UserDefaultsManager.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation


func saveDataToUserDefaults(_ data: Data, keyName: String) {
    
    let defaults = UserDefaults.standard
    defaults.set(data, forKey: keyName)
    //print("saveDataToUserDefaults", data, keyName)
}
