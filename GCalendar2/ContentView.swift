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
    @State private var date = Date()
    @State private var startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var endTime = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var eventTitle = ""
    @State private var showSuccessBanner = false
    @State private var showErrorBanner = false

    
    
    var body: some View {
        VStack {
            Spacer()

            TextField("Event Title", text: $eventTitle)
            DatePicker("Date", selection: $date, displayedComponents: .date)
            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
            if showSuccessBanner {
                Text("success")
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .transition(.move(edge: .bottom))
            }
            
            if showErrorBanner {
                Text("error")
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .transition(.move(edge: .bottom))
            }

            
            Spacer()
            
            
            GoogleSignInButton(action: handleSignInButton)
            
            
                        
        }
        .padding()
    }
    
    func handleSignInButton() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        let scopes = [kGTLRAuthScopeCalendarEvents]
        
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
                
                let service = GTLRCalendarService()
                service.authorizer = user.fetcherAuthorizer
                
                // create event data
                let calendarEvent = GTLRCalendar_Event()
                calendarEvent.summary = eventTitle
                calendarEvent.descriptionProperty = eventTitle
                let startDateTime = GTLRDateTime(date: startTime)
                let endDateTime = GTLRDateTime(date: endTime)
                calendarEvent.start = GTLRCalendar_EventDateTime()
                calendarEvent.start?.dateTime = startDateTime
                calendarEvent.end = GTLRCalendar_EventDateTime()
                calendarEvent.end?.dateTime = endDateTime
                
                let query = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "yashu.liang@gmail.com")
                service.executeQuery(query, completionHandler: { (ticket, event, error) in
                    if let error = error {
                        print("Error: \(error)")
                        withAnimation {
                            self.showErrorBanner = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.showErrorBanner = false
                            }
                        }
                    } else {
                        print("Event added")
                        eventTitle = ""
                        withAnimation {
                            self.showSuccessBanner = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.showSuccessBanner = false
                            }
                        }
                    }
                })
                
                
            }
    }
}

#Preview {
    ContentView()
}
