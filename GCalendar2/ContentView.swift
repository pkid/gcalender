//
//  ContentView.swift
//  GCalendar2
//
//  Created by Zheng on 18.02.24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher


struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            GoogleSignInButton(action: handleSignInButton)
            
        }
        .padding()
    }
    
    func handleSignInButton() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
                guard let result = signInResult else {
                    // Inspect error
                    return
                }
                
                guard let signInResult = signInResult else { return }
                
                let user = signInResult.user
                
                let emailAddress = user.profile?.email
                
                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                
                let accessToken = user.accessToken.tokenString
                
                // Your calendar ID
                let calendarId = "primary"

                // The event details
                let eventData: [String: Any] = [
                    "summary": "Appointmentxxxxx",
                    "location": "Somewhere",
                    "start": [
                        "dateTime": "2024-03-01T10:00:00",
                        "timeZone": "America/Los_Angeles",
                    ],
                    "end": [
                        "dateTime": "2024-03-01T11:00:00",
                        "timeZone": "America/Los_Angeles",
                    ]
                ]
                
                
                
                print(accessToken)
                
            }
    }
}

#Preview {
    ContentView()
}
