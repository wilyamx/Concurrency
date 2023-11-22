//
//  ClinicLocationTrackerDemo.swift
//  SwiftConcurrency
//
//  Created by William S. Rena on 11/22/23.
//

import SwiftUI

struct ClinicLocationTrackerDemo: View {
    @StateObject private var viewModel =  ClinicLocationTrackerViewModel()
    
    var body: some View {
        Text("Clinic Location Tracker Demo!")
            .task {
                Task {
                    viewModel.newClinicsToTrack(clinics: clinics)
                    await viewModel.getGeocodeLocations()
                    viewModel.calculateRanges(riderCoordinate: riderLocation)
                    viewModel.logsForTrackData()
                }
                
                Task {
                    viewModel.newClinicsToTrack(clinics: clinics2)
                    await viewModel.getGeocodeLocations()
                    viewModel.calculateRanges(riderCoordinate: riderLocation)
                    viewModel.logsForTrackData()
                }
            }
    }
}

struct ClinicLocationTrackerDemo_Previews: PreviewProvider {
    static var previews: some View {
        ClinicLocationTrackerDemo()
    }
}
