//
//  NetworkManager.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import Foundation

let headers = [
    "X-RapidAPI-Key": "8697587018msh10bb3af364ac4f2p1de305jsnc5ca9d36a325",
    "X-RapidAPI-Host": "dietagram.p.rapidapi.com"
]

let maxFat: Int = 140
let searchCount: Int = 1200
let searchWord: String = "Wine"
let apiKey: String = "a053c68935284fc0b0041026bf79c509&query"


let request = NSMutableURLRequest(url: NSURL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)=\(searchWord)&maxFat=" + "\(maxFat)" + "&number=" + "\(maxFat)")! as URL,
                                        cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)

func getFoods() {
    request.httpMethod = "GET"
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
        } else {
            let httpResponse = response as? HTTPURLResponse
        }
        guard let data = data else { return }
        let jsonString = String(data: data, encoding: .utf8)
        print(jsonString)
    })

    dataTask.resume()
}

// apikeya053c68935284fc0b0041026bf79c509
// https://api.spoonacular.com/recipes/715538/similar?apikey=a053c68935284fc0b0041026bf79c509
// https://api.spoonacular.com/recipes/716429/information?apiKey=a053c68935284fc0b0041026bf79c509&includeNutrition=true.
