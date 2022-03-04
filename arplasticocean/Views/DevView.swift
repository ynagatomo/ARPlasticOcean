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
    @Environment(\.presentationMode) var presentationMode
    // @Environment(\.dismiss) private var dismiss // iOS 15.0+
    @EnvironmentObject var appStateController: AppStateController

    @State private var cleanupCountText = ""
    @State private var showingARDebugOptions = true
    @State private var singleRefuse = true
    @State private var showingFishRoutes = true
    @State private var showingFishTargets = true

    let assetNames = ["stage1.usdz",
                      "boat1.usdz",
                      "umeiromodoki.usdz",
                      "bag.usdz", "bottle.usdz", "net.usdz",
                      "debris1.usdz", "debris2.usdz"
    ]
    @State private var dumpAsset = 0

    private var currentCleanupCountText: String {
        String(appStateController.cleanupCount)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: dismiss) { //  dismiss.callAsFunction) { // iOS 15.0+
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .padding(10)
                }
                // .tint(.orange) // iOS 15.0+
                Spacer()
            }
            List {
                Section(content: {
                    Text(String("Saved Cleaned Count = \(appStateController.savedCleanupCount)"))
                    Text(String("Last App Review Cleaned Count = \(appStateController.lastAppReviewCleanupCount)"))
                    Text(String("Approved Medal Level = \(appStateController.approvedMedalLevel)"))
                }, header: { Text(String("UserDefaults")) })
                Section(content: { // Section("Count [0...]") { // iOS 15.0+
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
                    }, header: {Text(String("Count [0...]"))})
                Section(content: { // Section("Assets") { // iOS 15.0+
                        HStack {
                            Text(String("Model"))
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
                                Text(String("Dump"))
                                    .foregroundColor(Color.white)
                                    .padding(4)
                                    .padding(.horizontal)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            })
                        }
                    }, header: { Text(String("Assets")) })
                Section(content: { // Section("Setting A") { // iSO 15.0+
                    Toggle(String("AR Debug Options"), isOn: $showingARDebugOptions)
                        .onChange(of: showingARDebugOptions) { value in
                            devConfiguration.showingARDebugOptions = value
                        }
                    Toggle(String("Single Refuse"), isOn: $singleRefuse)
                        .onChange(of: singleRefuse) { value in
                            devConfiguration.singleRefuse = value
                        }
                    Toggle(String("Show fish routes"), isOn: $showingFishRoutes)
                        .onChange(of: showingFishRoutes) { value in
                            devConfiguration.showingFishRoutes = value
                        }
                    Toggle(String("Show fish targets"), isOn: $showingFishTargets)
                        .onChange(of: showingFishTargets) { value in
                            devConfiguration.showingFishTargets = value
                        }
                    }, header: { Text(String("Dev Configuration")) })
                // .tint(.orange) // iOS 15.0+
                // .listRowSeparator(.hidden) // iOS 15+
            } // List
            .listStyle(SidebarListStyle()) // iOS 14+
            // .buttonStyle(.bordered) // iOS 15+
        } // VStack
        .padding()
    } // View

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
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
