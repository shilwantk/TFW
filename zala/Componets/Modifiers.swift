//
//  Modifiers.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import Foundation
import SwiftUI
import ZalaAPI
import SDWebImageSwiftUI
import Charts

enum LoadingType {
    case fullscreen
    case saving
}


enum LoadingState {

    case none
    
    case loading
    
    case initial
    
    case fetching

    case saving
    
    case delete
    
    case success

    case complete
    
    case failure
    
    case hide
    
    func show() -> Bool {
        switch self {
        case .none: false
        
        case .initial: false
        
        case .fetching: true
            
        case .loading: true
            
        case .saving: true
            
        case .success: true
            
        case .complete: true
            
        case .failure: true
            
        case .hide: false
            
        case .delete: true
            
        }
    }
    
    func message() -> String {
        switch self {
        case .none: return ""
            
        case .loading: return "loading"
            
        case .fetching: return "fetching"
            
        case .initial: return ""
        
        case .saving: return "saving"
            
        case .success: return "complete"
            
        case .complete: return "complete"
            
        case .failure: return "failed"
            
        case .delete: return "deleting"
            
        case .hide: return ""
            
        }
    }
}

public struct KeyValueFieldBackgroundModifier: ViewModifier {
    @Binding var value: String
    @Binding var isValid: Bool
    
    public func body(content: Content) -> some View {
        content
            .background {
                if value.isEmpty {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.shared.mediumBlack)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.shared.mediumBlack)
//                        .stroke(isValid ? Theme.shared.border : Theme.shared.red, lineWidth: 1)
                }
            }
    }
}


public struct OnFirstAppearModifier: ViewModifier {

    private let onFirstAppearAction: () -> ()
    @State private var hasAppeared = false
    
    public init(_ onFirstAppearAction: @escaping () -> ()) {
        self.onFirstAppearAction = onFirstAppearAction
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                onFirstAppearAction()
            }
    }
}


struct ZalaFulScreenLoadingView: View {
    
    var body: some View {
        VStack {
            logo
        }.background(Theme.shared.black)
    }
    
    var logo:some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("logo")
                Spacer()
            }
            Spacer()
        }
    }
}

struct IconModifier: ViewModifier {
    
    @State var color: Color
    @State var imageColor: Color
    @State var size: (bg:CGFloat, icon: CGFloat)
    @State var isSquare: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            if isSquare {
                Rectangle()
                    .fill(color)
                    .frame(width: size.bg, height: size.bg)
            } else {
                Circle()
                    .fill(color)
                    .frame(width: size.bg, height: size.bg)
            }
            content
                .frame(width: size.icon, height: size.icon)
                .aspectRatio(contentMode: .fit)
                .symbolRenderingMode(.palette)
                .foregroundColor(imageColor)
        }
    }
}

struct LoadingModifier: ViewModifier {
        
    @Binding var state: LoadingState
    @State var type: LoadingType
    @State var hide: Bool = false
    
    func body(content: Content) -> some View {
        if type == .fullscreen {
            showFullScreen(content: content)
        } else {
            showComplete(content: content)
        }
    }
    @ViewBuilder
    fileprivate func showFullScreen(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content
                    .disabled(state.show())
                    .blur(radius: state.show() ? 3 : 0)
                
                VStack {
                    ZalaFulScreenLoadingView()
                }
                .frame(width: geometry.size.width / 2,
                       height: 200)
                .foregroundColor(Color.primary)
                .opacity(state.show() ? 1 : 0)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    fileprivate func showComplete(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content
                    .disabled(state.show())
                    .blur(radius: state.show() ? 3 : 0)
                
                if state.show() {
                    loadingIndicatorView(geometry: geometry)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: state) { _ ,newValue in
                if newValue == .complete && hide {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        state = .hide
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func loadingIndicatorView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .center, spacing: 15) {
            if state == .saving {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(2)
            } else if state == .complete {
                Image.selected
                    .resizable()
                    .frame(width: 44, height: 44)
            } else if state == .failure {
                Image.exclamationmarkFill
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.red)
                    .frame(width: 44, height: 44)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(2)
                    
            }
            
            Text("\(state.message())")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .foregroundStyle(.secondary)
                .font(.subheadline.bold())
        }
        .frame(width: geometry.size.width / 2,
               height: 150)
        .zIndex(2)
        .padding()
        .background(.black.opacity(0.7), in:
                        RoundedRectangle(cornerRadius: 16))
    }
}

struct PaginationModifier: ViewModifier {
    
