//
//  HTMLParser.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.01.2023.
//

import Foundation
import SwiftUI
    /**
    The summary of the recipe is described in the HTML markup.
    Below are methods for getting indexes, after which they turn into phrases based on HTML markup.
    **/

final class HTMLParser {
    let startFrasesTags = ["href=", "\">", "<b>"]
    let endFrasesTags = ["\">", "</a>", "</b>"]
    
    func getExcerpt(text: String) -> [String] {
        let ranges = getRanges(from: text)
        let frasesIndices = getIndeces(from: ranges, of: text)
        var phrases: [String] = []
        for indeces in frasesIndices {
            guard indeces.count == 2 else { continue }
            phrases.append(String(Array(text)[indeces[0]..<indeces[1]]))
        }
        
        let joindeTags = startFrasesTags + endFrasesTags
        var replacedPhrases: [String] = []
        for tag in joindeTags {
            for phrase in phrases {
                if phrase.contains(tag) {
                    replacedPhrases.append(phrase.replacingOccurrences(of: tag, with: ""))
                } else {
                    continue
                }
            }
        }
        return replacedPhrases
    }
    
    func removeMarkups(text: String) -> String {
        let joined = startFrasesTags + endFrasesTags + ["<a"]
        var replacedText = text
        for markup in joined {
            replacedText = replacedText.replacingOccurrences(of: markup, with: "")
        }
        return replacedText
    }
    
    // Get tags ranges of phrases
    private func getRanges(from: String) -> (start: [Range<String.Index>], end: [Range<String.Index>]) {
        var startPhraseRanges = [Range<String.Index>]()
        var endPhraseRanges = [Range<String.Index>]()
        for index in 0..<startFrasesTags.count {
            startPhraseRanges += from.ranges(of: startFrasesTags[index])
            endPhraseRanges += from.ranges(of: endFrasesTags[index])
        }
        return (startPhraseRanges, endPhraseRanges)
    }
    
    // Transform markup ranges to two-dimensional array of phrases indeces
    private func getIndeces(from: ([Range<String.Index>], [Range<String.Index>]), of: String) -> [[Int]] {
        var indeces: [[Int]] = [[]]
        for index in 0..<from.0.count {
            let startPhraseIndex = of.distance(from: of.startIndex, to: from.0[index].lowerBound)
            let endPhraseIndex = of.distance(from: of.startIndex, to: from.1[index].lowerBound)
            indeces.insert([startPhraseIndex, endPhraseIndex], at: index)
        }
        return indeces
    }
}

// Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs might be a good recipe to expand your main course repertoire. One portion of this dish contains approximately <b>19g of protein </b>,  <b>20g of fat </b>, and a total of  <b>584 calories </b>. For  <b>$1.63 per serving </b>, this recipe  <b>covers 23% </b> of your daily requirements of vitamins and minerals. This recipe serves 2. It is brought to you by fullbellysisters.blogspot.com. 209 people were glad they tried this recipe. A mixture of scallions, salt and pepper, white wine, and a handful of other ingredients are all it takes to make this recipe so scrumptious. From preparation to the plate, this recipe takes approximately  <b>45 minutes </b>. All things considered, we decided this recipe  <b>deserves a spoonacular score of 83% </b>. This score is awesome. If you like this recipe, take a look at these similar recipes: <a href=\"https://spoonacular.com/recipes/cauliflower-gratin-with-garlic-breadcrumbs-318375\">Cauliflower Gratin with Garlic Breadcrumbs</a>, < href=\"https://spoonacular.com/recipes/pasta-with-cauliflower-sausage-breadcrumbs-30437\">Pasta With Cauliflower, Sausage, & Breadcrumbs</a>, and <a href=\"https://spoonacular.com/recipes/pasta-with-roasted-cauliflower-parsley-and-breadcrumbs-30738\">Pasta With Roasted Cauliflower, Parsley, And Breadcrumbs</a>.
