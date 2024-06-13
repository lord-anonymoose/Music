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
    var artwork: UIImage?
}

func getSong(url: URL) async throws -> Song {
    let asset = AVAsset(url: url)
    var songName: String = "Unknown"
    var artistName: String = "Unknown"
    var artworkImage: UIImage?
    
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
                        artworkImage = UIImage(data: artworkData)
                    }
                default:
                    break
                }
            }
        }
    }

    print("Song name: \(songName), Artist: \(artistName), Artwork: \(artworkImage)")
    return Song(title: songName, artist: artistName, artwork: artworkImage)
}
/*
func getSong(url: URL) async throws -> Song {
    let asset = AVAsset(url: url)
    var songTitle: String
    var artistName: String
    
    for format in try await asset.load(.availableMetadataFormats) {
        let metadata = try await asset.loadMetadata(for: format)
        // Process the format-specific metadata collection.
        for item in metadata {
            if let commonKey = item.commonKey?.rawValue {
                switch commonKey {
                    case "title":
                        if let title = item.stringValue {
                            songTitle = title
                        }
                    case "artist":
                        if let artist = item.stringValue {
                            artistName = artist
                        }
                    default:
                        break
            }
                print("Metadata key: \(commonKey)")
            }
        }
    }
    // Example song, should extract actual song name and artist from metadata
    return Song(title: "Perfect", artist: "Ed Sheeran")
}

*/
