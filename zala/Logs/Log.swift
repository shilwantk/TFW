//
//  Log.swift
//  zala
//
//  Created by Kyle Carriedo on 6/7/24.
//

import Foundation
import SwiftUI

enum LogKind: String, Codable, CaseIterable, Identifiable{
    case healthkit
    case request
    case basic
    
    var id: String { self.rawValue }
}
struct Log: Identifiable, Codable {
    
    var id = UUID()
    let message: String
    var kind: LogKind = .basic
    let date: Date
}


@Observable class LogManager {
    var logs: [Log] = []
    private let fileName = "logs.json"
    
    init() {
        loadLogs()
    }
    
    func addLog(_ message: String, kind: LogKind) {
        let newLog = Log(message: message, kind: kind, date: Date())
        logs.append(newLog)
        saveLogs()
    }
    
    func clearLogs() {
        logs.removeAll()
        saveLogs()
    }
    
    private func saveLogs() {
        do {
            let data = try JSONEncoder().encode(logs)
            if let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName) {
                try data.write(to: filePath)
            }
        } catch {}
    }
    
    private func loadLogs() {
        do {
            if let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName),
               FileManager.default.fileExists(atPath: filePath.path) {
                let data = try Data(contentsOf: filePath)
                logs = try JSONDecoder().decode([Log].self, from: data)
            }
        } catch {}
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}


import SwiftUI
import UIKit

struct LogView: View {
    @State private var logManager = LogManager()
    @State private var newLogMessage: String = ""
    @State private var selectedLogKind: LogKind = .basic
    @State private var filter: LogKind? = nil

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $filter) {
                    Text("All").tag(LogKind?.none)
                    ForEach(LogKind.allCases) { kind in
                        Text(kind.rawValue.capitalized).tag(LogKind?.some(kind))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                List(logManager.logs) { log in
                    VStack(alignment: .leading) {
                        Text(log.message)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = log.message
                                }) {
                                    Text("Copy Message")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                        Divider().background(.gray)
                        HStack {
                            Text(log.kind.rawValue)
                                .style(color: Theme.shared.orange)
                            Spacer()
                            Text("\(log.date)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    Spacer()
                }
                
                HStack {
                    TextField("Enter log message", text: $newLogMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newLogMessage.isEmpty {
                            logManager.addLog(newLogMessage, kind: .basic)
                            newLogMessage = ""
                        }
                    }) {
                        Text("Add Log")
                    }
                    .padding(.horizontal)
                }
                .padding()

                Button(action: {
                    logManager.clearLogs()
                }) {
                    Text("Clear Logs")
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
