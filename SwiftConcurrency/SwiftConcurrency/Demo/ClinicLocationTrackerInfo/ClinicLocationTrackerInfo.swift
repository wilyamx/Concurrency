//
//  ClinicLocationTrackerInfo.swift
//  SwiftConcurrency
//
//  Created by William S. Rena on 11/22/23.
//

import MapKit

public let clinics = [
    Clinic(id: "00b473bd-da59-4ff1-b77b-cf590835adaf",
           address: "Osmeña Blvd, Cebu City, 6000 Cebu"),
    Clinic(id: "0790a483-fb5b-4678-9125-d0ef7979e3b7",
           address: "7VXR+5RG, Natalio B. Bacalso Ave, Cebu City, 6000 Cebu"),
    Clinic(id: "21e66219-a834-49d3-8cd3-74013b2293fe",
           address: "A1 Ouano Ave, Mandaue City, 6014 Cebu"),
    Clinic(id: "2c4af108-db29-49db-878b-db8f080c2222",
           address: "8WW8+V2P~xxx.~M.~Cuenco~Ave~Cebu City~6000~Cebu"),
    Clinic(id: "2c4af108-db29-49db-878b-db8f080cec2d",
           address: "8WW8+V2P, Gov. M. Cuenco Ave, Cebu City, 6000 Cebu"),
    Clinic(id: "2c4af108-db29-49db-878b-db8f080c1111",
           address: "8WW8+V2P~xxx~Cebu City~6000~Cebu"),
    Clinic(id: "2c595e7e-5d26-4d82-91a6-8f60baa9605e",
           address: "41 F. Ramos St, Cebu City, 6000 Cebu")
]

public let clinics2 = [
    Clinic(id: "100",
           address: "Kompleks Hasby, Persiaran Raja~~42001~Kedah~Malaysia"),
    Clinic(id: "101",
           address: "Kompleks Hasby, Persiaran Raja~Muda Musa 42001 Majlis Perbandaran Klang Selangor~00002~Melaka~Malaysia"),
    Clinic(id: "102",
           address: "8th Floor, Wisma Genting, Jalan Sultan Ismail,~~50250~WP Kuala Lumpur~Malaysia"),
    Clinic(id: "103",
           address: "Kompleks Hasby, Persiaran Raja~~42002~Negeri Sembilan~Malaysia"),
    Clinic(id: "104",
           address: "PETALING JAYA~~46990~Selangor~Malaysia"),
    Clinic(id: "105",
           address: "Clover kingdom~Address testing~54634~Kelantan~Malaysia"),
    Clinic(id: "106",
           address: "Kompleks Hasby, Persiaran Raja~~00010~Kelantan~Malaysia"),
    Clinic(id: "107",
           address: "Clover kingdom~Address testing~76754~Kedah~Malaysia"),
    Clinic(id: "108",
           address: "Magnolia~Address testing~51341~Johor~Malaysia"),
    Clinic(id: "109",
           address: "7 Jalan SL 1/4, Bandar Sungai Long,~~43000~WP Kuala Lumpur~Malaysia")
]

public let riderLocation = CLLocationCoordinate2D(
    latitude: 10.329872605690607,
    longitude: 123.90646536308947
)

public extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

public struct Clinic: Codable {
    var id: String
    var address: String
}

public struct ClinicLocationTrackerInfo: Codable, Identifiable {
    public var id = UUID()
    //
    let clinicID: String
    let address: String
    //
    var rangeInKm: Double = 0
    var longitude: Double = 0
    var latitude: Double = 0
}
