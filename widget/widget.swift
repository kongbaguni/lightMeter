//
//  widget.swift
//  widget
//
//  Created by Changyeol Seo on 8/13/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry.empty
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry.lastEntry ?? .empty

        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [WidgetEntry] = [
            WidgetEntry.lastEntry ?? .empty
        ]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}



struct widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var nomalView: some View {
        VStack {
            if family == .systemMedium || family == .systemLarge || family == .systemExtraLarge {
                LightMetterIndicatorView(ev: entry.cameraEv, settingEv: entry.settingEv)
            }
            
            HStack (spacing:10){
                if family == .systemMedium || family == .systemLarge || family == .systemExtraLarge {
                    EVView(cameraEV: entry.cameraEv, settingEV: entry.settingEv)
                }
                
                VStack (alignment: .trailing){
                    Group {
                        Text("iso")
                        Text("aperture")
                        Text("shutterSpeed")
                    }
                    .foregroundStyle(.secondary)
                    .font(.system(size: 13))
                }
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 6, height: 50)
                    .foregroundStyle(.secondary)
                    .opacity(0.5)
                
                VStack (alignment: .leading){
                    Group {
                        Text(entry.iso)
                        Text(entry.aperture)
                        Text(entry.shutterSpeed)
                    }
                    .foregroundStyle(.primary)
                    .font(.system(size: 17))
                    .bold()
                }
            }
        }
    }
    
    var emptyView : some View {
        VStack {
            Image(systemName: "camera")
                .resizable()
                .scaledToFit()
        }
    }
    var body: some View {
        if entry.iso == "" {
            emptyView
        } else {
            nomalView
        }
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("widget description")
    }
}

#Preview(as: .systemSmall) {
    widget()
} timeline: {
    WidgetEntry(date: .now, iso: "100", aperture: "f2.8", shutterSpeed: "1/100", settingEv: 3.0, cameraEv: 4.0)
    WidgetEntry(date: .now, iso: "100", aperture: "f6.8", shutterSpeed: "1/1000",
                settingEv: 2.0, cameraEv: 1.0)
    WidgetEntry.empty
}
