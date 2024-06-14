//
//  Extensions.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer

struct Song {
    var title: String
    var artist: String
    var artwork: UIImage
}


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

extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}

func getDocumentsDirectory() -> URL
{
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getFileUrl() -> URL
{
    let filename = "myRecording.m4a"
    let filePath = getDocumentsDirectory().appendingPathComponent(filename)
return filePath
}
