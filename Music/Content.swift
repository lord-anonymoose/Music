//
//  Content.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import Foundation

public var musicLibrary = [
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Billie Eilish - Bad Guy", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Ed Sheeran - Perfect", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Adele - Rolling In The Deep", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Katy Perry - I Kissed A Girl", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "OneRepublic & SeeB - Rich Love", ofType: "mp3")!)
]
