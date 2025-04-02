//
//  SwiftUIView.swift
//  zala
//
//  Created by Kyle Carriedo on 6/2/24.
//

import SwiftUI
import EventKit
import EventKitUI
import ZalaAPI

struct EventEditViewController: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    enum EventData {
        case appointment(appointment: MarketplaceAppointmentService,
                         selectedTime: Date,
                         additionalInfoRequest: AdditionalInfoRequest?,
                         travelAddress: String?)
        case personAppointment(appointment: PersonAppointment,
                         selectedTime: Date,
                         additionalInfoRequest: AdditionalInfoRequest?,
                         travelAddress: String?)
        case none
    }
    
    private let store = EKEventStore()
    
    typealias UIViewControllerType = EKEventEditViewController
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController
        
        init(_ controller: EventEditViewController) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
          return Coordinator(self)
    }
      
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.event = getEventData()
        eventEditViewController.eventStore = store
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }
        
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
        
    }
    
    let eventData: EventData
    
    fileprivate func getEventData() -> EKEvent {
        let event = EKEvent(eventStore: store)
        switch eventData {
            
        case .personAppointment( let appointment, let selectedTime,  let additionalInfoRequest, let travelAddress):
            event.title = appointment.appointmentService()?.formattedTitle()
            
            if let notes = additionalInfoRequest {
                event.notes = "\(notes.info)"
            }
            
            event.startDate = selectedTime
            event.endDate = selectedTime.dateByAdding(minutes: appointment.appointmentService()?.durationMins ?? 30)
            
            if appointment.isTravel(), let travelAddress {
                event.location = travelAddress
            } else if appointment.isVirtual() {
                event.notes = "URL link will be provided before appointment"
            } else {
                event.location = appointment.getAddress(type: .main)?.formattedAddressNewLines() ?? ""
            }
            
            return event
        case .appointment( let appointment, let selectedTime,  let additionalInfoRequest, let travelAddress):
            event.title = appointment.formattedTitle()
            
            if let notes = additionalInfoRequest {
                event.notes = "\(notes.info)"
            }
            
            event.startDate = selectedTime
            event.endDate = selectedTime.dateByAdding(minutes: appointment.durationMins ?? 30)
            
            if appointment.isTravel(), let travelAddress {
                event.location = travelAddress
            } else if appointment.isVirtual() {
                event.notes = "URL link will be provided before appointment"
            } else {
                event.location = appointment.getAddress(type: .main)?.formattedAddressNewLines() ?? ""
            }            
            
            return event
        case .none:
            event.title = "New Calendar Event"
            event.startDate = Date()
            event.endDate = Date().dateByAdding(minutes: 30)
            return event
        }
    }
}
