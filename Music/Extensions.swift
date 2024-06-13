//
//  Extensions.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import Foundation
import AVFoundation
import UIKit

struct Song {
    var title: String
    var artist: String
    var artwork: UIImage
}

let defaultArtwork = UIImage(named: "DefaultThumbnail")!

let playImage = UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
let pauseImage = UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))

// Parsing mp3 file to get song data
func getSong(url: URL) async throws -> Song {
    let asset = AVAsset(url: url)
    var songName: String = "Unknown"
    var artistName: String = "Unknown"
    var artworkImage: UIImage = defaultArtwork
    
    for format in try await asset.load(.availableMetadataFormats) {
        let metadata = try await asset.loadMetadata(for: format)
        
        for item in metadata {
            if let commonKey = item.commonKey?.rawValue {
                switch commonKey {
                case "title":
                    if let title = try await item.load(.stringValue) {
                        songName = title
                    }
                case "artist":
                    if let artist = try await item.load(.stringValue) {
                        artistName = artist
                    }
                case "artwork":
                    if let artworkData = try await item.load(.dataValue) {
                        artworkImage = UIImage(data: artworkData) ?? defaultArtwork
                    }
                default:
                    break
                }
            }
        }
    }

    return Song(title: songName, artist: artistName, artwork: artworkImage)
}
