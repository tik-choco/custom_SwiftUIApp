import Defaults
import SwiftUI

struct AccountViewButton: View {
    @ObservedObject private var model = AccountsModel.shared
    private var navigation = NavigationModel.shared

    @Default(.accounts) private var accounts
    @Default(.instances) private var instances
    @Default(.accountPickerDisplaysUsername) private var accountPickerDisplaysUsername
    @Default(.accountPickerDisplaysAnonymousAccounts) private var accountPickerDisplaysAnonymousAccounts

    @ViewBuilder var body: some View {
        if !instances.isEmpty {
            Button {
                navigation.presentingAccounts = true
            } label: {
                HStack(spacing: 6) {
                    if !accountPickerDisplaysUsername || !(model.current?.isPublic ?? true) {
                        if #available(iOS 15, macOS 12, *) {
                            if let name = model.current?.app?.rawValue.capitalized {
                                Image(name)
                                    .resizable()
                                    .frame(width: accountImageSize, height: accountImageSize)
                            } else {
                                Image(systemName: "globe")
                            }
                        } else {
                            Image(systemName: "globe")
                        }
                    }

                    if accountPickerDisplaysUsername {
                        label
                            .labelStyle(.titleOnly)
                    }
                }
            }
            .transaction { t in t.animation = .none }
        }
    }

    private var accountImageSize: Double {
        #if os(macOS)
            20
        #else
            30
        #endif
    }

    private var label: some View {
        Label(model.current?.description ?? "Select Account", systemImage: "globe")
    }
}
