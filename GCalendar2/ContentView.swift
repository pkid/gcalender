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
    
    // Helper to build date
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    
    func handleSignInButton() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        let scopes = [kGTLRAuthScopeCalendarEvents]
        //
        ////        GIDSignIn.sharedInstance.currentUser?.addScopes(scopes, presenting: rootViewController)
        //
        //        guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
        //            return ;  /* Not signed in. */
        //        }
        //
        //        currentUser.addScopes(scopes, presenting: rootViewController) { signInResult, error in
        //            guard error == nil else { return }
        //            guard let signInResult = signInResult else { return }
        //            let user = signInResult.user
        //            let grantedScopes = user.grantedScopes
        //
        //
        //            // Check if the user granted access to the scopes you requested.
        //        }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
                guard let result = signInResult else {
                    // Inspect error
                    print(error)
                    return
                }
                
                guard let signInResult = signInResult else { return }
                
                let user = signInResult.user
                
                
                
                let grantedScopes = user.grantedScopes
                if grantedScopes == nil || !grantedScopes!.contains(kGTLRAuthScopeCalendarEvents) {
                    // Request additional Drive scope.
                    print("scope missing: " + kGTLRAuthScopeCalendarEvents)
                }
                
                
                let emailAddress = user.profile?.email
                
                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName
                
                print(fullName)
                
                let accessToken = user.accessToken.tokenString
                
                let service = GTLRCalendarService()
                service.authorizer = user.fetcherAuthorizer
                
                let calendarEvent = GTLRCalendar_Event()
                
                calendarEvent.summary = "test summary"
                calendarEvent.descriptionProperty = "test description"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                let startDate = dateFormatter.date(from: "01/03/2024 13:00")
                let endDate = dateFormatter.date(from: "01/03/2024 14:00")
                
                guard let toBuildDateStart = startDate else {
                    print("Error getting start date")
                    return
                }
                guard let toBuildDateEnd = endDate else {
                    print("Error getting end date")
                    return
                }
                
                calendarEvent.start = buildDate(date: toBuildDateStart)
                calendarEvent.end = buildDate(date: toBuildDateEnd)
                                    
                let query = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "yashu.liang@gmail.com")
                service.executeQuery(query, completionHandler: { (ticket, event, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print("Event added")
                    }
                })
                
                
            }
    }
}

#Preview {
    ContentView()
}
