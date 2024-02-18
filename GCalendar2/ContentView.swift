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
        let scopes = [kGTLRAuthScopeCalendar, kGTLRAuthScopeCalendarEvents]
        
        GIDSignIn.sharedInstance.currentUser?.addScopes(scopes, presenting: rootViewController)


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
                
                let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
                
                print(insertQuery)
                
                service.executeQuery(insertQuery) { (ticket, object, error) in
                    if error == nil {
                        print("Event inserted")
                    } else {
                        print(error)
                    }
                }
                
                
                print(accessToken)
                
            }
    }
}

#Preview {
    ContentView()
}
