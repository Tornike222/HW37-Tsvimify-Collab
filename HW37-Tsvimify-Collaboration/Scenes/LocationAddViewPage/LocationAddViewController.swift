//
//  LocationAddViewController.swift
//  HW37-Tsvimify-Collaboration
//
//  Created by telkanishvili on 12.06.24.
//

import SwiftUI

struct LocationAddViewController: View {
    @StateObject var viewModel: LocationAddViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .searcმhab
            .onAppear(perform: {
                viewModel.fetchLocations()
            })
    }
}

//#Preview {
//    LocationAddViewController()
//}
