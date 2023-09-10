//
//  CustomCameraVIew.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 10..
//

import SwiftUI

struct CustomCameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @EnvironmentObject private var landingViewModel: LandingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
#if !targetEnvironment(simulator) // swiftlint:disable indentation_width
            CameraPreview(viewModel: viewModel)
                .ignoresSafeArea()
#endif
            VStack { // swiftlint:enable indentation_width
                if viewModel.isTaken {
                    HStack {
                        Spacer()

                        Button {
                            viewModel.reTakePicture()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                }

                Spacer()

                HStack {
                    if viewModel.isTaken {
                        Button {
                            if !viewModel.isSaved {
                                viewModel.savePicture()
                            }
                        } label: {
                            Text(viewModel.isSaved ? "Saved" : "Save")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .padding(.leading)

                        Spacer()
                    } else {
                        Button {
                            viewModel.takePicture()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                    }
                }
                .frame(height: 75)
            }
        }
        .navigationBarBackButtonHidden(true)
#if !targetEnvironment(simulator) // swiftlint:disable indentation_width
        .onAppear {
            viewModel.didAppear(landingViewModel)
        }
        .onDisappear {
            viewModel.didDidDisappear()
        }
#endif // swiftlint:enable indentation_width
    }
}

struct CustomCameraView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCameraView()
            .preferredColorScheme(.dark)
    }
}
