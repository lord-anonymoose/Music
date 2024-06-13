//
//  Content.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import Foundation

#if DEBUG
public var musicLibrary = [
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Billie Eilish - Bad Guy", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Ed Sheeran - Perfect", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Adele - Rolling In The Deep", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Katy Perry - I Kissed A Girl", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "OneRepublic & SeeB - Rich Love", ofType: "mp3")!)
]
#else
public var musicLibrary = [
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Oddvision-Media-Infraction-Music-Royal-Stage-water", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Infraction-Let-Me-Know-Main-Version-pr", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Infraction-Music-Take-A-Break-pr", ofType: "mp3")!),
    URL.init(fileURLWithPath: Bundle.main.path(forResource: "Infraction-Almost-Evil-pr", ofType: "mp3")!)
]
#endif
