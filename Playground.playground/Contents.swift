//: Playground - noun: a place where people can play

import NowPlayingFormatter
import MediaPlayer

class MockMPMediaItem: MPMediaItem {

    let dict: [String: Any]
    init(dict: [String: Any]) {
        self.dict = dict

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func value(forProperty property: String) -> Any? {
        return dict[property]
    }
}

let item = MockMPMediaItem(dict: [
    MPMediaItemPropertyTitle: "music title"
    ])

do {
    let formatter = NowPlayingFormatter(format: "#nowplaying %t")
    print(formatter.string(from: item))
    // #nowplaying music title
}

do {

    let formatter = NowPlayingFormatter(format: "#nowplaying %t by %a")
    print(formatter.string(from: item))
    // #nowplaying music title by
}

do {
    let formatter = NowPlayingFormatter(format: "#nowplaying %t${ by %a}")
    print(formatter.string(from: item))
    // #nowplaying music title
}
