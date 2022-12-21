//
//  AppFileManager.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation

enum SnapShotJsonFileName : String{
    case controlPoints = "snapshotControlPoints.json"
    case bezier1st = "snapshotBezier1st.json"
    case bezier2nd = "snapshotBezier2nd.json"
    case bezier3rd = "snapshotBezier3rd.json"
    
    func getFilePath()->URL{
        do{
            return try getDocumentsDirectory().appendingPathComponent(self.rawValue)
        }
        catch {
            fatalError()
        }
    }
}
func getDocumentsDirectory() throws -> URL {
    let fileManager = FileManager.default
    let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    //  Create subdirectory
    let directoryURL = appSupportURL.appendingPathComponent(Bundle.main.bundleIdentifier!)
    try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    return directoryURL
}

func saveDataToDocuments(_ data: Data, jsonFilename: String) {

    
    do {
        let jsonFileURL = try getDocumentsDirectory().appendingPathComponent(jsonFilename)
        //print("save to: ", jsonFileURL)
        try data.write(to: jsonFileURL)
    } catch {
        fatalError()
    }
}
