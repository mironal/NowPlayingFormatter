import MediaPlayer

public class NowPlayingFormatter: Formatter {

    let nowPlayingFormat: String

    public init(format: String = "#nowplaying %t${ by %a}${ - %at}") {
        nowPlayingFormat = format
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func string(from: MPMediaItem) -> String {

        // 0. Split format by \n
        // 1. Split where it is surrounded by ${}.
        // 2. Does the MPMediaItem have elements of "%????"(e.g. $Artist)?.
        //    If it is not there, it is delete form the erement.
        //    If there is, remove "${" and "}" from the element and replace from template.
        // 3. Replace "%????" with info on MPMediaItem.

        let braceRegex = NSRegularExpression.braceRegex

        let formatLines = nowPlayingFormat.split(separator: "\n").map { String($0) }

        var templates: [String] = []
        for format in formatLines {
            let matches = braceRegex.matches(in: format,
                                             options: [],
                                             range: NSRange(location: 0, length: format.count))

            guard matches.count > 0 else {
                templates.append(format)
                continue
            }

            let templateByLine = matches.reduce(format) { (f, checkingResult) -> String in

                let text = (format as NSString).substring(with: checkingResult.range)
                let nakami = (text as NSString).substring(with: NSRange(location: 2, length: (text as NSString).length - 3))

                if hasProperty(text: nakami, in: from) {
                    return f.replacingOccurrences(of: text, with: nakami)
                } else {

                    // remove block
                    return f.replacingOccurrences(of: text, with: "")
                }
            }
            guard !templateByLine.isEmpty else { continue }
            templates.append(templateByLine)
        }

        return replace(text: templates.joined(separator: "\n"), with: from)
    }

    override public func string(for obj: Any?) -> String? {
        if let obj = obj as? MPMediaItem {
            return string(from: obj)
        }
        return nil
    }
}

public extension NowPlayingFormatter {

    static let supportedFormatSpecifierMap: [String: String] = [
        "%a": MPMediaItemPropertyArtist,
        "%t": MPMediaItemPropertyTitle,
        "%l": MPMediaItemPropertyLyrics,
        "%at": MPMediaItemPropertyAlbumTitle,
        "%aa": MPMediaItemPropertyAlbumArtist,
        "%tn": MPMediaItemPropertyAlbumTrackNumber,
        "%tc": MPMediaItemPropertyAlbumTrackCount
    ]
}

private extension NowPlayingFormatter {

    /// true if all property is not nil
    func hasProperty(text: String, in item: MPMediaItem) -> Bool {

        let regex = NSRegularExpression.formatRegex

        var components: [String] = []
        regex.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), using: { (result, _, _) in
            guard let result = result else {
                return
            }
            components.append((text as NSString).substring(with: result.range))
        })

        return components.first(where: { (c) -> Bool in
            guard let key = type(of: self).supportedFormatSpecifierMap[c] else {
                return false
            }

            return item.value(forProperty: key) == nil
        }) == nil
    }

    func replace(text: String, with item: MPMediaItem) -> String {

        let regex = NSRegularExpression.formatRegex

        var components: [String] = []
        regex.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.count), using: { (result, _, _) in
            guard let result = result else {
                return
            }
            components.append((text as NSString).substring(with: result.range))
        })

        let replacesed = components.map { (c) -> String in

            guard let key = type(of: self).supportedFormatSpecifierMap[c] else {
                return c
            }

            if let value = item.value(forProperty: key) {
                return String(describing: value)
            }

            return ""
        }
        return replacesed.joined(separator: "")
    }
}
