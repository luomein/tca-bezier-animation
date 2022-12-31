//
//  AppFileManager.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation
import LuomeinSwiftBasicTools

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
