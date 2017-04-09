//
//  NowPlayingFormatter.swift
//  NowPlayingFormatter
//
//  Created by mironal on 2017/04/09.
//  Copyright © 2017年 covelline. All rights reserved.
//

import MediaPlayer

public extension NowPlayingFormatter {

    static let supportedFormatSpecifierMap:[String: String] = [
        "%Artist": MPMediaItemPropertyArtist,
        "%Title": MPMediaItemPropertyTitle,
        "%AlbumTitle": MPMediaItemPropertyAlbumTitle,
        "%TrackNumber": MPMediaItemPropertyAlbumTrackNumber,
        "%TrackCount": MPMediaItemPropertyAlbumTrackCount
    ]
}

public class NowPlayingFormatter: Formatter {

    let nowPlayingFormat: String

    public init(format: String = "#nowplaying %Title${ by %Artist}${ - %AlbumTitle}") {
        nowPlayingFormat = format
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func string(from: MPMediaItem) -> String {

        // 1. Split where it is surrounded by ${}.
        // 2. Does the MPMediaItem have elements of "%????"(e.g. $Artist)?.
        //    If it is not there, it is delete form the erement.
        //    If there is, remove "${" and "}" from the element and replace from template.
        // 3. Replace "%????" with info on MPMediaItem.

        let braceRegex = NSRegularExpression.braceRegex

        let matches = braceRegex.matches(in: nowPlayingFormat,
                                         options: [],
                                         range: NSRange(location: 0, length: nowPlayingFormat.characters.count))

        let template: String = {

            guard matches.count > 0 else {
                return nowPlayingFormat
            }

            return matches.reduce(nowPlayingFormat) { (f, checkingResult) -> String in

                let text = (nowPlayingFormat as NSString).substring(with: checkingResult.range)

                if findPropety(item: from, in: text) != nil {

                    // remove brace
                    let removed = text.replacingOccurrences(of: "${", with: "")
                        .replacingOccurrences(of: "}", with: "")

                    return f.replacingOccurrences(of: text, with: removed)

                } else {

                    // remove block
                    return f.replacingOccurrences(of: text, with: "")
                }
            }
        }()

        return type(of: self).supportedFormatSpecifierMap.reduce(template) { (f, keyValue) -> String in
            if let value = findPropety(item: from, in: f) {
                return f.replacingOccurrences(of: value.key, with: value.prop)
            }
            return f
        }
    }

    override public func string(for obj: Any?) -> String? {
        if let obj = obj as? MPMediaItem {
            return string(from: obj)
        }
        return nil
    }
}

private extension NowPlayingFormatter {

    func findPropety(item: MPMediaItem, in text: String) -> (key: String, prop: String)? {

        let any = type(of: self).supportedFormatSpecifierMap.flatMap({ (key, value) -> (key: String, prop: String)? in
            guard text.contains(key) else {
                return nil
            }

            guard let prop = item.value(forProperty: value) else {
                return nil
            }
            return (key, String(describing: prop))
        }).first

        guard let value = any else {
            return nil
        }

        return (value.key, String(describing: value.prop))
    }
}
