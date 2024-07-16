//
//  SuccessView.swift
//  eVRCVerifier
//
//  Created by Nicolai Schneider on 29.05.24.
//

import SwiftUI

struct SuccessView: View {
    
    let vehicle: EVRCData
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundStyle(.green)
                .padding()
            
            Text("Data Received Successfully!")
                .bold()
                .padding(.bottom)
            
            ScrollView {
                VStack {
                    ForEach(Array(vehicle.valuesAsArray().enumerated()), id: \.offset) { _, element in
                        HStack {
                            field(type: element.0, value: element.1)
                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
        }
    }
    
    func field(type: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(type)
                .font(.callout)
                .bold()
            Text(value)
                .font(.callout)
                .multilineTextAlignment(.leading)

        }
    }
}
