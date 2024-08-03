//
//  SettingsSection.swift
//  Spotify
//
//  Created by Willian Peres on 03/08/24.
//

import Foundation

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let handler: () -> Void
}
