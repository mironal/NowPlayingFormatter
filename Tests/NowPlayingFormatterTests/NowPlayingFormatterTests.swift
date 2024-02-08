import XCTest
@testable import NowPlayingFormatter

import MediaPlayer

final class MockMPMediaItem: MPMediaItem {

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

class NowPlayingFormatterTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test() {

        let f = NowPlayingFormatter()

        let item = MockMPMediaItem(dict: [
            MPMediaItemPropertyTitle: "TITLE",
            MPMediaItemPropertyArtist: "ARTIST",
            MPMediaItemPropertyAlbumTitle: "ALBUM_TITLE"
        ])

        XCTAssertEqual(f.string(from: item), "#nowplaying TITLE by ARTIST - ALBUM_TITLE")
    }

    func testWithNewLine() {
        do {
            let f = NowPlayingFormatter(format: """
${- %t}
${- %a}
- %at
""")
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
                MPMediaItemPropertyArtist: "ARTIST",
                MPMediaItemPropertyAlbumTitle: "ALBUM_TITLE"
            ])

            XCTAssertEqual(f.string(for: item), """
- TITLE
- ARTIST
- ALBUM_TITLE
""")
        }
        do {
            let f = NowPlayingFormatter(format: """
${- %t}
${- %a}
- %at
""")
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
            ])

            XCTAssertEqual(f.string(for: item), "- TITLE\n- ")
        }

        do {
            let f = NowPlayingFormatter(format: "#nowplaying\n%t${ by %a}${ - %at}")
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
                MPMediaItemPropertyArtist: "ARTIST",
                MPMediaItemPropertyAlbumTitle: "ALBUM_TITLE"
            ])

            XCTAssertEqual(f.string(from: item), "#nowplaying\nTITLE by ARTIST - ALBUM_TITLE")
        }
    }

    func testAny() {

        let f = NowPlayingFormatter(format: "${%t %a}")

        do {
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
                MPMediaItemPropertyArtist: "ARTIST"
            ])

            XCTAssertEqual(f.string(from: item), "TITLE ARTIST", "have everything")
        }

        do {
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE"
            ])

            XCTAssertEqual(f.string(from: item), "", "If there is not one, it becomes empty")
        }

    }

    func testOptionalBrace() {

        let f = NowPlayingFormatter(format: "#nowplaying %t${ by %a}${ - %at}")

        do {
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
            ])

            XCTAssertEqual(f.string(from: item), "#nowplaying TITLE", "only title")
        }

        do {
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
                MPMediaItemPropertyArtist: "ARTIST"
            ])

            XCTAssertEqual(f.string(from: item), "#nowplaying TITLE by ARTIST", "without album title")
        }

        do {
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
                MPMediaItemPropertyArtist: "ARTIST",
                MPMediaItemPropertyAlbumTitle: "ALBUM_TITLE"
            ])

            XCTAssertEqual(f.string(from: item), "#nowplaying TITLE by ARTIST - ALBUM_TITLE")
        }

        do {
            let item = MockMPMediaItem(dict: [
                MPMediaItemPropertyTitle: "TITLE",
                MPMediaItemPropertyAlbumTitle: "ALBUM_TITLE"
            ])

            XCTAssertEqual(f.string(from: item), "#nowplaying TITLE - ALBUM_TITLE", "without Artist")
        }
    }

    func testNoSpace() {

        let f = NowPlayingFormatter(format: "%t%a%at")

        let item = MockMPMediaItem(dict: [
            MPMediaItemPropertyTitle: "TITLE",
            MPMediaItemPropertyArtist: "ARTIST",
            MPMediaItemPropertyAlbumTitle: "ALBUM_TITLE"
        ])

        XCTAssertEqual(f.string(from: item), "TITLEARTISTALBUM_TITLE")
    }
}
