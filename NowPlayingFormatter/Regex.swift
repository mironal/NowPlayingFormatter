//
//  Regex.swift
//  NowPlayingFormatter
//
//  Created by mironal on 2017/04/09.
//  Copyright © 2017年 covelline. All rights reserved.
//

import Foundation

extension NSRegularExpression {

    static let braceRegex: NSRegularExpression = {
        let r =  try? NSRegularExpression(pattern: "\\$\\{.+?\\}", options: [])

        return r!
    }()

    static let formatRegex: NSRegularExpression = {

        // 文字数の長いものから並べる
        let pattern = "(\(NowPlayingFormatter.supportedFormatSpecifierMap.keys.sorted().reversed().joined(separator: "|"))|.+?)"
        let r =  try? NSRegularExpression(pattern: pattern, options: [])

        return r!
    }()

}
