//
//  SuccessView.swift
//  CurrencyApp
//
//  Created by Burak YAZICI on 14/12/2021.
//

import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) var dismiss
    let rateText: String

    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(.green)
                .frame(width: 64.0, height: 64.0)
                
            Text("Success")
                .padding(4)
                .font(.system(size: 28, weight: .bold, design: .default))
            
            Text(rateText)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button("Back To Exchange") {
                dismiss()
            }
            .font(.title)
            .padding()
            .buttonStyle(PrimaryButtonStyle())
        }
        
    
    }
    
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(rateText: "100 usd = 50 euro")
    }
}
