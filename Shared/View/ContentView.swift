//
//  ContentView.swift
//  Shared
//
//  Created by Burak YAZICI on 14/12/2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {

            VStack(alignment: .center) {

                if viewModel.currencies.isEmpty {
                    Spacer()
                    Text("Loading...")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else if viewModel.currencies.count < 1 {
                    Spacer()
                    Text("Error! Couldn't fetch the currencies")
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    calculationView()

                    Spacer()

                    Text(viewModel.getCurrentCurrencyRateText())
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .font(Font.system(size: 13))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .opacity(0.4)


                    exchangeButton()
                }
            }
            .navigationTitle("Exchange")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showingSheet) {
                SuccessView(rateText: viewModel.getSuccessText())
            }
        }
    }

    private func calculationView() -> some View {
        VStack {
            HStack {
                Button {
                    viewModel.showingFromCurrencies = true
                } label: {
                    Text("\(viewModel.currencies[viewModel.fromIndex])   \(Image(systemName: "chevron.down"))")
                        .padding(10)
                        .foregroundColor(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .confirmationDialog("Select currency", isPresented: $viewModel.showingFromCurrencies, titleVisibility: .visible) {
                    ForEach(viewModel.currencies.indices, id: \.self) { index in
                        Button(viewModel.currencies[index]) {
                            viewModel.fromIndex = index
                        }
                    }
                }

                Image(systemName: "arrow.left.arrow.right")
                    .padding()
                    .foregroundColor(.blue)

                Button {
                    viewModel.showingToCurrencies = true
                } label: {
                    Text("\(viewModel.currencies[viewModel.toIndex])   \(Image(systemName: "chevron.down"))")
                        .padding(10)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .confirmationDialog("Select currency", isPresented: $viewModel.showingToCurrencies, titleVisibility: .visible) {
                    ForEach(viewModel.currencies.indices, id: \.self) { index in
                        Button(viewModel.currencies[index]) {
                            viewModel.toIndex = index
                        }
                    }
                }
            }
            
            Spacer()

           
            TextField("Enter an amount", text: $viewModel.amount)
                .font(.system(size: 46, weight: .bold, design: .default))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
                .frame(height: 50.0, alignment: .center)
            
            Divider()
                .frame(width: 40)
            
            Group {
                Text("Final Amount: ") +
                Text(viewModel.getFinalAmountText())
                    .bold()
            }
            .opacity(0.4)
            
            Spacer()
        }
    }
    
    private func exchangeButton() -> some View {
        return Button("Exchange") {
            viewModel.showingAlert = true
            
        }
        .alert(isPresented:$viewModel.showingAlert) {
            Alert(
                title: Text("Confirm Operation"),
                message: Text(viewModel.getAlertText()),
                primaryButton: .destructive(Text("Cancel")) {
                    print("Alert canceled!")
                },
                secondaryButton: .default(Text("Confirm"), action: {
                    //Success Page
                    viewModel.showingSheet = true
                })
                
            )
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}



struct PrimaryButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .border(Color.blue)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding()
            .font(Font.system(size: 19, weight: .semibold))
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


