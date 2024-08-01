//
//  DoYourThingPriorityInformationView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 15.07.24.
//

/*import SwiftUI

struct DoYourThingPriorityInformationView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Priority.allCases, id: \.self) { priority in
                HStack {
                    Image(systemName: "circle.hexagongrid.circle")
                                            .foregroundColor(priority.color)
                                            .frame(width: 30, height: 30)
                    Text(priority.description)
                }
                .padding(.vertical, 4)
            }
            Spacer()
        }
        .padding()
    }
}

enum Priority: String, CaseIterable {
    case sehrHoch = "Sehr Hoch"
    case hoch = "Hoch"
    case mittel = "Mittel"
    case niedrig = "Niedrig"
    case sehrNiedrig = "Sehr Niedrig"

    var color: Color {
        switch self {
        case .sehrHoch:
            return .red
        case .hoch:
            return .orange
        case .mittel:
            return .yellow
        case .niedrig:
            return .green
        case .sehrNiedrig:
            return .blue
        }
    }

    var description: String {
        switch self {
        case .sehrHoch:
            return "Sehr Hoch = Rot\nDringende und kritische Aufgaben, die sofortige Aufmerksamkeit erfordern."
        case .hoch:
            return "Hoch = Orange\nWichtige Aufgaben, die zeitnah erledigt werden müssen, aber nicht so dringlich wie 'Sehr Hoch'."
        case .mittel:
            return "Mittel = Gelb\nAufgaben von mittlerer Wichtigkeit, die innerhalb eines moderaten Zeitrahmens erledigt werden sollten."
        case .niedrig:
            return "Niedrig = Grün\nWeniger wichtige Aufgaben, die erledigt werden sollten, wenn Zeit verfügbar ist."
        case .sehrNiedrig:
            return "Sehr Niedrig = Blau\nAufgaben von geringer Wichtigkeit, die bei Gelegenheit erledigt werden können."
        }
    }
}


#Preview {
    DoYourThingPriorityInformationView()
}*/


import SwiftUI

struct DoYourThingPriorityInformationView: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Priority.allCases, id: \.self) { priority in
                HStack {
                    Image(systemName: "circle.hexagongrid.circle")
                        .foregroundColor(priority.color)
                        .frame(width: 30, height: 30)
                    Text(priority.description)
                }
                .padding(.vertical, 4)
            }
            Spacer()
        }
        .padding()
    }
}

enum Priority: String, CaseIterable {
    case sehrHoch = "Sehr Hoch"
    case hoch = "Hoch"
    case mittel = "Mittel"
    case niedrig = "Niedrig"
    case sehrNiedrig = "Sehr Niedrig"

    var color: Color {
        switch self {
        case .sehrHoch:
            return .red
        case .hoch:
            return .orange
        case .mittel:
            return .yellow
        case .niedrig:
            return .green
        case .sehrNiedrig:
            return .blue
        }
    }

    var description: String {
        switch self {
        case .sehrHoch:
            return NSLocalizedString("veryHighDescription", comment: "Very High Description")
        case .hoch:
            return NSLocalizedString("highDescription", comment: "High Description")
        case .mittel:
            return NSLocalizedString("mediumDescription", comment: "Medium Description")
        case .niedrig:
            return NSLocalizedString("lowDescription", comment: "Low Description")
        case .sehrNiedrig:
            return NSLocalizedString("veryLowDescription", comment: "Very Low Description")
        }
    }
}

#Preview {
    DoYourThingPriorityInformationView()
}
