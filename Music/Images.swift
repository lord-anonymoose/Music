//
//  Images.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import UIKit
import Foundation


let defaultArtwork = UIImage(named: "DefaultThumbnail")!

// core TabBarViewController
let PlayerPageImage = UIImage(systemName: "music.note.list")
let VoiceMemoPageImage = UIImage(systemName: "waveform")

// PlayerViewController images
let playImage = UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let pauseImage = UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let stopImage = UIImage(systemName: "stop.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let previousImage = UIImage(systemName: "backward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let nextImage = UIImage(systemName: "forward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let minVolumeImage = UIImage(systemName: "speaker.slash.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
let maxVolumeImage = UIImage(systemName: "speaker.wave.3.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))

// VoiceMemoViewController images
let recordImage = UIImage(systemName: "button.programmable")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let stopRecordImage = UIImage(systemName: "stop.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let waveformImage = UIImage(systemName: "waveform")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 250, weight: .regular))

