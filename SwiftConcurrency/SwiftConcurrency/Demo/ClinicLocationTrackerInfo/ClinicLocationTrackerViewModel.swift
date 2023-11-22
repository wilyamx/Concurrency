//
//  ClinicLocationTrackerViewModel.swift
//  SwiftConcurrency
//
//  Created by William S. Rena on 11/22/23.
//

import SwiftUI
import MapKit

@MainActor
final class ClinicLocationTrackerViewModel: ObservableObject {
    
    var locationTrackers: [ClinicLocationTrackerInfo] = []

    public func newClinicsToTrack(clinics: [Clinic]) {
        print("**********************")
        for clinic in clinics {
            let address = self.validatedClinicAddress(address: clinic.address)
            let trackerInfo = ClinicLocationTrackerInfo(clinicID: clinic.id,
                                                        address: address)
            locationTrackers.append(trackerInfo)
            print("[CLINIC-TRACK] \(trackerInfo.clinicID)")
        }
    }
    
    public func getGeocodeLocations() async {
        print("**********************")
        let geoCoder = CLGeocoder()
        for index in 0..<locationTrackers.count {
            let clinic = locationTrackers[index]

            do {
                if let placemark = try await geoCoder.geocodeAddressString(clinic.address).first,
                   let coordinate = placemark.location?.coordinate {

                    locationTrackers[index].longitude = coordinate.longitude
                    locationTrackers[index].latitude = coordinate.latitude

                    print("[Geocoder] Map location for clinic: \(clinic.clinicID), long: \(coordinate.longitude), lat: \(coordinate.latitude)")

                }
                else {
                    print("[Geocoder] INVALID geocode! for clinic: \(clinic.clinicID), Address: \(clinic.address)")
                }
            }
            catch(let error) {
                print("[Geocoder] Invalid geocode! for clinic: \(clinic.clinicID), Address: \(clinic.address)")
            }
        }
    }

    public func calculateRanges(riderCoordinate: CLLocationCoordinate2D) {
        print("**********************")
        for index in 0..<locationTrackers.count {
            let clinic = locationTrackers[index]

            if clinic.longitude > 0 && clinic.latitude > 0 {
                let clinicLocation = CLLocation(
                    latitude: clinic.latitude,
                    longitude: clinic.longitude
                )
                let riderLocation = CLLocation(
                    latitude: riderCoordinate.latitude,
                    longitude: riderCoordinate.longitude
                )

                let distanceInMeters = clinicLocation.distance(from: riderLocation)
                let distanceInKilometers = Double(distanceInMeters / 1000.0)

                locationTrackers[index].rangeInKm = distanceInKilometers.rounded(toPlaces: 2)

                print("[Distance] Address: \(clinic.clinicID), Range: \(distanceInKilometers)!")
            }
        }
    }

    public func logsForTrackData() {
        print("**********************")
        for clinic in self.locationTrackers {
            if clinic.longitude > 0 && clinic.latitude > 0 {
                print("[Details] ClinicID: \(clinic.clinicID), Long: \(clinic.longitude), Lat: \(clinic.latitude), Range(KM): \(clinic.rangeInKm)")
            }
        }
    }
    
    public func validatedClinicAddress(address: String, ignore: Bool = false) -> String {
        if ignore {
            return address
        }
        
        let delimeter = "~"
        let validDelimeter = address.replacingOccurrences(
            of: "\(delimeter)\(delimeter)",
            with: delimeter
        )
        let addresses = validDelimeter.components(separatedBy: delimeter)
        
        let addresses2 = addresses.map({ $0.trimmingCharacters(in: .whitespaces) })
        let addresses3 = addresses2.map({ $0.trimmingCharacters(in: .punctuationCharacters) })
        
        let formattedAddress = addresses3.joined(separator: ", ")
        
        // We get the first element address
        if let newAddress = addresses3.first {
            return newAddress
        }
        return address
    }
}
