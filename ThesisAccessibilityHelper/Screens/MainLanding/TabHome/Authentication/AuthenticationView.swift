//
//  AuthenticationView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

struct AuthenticationView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let iconSize: CGFloat = 28
        }
    }

    enum Page: String, CaseIterable, Equatable {
        case login
        case signup
    }

    // MARK: - Properties

    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var showSignup = false

    var type: Page

    var body: some View {
        BaseView {
            VStack(alignment: .center, spacing: 16) {
                Group {
                    titleComponent
                    emailComponent
                    passwordComponent
                    if type == .login {
                        signupComponent
                    }
                }
                .padding()
                buttonComponent
            }
        }
        .sheet(isPresented: $showSignup) {
            AuthenticationView(type: .signup)
        }
    }

    private var titleComponent: some View {
        Text("\(type.rawValue)".uppercased())
            .font(.largeTitle)
            .bold()
            .shadow(color: Color(uiColor: .systemGray), radius: 16, x: 0, y: 4)
    }

    private var emailComponent: some View {
        HStack {
            Label("", systemImage: "person.circle.fill")
                .scaledToFit()
                .frame(width: Consts.Layout.iconSize, height: Consts.Layout.iconSize)
            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .tint(.black)
        }
    }

    private var passwordComponent: some View {
        HStack {
            Label("", systemImage: "lock.fill")
                .labelStyle(.iconOnly)
                .scaledToFit()
                .frame(width: Consts.Layout.iconSize, height: Consts.Layout.iconSize)
            SecureTextField(secureText: $viewModel.password)
                .tint(.black)
        }
    }

    private var buttonComponent: some View {
        Button {
            viewModel.didTapButton(with: type)
        } label: {
            Text("\(type.rawValue )".uppercased())
                .foregroundColor(.white)
                .font(.title2)
                .bold()
        }
        .frame(width: 200, height: 50)
        .background(Capsule().fill(Color(.systemTeal)))
        .buttonStyle(BorderlessButtonStyle())
    }

    private var signupComponent: some View {
        HStack(spacing: 16) {
            Text("Don't have an account?")
            Button {
                showSignup.toggle()
            } label: {
                Text("Create")
                    .bold()
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

#Preview("Login") {
    BaseView {
        AuthenticationView(type: .login)
    }
}

#Preview("Sign up") {
    BaseView {
        AuthenticationView(type: .signup)
    }
}
