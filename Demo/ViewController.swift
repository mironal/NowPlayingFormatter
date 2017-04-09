//
//  ViewController.swift
//  Demo
//
//  Created by mironal on 2017/04/09.
//  Copyright © 2017年 covelline. All rights reserved.
//

import UIKit

import NowPlayingFormatter
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var formatField: UITextField!
    @IBOutlet weak var resultText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var string = ""
        NowPlayingFormatter.supportedFormatSpecifierMap.forEach { (key, value) in
            string += "\(key) => \(value) \n"
        }

        string += "\n"
        string += "simple format\n"
        string += "  #nowplaying %Title by %Artist - %AlbumTitle\n\n"
        string += "useful format\n"
        string += "  #nowplaying %Title${ by %Artist}${ - %AlbumTitle}\n\n"

        descriptionText.text = string
    }


    @IBAction func didPushButton(_ sender: Any) {

        guard let format = formatField.text else {
            resultText.text = "there is no format."
            return
        }

        let controller = MPMusicPlayerController.systemMusicPlayer()

        guard let item = controller.nowPlayingItem else {
            resultText.text = "not play music."
            return
        }

        let formatter = NowPlayingFormatter(format: format)
        resultText.text = formatter.string(from: item)
    }
}

