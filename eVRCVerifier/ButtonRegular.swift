import SwiftUI

struct ButtonRegular: View {
    
    var title: String
    var onPress: () -> Void
    var disabled: Bool
    var backgroundColor: Color
    
    init(_ title: String, background: Color = .blue, disabled: Bool = false, onPress: @escaping () -> Void) {
        self.title = title
        self.disabled = disabled
        self.onPress = onPress
        self.backgroundColor = background
    }
    
    var body: some View {
        Button {
            onPress()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .font(.body)
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
            .background(disabled ? Color.gray : backgroundColor)
            .cornerRadius(10)
        }
        .disabled(disabled)
    }
}

#Preview {
    ButtonRegular("Test") {
        // nothing to do
    }
}
