//
//  ContentView.swift
//  WatchTest Watch App
//
//  Created by Stuart Robinson on 06/02/2026.
//

import SwiftUI

import EventKit
let evtStore = EKEventStore()

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            print("ContentView appeared")
            evtStore.requestFullAccessToEvents { granted, error in
              
                if (granted) {
                    print("Granted access to cal")
                    
                    var defCal:EKCalendar = evtStore.defaultCalendarForNewEvents!
                    
                    var dCal = Calendar.current
                    
                    var oneDayAgoComponents = DateComponents()
                    oneDayAgoComponents.day = -1
                    let oneDayAgo = dCal.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)
                    
                    var oneYearFromNowComponents = DateComponents()
                    oneYearFromNowComponents.year = 1
                    var oneYearFromNow = dCal.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)
                    
                    var predicate: NSPredicate? = nil
                    if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
                        predicate = evtStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
                    }
                
                    var events: [EKEvent]? = nil
                    if let aPredicate = predicate {
                        events = evtStore.events(matching: aPredicate)
                        
                        if ((events) != nil) {
                            for event in events! {
                                
                                
                                if (event.isAllDay) {
                                    print("found all day event")
                                    print(event.title)
                                }
                            }
                        }
                        
                    }
                } else {
                    print("granted is " + String(granted))
                }
                
                if ((error) != nil) {
                    print(error?.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
