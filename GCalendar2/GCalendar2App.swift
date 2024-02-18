//
//  GCalendar2App.swift
//  GCalendar2
//
//  Created by Zheng on 18.02.24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

@main
struct GCalendar2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }.onAppear {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    // Check if `user` exists; otherwise, do something with `error`
                }
            }
        }
    }
}
