//
//  MainView.swift
//  LightMeter
//
//  Created by Changyeol Seo on 7/24/25.
//

import SwiftUI
import WidgetKit

struct MainView: View {
    @AppStorage("mainTabIdx") var tabIdx: Int = 0

    var setting: some View {
        NavigationLink {
            SettingView()
        } label: {
            ButtonImageView(systemName: "gearshape")
        }
    }

    func makeButton(isCurrent:Bool, image:String, text:String, onClick:@escaping()->Void) -> some View  {
        Button {
            onClick()
        } label: {
            VStack {
                Image(systemName: image)
                Text(text)
                    .font(.caption)
            }.foregroundStyle(isCurrent ? .white : .white.opacity(0.3))
        }
        .disabled(isCurrent)
        .padding(10)
        .frame(height: 65)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(
                    isCurrent
                    ? Color.mint.opacity(0.7)
                    : Color.gray.opacity(0.5)
                )
        }
        .safeGlassEffect(useInteractive: true, inShape: RoundedRectangle(cornerRadius: 5))
    }


    var main: some View {
        VStack {
            switch tabIdx {
            case 0:
                NormalModeView()
            case 1:
                FlashModeView()
            case 2:
                RangeModeView()
            default:
                EmptyView()
            }
            sidebar
        }
    }

    var sidebar : some View {
        HStack {
            Spacer()
            makeButton(isCurrent: tabIdx==0, image: "camera.aperture", text: "camera") {
                tabIdx = 0
            }

            makeButton(isCurrent: tabIdx==1, image: "bolt.fill", text: "bolt") {
                tabIdx = 1
            }

            makeButton(isCurrent: tabIdx==2, image: "ruler.fill", text: "ruler") {
                tabIdx = 2
            }


            Spacer()
            setting
        }

    }
    var body: some View {
        NavigationSplitView {
            main
        } detail: {
            PlaceHolderView()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { output in
            WidgetCenter.shared.reloadTimelines(ofKind: "widget")
        }
    }
}

#Preview {
    MainView()
}
