//
//  Logger+Portfolio.swift
//  portfolio
//
//

import OSLog

extension Logger {

    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.luizsoares.portfolio"

    static let network = Logger(subsystem: subsystem, category: "network")

}
