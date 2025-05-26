//
//  SettingsViewModel.swift
//  NewsApp
//
//  Created by Emirhan İpek on 6.05.2025.
//

import Foundation
import UserNotifications

class SettingsViewModel {
    
    // MARK: - Properties
    
    var sections = SettingsSection.sections
    
    weak var delegate: SettingsVCProtocol?
    
    private var notificationManager: NotificationManager = .shared
    
    private let themeKey = "selectedTheme"
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleReturnFromSettings), name: .didReturnFromSettings, object: nil)
    }
}

// MARK: - Methods

extension SettingsViewModel {
    func fetchThemeMode() -> Int {
        UserDefaults.standard.integer(forKey: themeKey)
    }
    
    /// When the user requests permission for the first time and wants to open it
    func updateNotificationStatus(isOn: Bool) {
        
        Task {
            if !notificationManager.isRequested && isOn {
                try await notificationManager.requestNotificationPermissionWithAsync()
                await notificationManager.updateNotificationStatus()
                  delegate?.updateSwitchValue(notificationManager.isAuthorized)
            } else {
                delegate?.openAppSettings()
            }
        }
    }
    
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void) {
        completion(notificationManager.isAuthorized)
    }
    
    @objc
    func handleReturnFromSettings() {
        Task {
            await notificationManager.updateNotificationStatus()
            delegate?.updateSwitchValue(notificationManager.isAuthorized)
        }
    }
}

extension Notification.Name {
    static let didReturnFromSettings = Notification.Name("didReturnFromSettings")
}
