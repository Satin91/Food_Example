//
//  HTMLParser.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.01.2023.
//

import Foundation

    /**
    The summary of the recipe is described in the HTML markup.
    Below are our own methods for getting indexes, after which they turn into phrases based on HTML markup.
    **/

final class HTMLParser {
    func getExcerpt(text: String) {
        let ranges = getRanges(from: text)
        let indecesContainer = getIndeces(from: ranges, of: text)
        
        var phrases: [String] = []
        for phraseIndeces in indecesContainer {
            guard phraseIndeces.count == 2 else { continue }
            phrases.append(String(Array(text)[phraseIndeces[0]...phraseIndeces[1]]))
        }
        print(phrases)
    }
    
    // Get markup ranges of phrases
    private func getRanges(from: String) -> (start: [Range<String.Index>], end: [Range<String.Index>]) {
        let startPhraseRanges: [Range<String.Index>] = from.ranges(of: "<b>")
        let endPhraseRanges: [Range<String.Index>] = from.ranges(of: "</b>")
        return (startPhraseRanges, endPhraseRanges)
    }
    
    // Transform markup ranges to two-dimensional array of phrases indeces
    private func getIndeces(from: ([Range<String.Index>], [Range<String.Index>]), of: String) -> [[Int]] {
        var indeces: [[Int]] = [[]]
        for index in 0..<from.0.count {
            let startPhraseIndex = of.distance(from: of.startIndex, to: from.0[index].lowerBound) + 3
            let endPhraseIndex = of.distance(from: of.startIndex, to: from.1[index].lowerBound) - 1
            indeces.insert([startPhraseIndex, endPhraseIndex], at: index)
        }
        return indeces
    }
}
