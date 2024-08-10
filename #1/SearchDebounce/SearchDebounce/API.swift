//
//  DataGenerator.swift
//  SearchObservableCombine
//
//  Created by Alfian Losari on 03/08/24.
//

import Foundation

class API {
    
    func search(text: String) async throws -> [String] {
        print("\(Date()) -> API: searching for \(text)")
        try await Task.sleep(for: .milliseconds((400...800).randomElement()!))
        try Task.checkCancellation()
        return Self.stubs
            .filter( {$0.localizedCaseInsensitiveContains(text) })
    }
    
    
    static let stubs =
        [
            "Spider-Man",
            "Iron Man",
            "Captain America",
            "Thor",
            "Hulk",
            "Black Widow",
            "Doctor Strange",
            "Black Panther",
            "Wolverine",
            "Scarlet Witch",
            "Vision",
            "Ant-Man",
            "Wasp",
            "Falcon",
            "Hawkeye",
            "Captain Marvel",
            "Star-Lord",
            "Gamora",
            "Drax the Destroyer",
            "Groot",
            "Rocket Raccoon",
            "Loki",
            "Thanos",
            "Nebula",
            "Ultron",
            "Red Skull",
            "Winter Soldier",
            "War Machine",
            "Quicksilver",
            "Mantis",
            "Valkyrie",
            "The Ancient One",
            "Nick Fury",
            "Yondu",
            "Shuri",
            "Okoye",
            "Korg",
            "Hela",
            "Odin",
            "Heimdall",
            "Phil Coulson",
            "Maria",
            "Peggy Carter",
            "The Collector",
            "Grandmaster",
            "Sif",
            "Lady Deathstrike",
            "Jessica Jones",
            "Luke Cage",
            "Iron Fist",
            "Daredevil",
            "Punisher",
            "Elektra",
            "Ghost Rider",
            "Moon Knight",
            "She-Hulk",
            "Blade",
            "Shang-Chi",
            "Nova",
            "Adam Warlock",
            "Sentry",
            "Ms. Marvel (Kamala Khan)",
            "Cyclops",
            "Jean Grey",
            "Storm",
            "Beast",
            "Rogue",
            "Gambit",
            "Iceman",
            "Professor X",
            "Magneto",
            "Mystique",
            "Juggernaut",
            "Sabretooth",
            "Emma Frost",
            "Colossus",
            "Nightcrawler",
            "Kitty Pryde",
            "Deadpool",
            "Cable",
            "Domino",
            "Bishop",
            "Psylocke",
            "Silver Surfer",
            "Galactus",
            "Doctor Doom",
            "Namor the Sub-Mariner",
            "Nick Fury Jr.",
            "Spider-Woman",
            "Quake",
            "Squirrel Girl",
            "The Mandarin",
            "Pepper Potts",
            "Happy Hogan",
            "America Chavez",
            "Mockingbird",
            "Howard the Duck"
        ].sorted(using: .localizedStandard)
    
}

