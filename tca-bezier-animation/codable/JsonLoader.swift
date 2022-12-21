//
//  BundleJsonLoader.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation

func loadJsonFromUrl<T:Decodable>(url: URL)-> T {
    
    do {
        let data = try Data(contentsOf: url)
        return loadJsonFromData(data: data)
    } catch {
        fatalError()
    }

}
func loadJsonFromData<T:Decodable>(data: Data) -> T{
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(T.self, from: data)
        return jsonData
    } catch {
        fatalError()
    }
}
func loadJsonFromUserDefaults<T:Decodable>(keyName: String) -> T{
    let data = UserDefaults.standard.object(forKey: keyName) as! Data
    return loadJsonFromData(data: data)
//    if let savedData = UserDefaults.standard.object(forKey: keyName) as? Data {
//        let decoder = JSONDecoder()
//        if let loadedPerson = try? decoder.decode(Person.self, from: savedPerson) {
//            print(loadedPerson.name)
//        }
//    }
}
func loadJsonFromBundle<T:Decodable>(filename fileName: String) -> T {
    
    
    let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
    return loadJsonFromUrl(url: url)
    //            let data = try Data(contentsOf: url)
    //            let decoder = JSONDecoder()
    //            let jsonData = try decoder.decode(T.self, from: data)
    //            return jsonData
    
    
}