    let isMoreDataAvailable: Bool
    
    var fetchMore: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
        if isMoreDataAvailable {
            ZStack {
                EmptyView()
            }
            .onAppear {
                if isMoreDataAvailable {
                    fetchMore?()
                }
            }
        }
    }
}

    

struct MapModifier: ViewModifier {
    
    @Binding var showMapOption: Bool
    @Binding var address: String
    @State var name: String
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog("Select", isPresented: $showMapOption, actions: {
                Button {
                    MapService.openAppleMaps(address: address, name: name)
                } label: {
                    Text("Show In Maps").style(color: Theme.shared.blue)
                }
            })
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct HeightModifier: ViewModifier {
    
    let totalRows: Int
    let rowHeight: CGFloat
    let padding: CGFloat
    
    func body(content: Content) -> some View {
        if totalRows == 0 {
            content.frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            let listHeight = (CGFloat((totalRows + 1)) * rowHeight) + padding
            if listHeight < UIScreen.screenHeight {
                content.frame(maxHeight: listHeight)
            } else {
                content.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct AlertModifier: ViewModifier {
    @Binding var show: Bool
    let msg: String
    let fadeOut: CGFloat?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                ZStack {
                    VStack(alignment: .center, spacing: 5) {
                        Image.selected
                            .resizable()
                            .frame(width: 44, height: 44)
                        Text(msg)
                            .foregroundColor(.white)
                            .foregroundStyle(.secondary)
                            .font(.subheadline.bold())
                    }
                    .frame(minHeight: 110)
                    .zIndex(2)
                    .padding()
                    .background(.black.opacity(0.7), in:
                                    RoundedRectangle(cornerRadius: 16))
                }
                .onAppear {
                    if let fadeOut {
                        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOut, execute: {
                            self.show = false
                        })
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            self.show = false
        }
    }
    
}
struct ButtonActiveModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                  LinearGradient(
                    stops: [
                      Gradient.Stop(color: Color(red: 0.25, green: 0.28, blue: 0.28), location: 0.00),
                      Gradient.Stop(color: Color(red: 0.53, green: 0.55, blue: 0.55), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                  )
                )
                .cornerRadius(50)
        } else {
            content
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Theme.shared.editGray)
                .cornerRadius(50)
        }
    }
}

struct ChartViewModifier: ViewModifier {
    
    @Binding var isScrollable: Bool
    
    func body(content: Content) -> some  View {
        if isScrollable {
            content
                .chartScrollableAxes(.horizontal)
        } else {
            content
        }
    }
}

struct ListContainerModifier: ViewModifier {
    @State var inner: Bool = false
    func body(content: Content) -> some View {
        if inner {
            content
                .background(.white)
                .cornerRadius(15)
                .padding(8)
        } else {
            content
                .background(Theme.shared.graySplit)
                .cornerRadius(15)
                .padding(8)
        }
    }
}

extension Button {
    func button(active: Bool) -> some View {
        modifier(ButtonActiveModifier(isActive: active))
    }
}

extension Text {
    func button(active: Bool) -> some View {
        modifier(ButtonActiveModifier(isActive: active))
    }
}

extension List {
    func dynamicListHeight(totalRows: Int,rowHeight: CGFloat, padding: CGFloat)  -> some View {
        modifier(HeightModifier(totalRows: totalRows, rowHeight: rowHeight, padding: padding))
    }
}

extension Button {
    
    func selectionBackground(selected:Binding<Bool>)  -> some View {
        modifier(SegmentedButtonBackgroundModifier(isSelected: selected))
    }
}

extension View {
    
    func align(_ alignment: Alignment) -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func dynamicViewHeight(totalRows: Int,rowHeight: CGFloat, padding: CGFloat)  -> some View {
        modifier(HeightModifier(totalRows: totalRows, rowHeight: rowHeight, padding: padding))
    }
    
    func confirmation(show:Binding<Bool>, msg: String, fadeOut: CGFloat = 2.0)   -> some View {
        modifier(AlertModifier(show: show, msg: msg, fadeOut: fadeOut))
    }
    
    func containerUI() -> some View {
        modifier(ListContainerModifier())
    }
    
    func innerContainerUI() -> some View {
        modifier(ListContainerModifier(inner: true))
    }
    
