//
//  OnboardingView.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/31/23.
//

import SwiftUI
import ScreenCorners
import PhotosUI

struct OnboardingView: View {
    @EnvironmentObject var model: Model
    
    @Binding var showing: Bool
    @Binding var page: ContentView.GetStarted
    @State private var photoHeight: CGFloat = 0
    @State private var showPlaid = false
    @FocusState var editing
    @State private var photoItem: PhotosPickerItem?
    @State private var loading = false
    
    var bottomCorners: CGFloat {
        UIScreen.main.displayCornerRadius
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                switch page {
                case .link:
                    linkContent
                        .zIndex(1)
                        .transition(.forward)
                        .padding(.horizontal)
                case .first:
                    firstName
                        .zIndex(1)
                        .transition(.forward)
                        .padding(.horizontal)
                case .last:
                    lastName
                        .zIndex(1)
                        .transition(.forward)
                        .padding(.horizontal)
                case .picture:
                    addPhoto
                        .zIndex(1)
                        .transition(.forward)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom)
            .padding(.top, page == .link ? nil : 36)
            .background {
                RoundedRectangle(cornerRadius: bottomCorners, style: .continuous)
                    .foregroundColor(.white)
                    .ignoresSafeArea()
            }
            .animation(.spring(), value: page)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showPlaid) {
            Task {
                // TODO: Make sure there is a balance here
//                if model.balance != nil {
                    page = .first
//                }
            }
        } content: {
            PlaidView()
        }
        .onDisappear {
            editing = false
        }
    }
    
    @ViewBuilder
    var linkContent: some View {
        VStack(spacing: 30) {
            Color.clear
                .frame(height: photoHeight)
                .overlay {
                    photo
                        .offset(y: -photoHeight / 2)
                }
            
            Image("link.bank")
            
            Text("Link your balance to see where your wealth ranks on the leaderboard")
                .font(.large)
                .padding(.horizontal, 11)
            
            Text("Don’t worry, your bank balance will be hidden from other users")
                .font(.sm)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background {
                    Capsule()
                        .stroke(lineWidth: 1.3)
                }
            
            Button("Continue") {
                showPlaid = true
            }
            .buttonStyle(WLButtonStyle())
        }
    }
    
    @ViewBuilder
    var firstName: some View {
        VStack(spacing: 30) {
            Image("first.name")
            
            TextField("First name", text: $model.firstName)
                .focused($editing)
                .task {
                    editing = true
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background {
                    Capsule()
                        .stroke(lineWidth: 1.5)
                }
            
            Button("Continue") {
                page = .last
            }
            .buttonStyle(WLButtonStyle())
        }
    }
    
    @ViewBuilder
    var lastName: some View {
        VStack(spacing: 30) {
            Image("last.name")
            
            TextField("Last name", text: $model.lastName)
                .focused($editing)
                .task {
                    editing = true
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background {
                    Capsule()
                        .stroke(lineWidth: 1.5)
                }
            
            Button("Continue") {
                Task {
                    page = .picture
                    editing = false
                }
            }
            .buttonStyle(WLButtonStyle())
        }
    }
    
    @ViewBuilder
    var addPhoto: some View {
        VStack(spacing: 30) {
            Image("add.photo")
            
            PhotosPicker(selection: $photoItem, matching: .images) {
                if let photo = model.photo {
                    EditPhotoButton(photo: photo)
                } else {
                    ZStack {
                        Image("friends.background")
                            .background {
                                Circle()
                                    .foregroundColor(.white)
                                    .padding(15)
                                    .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
                            }
                        Image("plus")
                            .offset(y: -3)
                    }
                }
            }
            .disabled(loading)

            Button("Continue") {
                Task {
                    loading = true
                    do {
                        try await model.createUser()
                        showing = false
                    } catch {
                        print(error.localizedDescription)
                    }
                    loading = false
                }
            }
            .onChange(of: photoItem) { _ in
                Task {
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            model.photo = image
                            return
                        }
                    }

                    print("Failed")
                }
            }
            .buttonStyle(WLButtonStyle(loading : $loading))
            .disabled(model.photo == nil || loading)
        }
        .task {
            editing = false
        }
    }
    
    var photo: some View {
        ZStack {
            Image("friends.background")
                .background {
                    Circle()
                        .foregroundColor(.white)
                        .padding(15)
                        .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
                }
            Image("cash")
                .offset(y: -3)
        }
        .background {
            GeometryReader { g in
                Color.clear
                    .onAppear {
                        photoHeight = g.size.height / 2
                    }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showing: .constant(true), page: .constant(.first))
            .environmentObject(Model())
    }
}
