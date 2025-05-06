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
    
    private let themeKey = "selectedTheme"
    
    init() {
        
    }
}

// MARK: - Methods

extension SettingsViewModel {
    func fetchThemeMode() -> Int {
        UserDefaults.standard.integer(forKey: themeKey)
    }
    
    func updateNotificationStatus(isOn: Bool) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Notification status updated: \(granted)")
        }
    }
    
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
}