    func showMap(showMapOption: Binding<Bool>, address: Binding<String>, name: String) -> some View {
        modifier(MapModifier(showMapOption: showMapOption, address: address, name: name))
    }
    
    func paginate(more: Bool, fetchMore: @escaping ()->()) -> some View {
        modifier(PaginationModifier(isMoreDataAvailable: more, fetchMore: fetchMore))
    }
    
    func loading(state: Binding<LoadingState>, type: LoadingType = .fullscreen, hide: Bool = false)  -> some View {
        modifier(LoadingModifier(state: state, type: type, hide: hide))
    }
    
    func onFirstAppear(_ onFirstAppearAction: @escaping () -> () ) -> some View {
        return modifier(OnFirstAppearModifier(onFirstAppearAction))
    }
    
    func acitiveInactiveBackground(value: Binding<String>, isValid: Binding<Bool>) -> some View {
        return modifier(KeyValueFieldBackgroundModifier(value: value, isValid: isValid))
    }
    
    func toolbarWith(title: String, session: Binding<SessionTransitionState>, completion: ((_ type: ZalaToolbarModifer.ActionType) -> ())? = nil)-> some View {
        return modifier(ZalaToolbarModifer(title: title, session: session, handler: completion))
    }
        
    func imageSelection(image: Binding<UIImage>, showPhoto: Binding<Bool>) -> some View {
        return modifier(ImagePickerModifer(selectedImage: image, didTapPhoto: showPhoto))
    }
    
    func previewImage(image: Binding<PreviewImage?>) -> some View {
        return modifier(ImagePreviewModifier(selImage: image))
    }
    
    func protocolOverlay(show: Binding<Bool>) -> some View {
        return modifier(ProtocolOverlayModifier(show: show))
    }
    
    func isChartScrollableAxes(isScrollable: Binding<Bool>) -> some View {
        return modifier(ChartViewModifier(isScrollable: isScrollable))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Image {
    
    func circleIcon(bgColor: Color,
                    imageColor: Color,
                    size: (bg:CGFloat, icon: CGFloat)) -> some View {
        return modifier(IconModifier(color: bgColor, imageColor: imageColor, size: size))
    }
    
    func squareIcon(bgColor: Color,
                    imageColor: Color,
                    size: (bg:CGFloat, icon: CGFloat)) -> some View {
        return modifier(IconModifier(color: bgColor, imageColor: imageColor, size: size, isSquare: true))
    }
}

struct CarePlanProgressViewStyle: ProgressViewStyle {
    
  var color: Color

  func makeBody(configuration: Configuration) -> some View {
      ProgressView(configuration)
          .accentColor(color)
          .frame(height: 8.0) // Manipulate height, y scale effect and corner radius to achieve your needed results
          .scaleEffect(x: 1, y: 2, anchor: .center)
          .clipShape(RoundedRectangle(cornerRadius: 6))
  }
}
    
struct ImagePickerModifer: ViewModifier {
    @Binding var selectedImage: UIImage
    @Binding var didTapPhoto: Bool
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showCameraSheet: Bool = false
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog("Select", isPresented: $didTapPhoto, actions: {
                Button {
                    sourceType = .camera
                    self.showCameraSheet.toggle()
                } label: {
                    Text("Camera")
                }
                Button {
                    sourceType = .photoLibrary
                    self.showCameraSheet.toggle()
                } label: {
                    Text("Photo Library")
                }
            })
            .fullScreenCover(isPresented: $showCameraSheet) {
                ImagePicker(sourceType: sourceType) { img in
                    selectedImage = img
                }
            }
    }
}
struct ZalaToolbarModifer: ViewModifier {
    
    enum ActionType {
        case profile
        case notifications
        case message
        case none
    }
    
    @State var title: String
    @Binding var session: SessionTransitionState
    @State var handler: ((_ type: ActionType) -> ())? = nil
    @State var notificationService: NotificationService = NotificationService()
    @State var messageService: MessageService = MessageService()
    @State var newNotification: Bool = false
    @State var newMessage: Bool = false
    
    @State private var showAccount: Bool = false
    @State private var showNotifications: Bool = false
    @State private var showMessages: Bool = false
    
