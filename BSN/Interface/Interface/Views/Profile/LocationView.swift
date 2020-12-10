//
//  LocationView.swift
//  Interface
//
//  Created by Phucnh on 12/10/20.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: LocationManager.shared.location.coordinate.latitude,
            longitude: LocationManager.shared.location.coordinate.latitude
        ),
        latitudinalMeters: 10000,
        longitudinalMeters:10000
    )
    @State var tracking: MapUserTrackingMode = .follow
    @State var loading: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking)
            
            VStack {
                Text(LocationManager.shared.permissionDenied ? "Vui lòng cho phép truy cập vị trí trong cài đặt và thử lại" : LocationManager.shared.locationDes)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                Spacer()
                Button {
                    loading = true
                    let manager = LocationManager.shared
                    let fullLocation = "\(manager.location.coordinate.latitude)-\(manager.location.coordinate.longitude)-\(manager.locationDes)"
                    LocationManager.shared.updateToSever(location: fullLocation)
                    //print("region: \(region.center.latitude),\(region.center.longitude)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        loading = false
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Lưu vị trí mới")
                }
                .buttonStyle(RoundButtonStyle(size: .large, type: ButtonType.primary))
                .disabled(LocationManager.shared.permissionDenied)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding()
            }
        }
        .embededLoading(isLoading: $loading)
        .onAppear(perform: viewAppeared)
    }

    private func viewAppeared() {
        LocationManager.shared.updateLocation()
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
