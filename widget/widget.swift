//
//  widget.swift
//  widget
//
//  Created by Alexander on 03.12.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let entryDate = Date()
        let dateStr = DateFormatter.dateByDots.string(from: entryDate)
        let matters = SharedDefaults.stringArray(forKey: "Matters_\(dateStr)")
        return SimpleEntry(date: entryDate, matters: matters ?? [])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entryDate = Date()
        let dateStr = DateFormatter.dateByDots.string(from: entryDate)
        let matters = SharedDefaults.stringArray(forKey: "Matters_\(dateStr)")
        let entry = SimpleEntry(date: entryDate, matters: matters ?? [])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let dateStr = DateFormatter.dateByDots.string(from: entryDate)
            let matters = SharedDefaults.stringArray(forKey: "Matters_\(dateStr)")
            let entry = SimpleEntry(date: entryDate, matters: matters ?? [])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let matters: [String]
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            Gauge(value: 1) {
                Image(systemName: "note.text.badge.plus")
            }
            .foregroundColor(Color("AccentColor"))
            .gaugeStyle(.accessoryCircularCapacity)
        case .accessoryRectangular:
            VStack (alignment: .leading) {
                if !entry.matters.isEmpty {
                    ForEach(entry.matters, id: \.self) { todo in
                        HStack {
                            Image(systemName: "circle")
                            Text(todo)
                                .widgetAccentable()
                                .privacySensitive()
                        }
                    }
                } else {
                    Text("✨ No tasks for you\n✨ Enjoy your day")
                }
            }
        default: Text("Not implemented")
        }
        
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today Widget")
        .description("This widget lets you see your relevant tasks and quickly launch the Today app")
        .supportedFamilies([.accessoryRectangular])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(date: Date(), matters: ["Note 1", "Note 2"]))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
    }
}
