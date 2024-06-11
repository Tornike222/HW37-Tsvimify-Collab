//
//  HW37_Tsvimify_CollaborationApp.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI

@main
struct HW37_Tsvimify_CollaborationApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherViewController(viewModel: WeatherViewModel())
        }
        .modelContainer(for: LocationsModel.self)

    }
}
