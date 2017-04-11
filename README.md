# NowPlayingFormatter

NowPlayingFormatter is a very smart formatter library for MPMediaItem written by Swift.

## Example

```swift
let formatter = NowPlayingFormatter(format: "#nowplaying %t by %a")

let item = MPMediaItem() // has title and artist info

print(formatter.format(from: item))
// #nowplaying title by artist
```

However, MPMediaItem may not have all info.
e.g. it has a title, but it has not a artist info.

```swift
let formatter = NowPlayingFormatter(format: "#nowplaying %t by %a")

let item = MPMediaItem() // have title, but have not artist info.

print(formatter.format(from: item))
// #nowplaying title by

// `by` is unnecessary (´･‿･｀)
```

In such a case. You can use `${}` notation.

```swift
let formatter = NowPlayingFormatter(format: "#nowplaying ${%t}${ by %a}")

let item1 = MPMediaItem() // has title and artist information.

print(formatter.format(from: item1))
// #nowplaying title by artist

// and

let item2 = MPMediaItem() // have title, but have not artist info.
print(formatter.format(from: item2))
// #nowplaying title
// good ヽ(•̀ω•́ )ゝ✧
```

## Supported format

- "%a": MPMediaItemPropertyArtist,
- "%t": MPMediaItemPropertyTitle,
- "%l": MPMediaItemPropertyLyrics,
- "%at": MPMediaItemPropertyAlbumTitle,
- "%aa": MPMediaItemPropertyAlbumArtist,
- "%tn": MPMediaItemPropertyAlbumTrackNumber,
- "%tc": MPMediaItemPropertyAlbumTrackCount

## Installation

Write your `Cartfile`

```
github "mironal/NowPlayingFormatter"
```

and run `carthage update`.

After build. you need setting `Carthage Copy Frameworks Run Script` on your xcode project.

