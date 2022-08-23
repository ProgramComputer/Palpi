//
//  ContentView.swift
//  Palpi
//
//  Created by  on 8/22/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        switch viewModel.state{
        case .signedIn: HomeView()
        case .signedOut: LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
