import SwiftUI

struct ContentView: View {
    
    @State private var shouldShowVerificationView = false

    var body: some View {
        VStack(alignment: .center) {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "shield.checkered")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/4)
                        .foregroundStyle(Color.blue)
                        .padding(.vertical)
                    Spacer()
                }
                
                Text("Verify an electronic vehicle registration certificate.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ButtonRegular("Verify") {
                    shouldShowVerificationView = true
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $shouldShowVerificationView, content: {
            ReaderView()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}
