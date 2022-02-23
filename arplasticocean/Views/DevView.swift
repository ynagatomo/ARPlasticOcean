//
//  DevView.swift
//  arplasticocean
//
//  Created by Yasuhito NAGATOMO on 2022/02/22.
//

#if DEBUG
import SwiftUI
import RealityKit

struct DevView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appStateController: AppStateController

    @State private var cleanupCountText = ""
    @State private var isOnToggleA = false
    @State private var isOnToggleB = false
    @State private var isOnToggleC = false

    let assetNames = ["sample.usdz", "sea.usdz", "fishC.usdz", "bottleA.usdz"]
    @State private var dumpAsset = 0

    private var currentCleanupCountText: String {
        String(appStateController.cleanupCount)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .padding(10)
                }
                .tint(.orange)
                Spacer()
            }
            List {
                Section("Count [0...]") {
                    TextField(currentCleanupCountText,
                              text: $cleanupCountText,
                              onCommit: {
                        if let count = Int(cleanupCountText) {
                            appStateController.setCleanupCount(count)
                        } else {
                            cleanupCountText = ""
                        }
                    })
                        .textFieldStyle(.roundedBorder)
                }
                Section("Assets") {
                    HStack {
                        Text("Model")
                        Spacer()
                        Picker(selection: $dumpAsset, label: Text("Model")) {
                            ForEach(0 ..< assetNames.count) {
                                Text(assetNames[$0])
                            }
                        }
                        //  .pickerStyle(SegmentedPickerStyle())
                        .pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        Spacer()
                        Button(action: { dump(assetName: assetNames[dumpAsset]) },
                               label: {
                            Text("  Dump  ")
                        })
                    }
                }
                Section("Setting A") {
                    Toggle("Option A", isOn: $isOnToggleA)
                    Toggle("Option B", isOn: $isOnToggleB)
                    Toggle("Option C", isOn: $isOnToggleC)
                }
                .tint(.orange)
                // .listRowSeparator(.hidden) // iOS 15+
            } // List
            .listStyle(SidebarListStyle()) // iOS 14+
            .buttonStyle(.bordered) // iOS 15+
        } // VStack
        .padding()
    } // View
}

struct DevView_Previews: PreviewProvider {
    static let appStateController = AppStateController()
    static var previews: some View {
        DevView()
            .environmentObject(appStateController)
    }
}

extension DevView {
    private func dump(assetName name: String) {
        if let entity = try? Entity.load(named: name) {
            dumpRealityEntity(entity)
        } else {
            debugLog("Failed to load \(name) as an Entity.")
        }
    }
}
#endif