    func body(content: Content) -> some View {
        content
            .task {
                notificationService.fetchNotifications()
                messageService.fetchUnreadConversations()
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .style(color:.white, size:.regular, weight: .w800)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showAccount.toggle()
                        handler?(.profile)
                    } label: {
                        if let url = Network.shared.account?.profileURL(), !url.isEmpty {
                            WebImage(url: URL(string: url),
                                     options: .continueInBackground)
                                .resizable()
                                .interpolation(.high)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 25, height: 25, alignment: .center)
                        } else {
                            Image.iconProfile
                        }
                        
                    }
                }
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button {
                        self.showNotifications.toggle()
                        handler?(.notifications)
                    } label: {
                        Image.bell
                    }
                    .badgeValue(showBadge: $notificationService.newNotification)
                    
                    Button {
                        showMessages.toggle()
                        handler?(.message)
                    } label: {
                        Image.messages
                    }
                    .badgeValue(showBadge: $messageService.hasUnreadMessages)
                }
            })
            .fullScreenCover(isPresented: $showAccount) {
                AccountView(state: $session)
            }
            .fullScreenCover(isPresented: $showNotifications) {
                NavigationStack {
                    MyNotificationsView()
                }
            }
            .fullScreenCover(isPresented: $showMessages) {
                MessagesView()                
            }
    }
}

struct ProtocolOverlayModifier: ViewModifier {
    
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if !show {
                    RoundedRectangle(cornerRadius: 0).fill(
                        LinearGradient(
                          stops: [
                            Gradient.Stop(color: Theme.shared.darkGradientColor.primary, location: 0.00),
                            Gradient.Stop(color: Theme.shared.darkGradientColor.secondary, location: 1.00),
                          ],
                          startPoint: UnitPoint(x: 0.5, y: 0),
                          endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                }
            }
    }
}


struct ImagePreviewModifier: ViewModifier {
    
    @Binding var selImage: PreviewImage?
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $selImage) {
                selImage = nil
            } content: { preview in
                ImageViewer(image: preview.img)
                    .overlay(alignment: .topTrailing) {
                        closeButton
                    }
            }
    }
    
    private var closeButton: some View {
        Button {
            selImage = nil
        } label: {
            Image.close
        }
    }
}

struct SegmentedButtonBackgroundModifier: ViewModifier {
    
    @Binding var isSelected: Bool
    
    func body(content: Content) -> some View {
        if isSelected {
            content
                .background(RoundedRectangle(cornerRadius: 4).fill(
                    LinearGradient(
                      stops: [
                        Gradient.Stop(color: Theme.shared.grayGradientColor.primary, location: 0.00),
                        Gradient.Stop(color: Theme.shared.grayGradientColor.secondary, location: 1.00),
                      ],
                      startPoint: UnitPoint(x: 0.5, y: 0),
                      endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                ))
        } else {
            content
                .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.baseSlate))
        }
    }
}


struct IconView: View {
    @State var icon: Image
    @State var iconSize: CGSize
    @State var imageColor: Color
    @State var backgroundSize: CGFloat
    @State var gradinetColor: GradinetColor
    
    @State var isSquare: Bool = false
    
    var body: some View {
        ZStack {
            if isSquare {
                Rectangle()
                    .fill(
                        LinearGradient(
                          stops: [
                              Gradient.Stop(color: gradinetColor.primary, location: 0.00),
                            Gradient.Stop(color: gradinetColor.secondary, location: 1.00),
                          ],
                          startPoint: UnitPoint(x: 0.5, y: 0),
                          endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: backgroundSize, height: backgroundSize)
            } else {
                Circle()
                    .fill(
                        LinearGradient(
                          stops: [
                              Gradient.Stop(color: gradinetColor.primary, location: 0.00),
                            Gradient.Stop(color: gradinetColor.secondary, location: 1.00),
                          ],
                          startPoint: UnitPoint(x: 0.5, y: 0),
                          endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .frame(width: backgroundSize, height: backgroundSize)
            }
            icon
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize.width, height: iconSize.height, alignment: .center)                
                .foregroundColor(imageColor)
        }
    }
}


struct BadgeValue: ViewModifier {
    @Binding var showBadge: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            
            if showBadge {
                Circle()
                    .fill(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Theme.shared.orangeGradientColor.primary, location: 0.00),
                                Gradient.Stop(color: Theme.shared.orangeGradientColor.secondary, location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(.black, lineWidth: 4) // Stroke color and width
                    )
                    .frame(width: 12, height: 12)
                    .offset(x: -5, y: 1)
                    
            }
        }
    }
}

extension Button {
    func badgeValue(showBadge: Binding<Bool>) -> some View {
        self.modifier(BadgeValue(showBadge:showBadge))
    }
}
