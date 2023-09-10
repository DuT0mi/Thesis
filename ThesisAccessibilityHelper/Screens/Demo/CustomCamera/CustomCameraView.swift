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
                HStack {
                    Image(systemName: "signpost.left.circle")
                        .onTapGesture {
                            self.dismiss.callAsFunction()
                        }
                        .padding(.init(top: 5, leading: 5, bottom: 0, trailing: 0))
                    Spacer()
                    if viewModel.isTaken {
                        Button {
                            viewModel.reTakePicture()
                        } label: {
                            Image(systemName: "camera")
                                .foregroundColor(.white)
                        }
                        .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 5))
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
                        .padding(.bottom)
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
