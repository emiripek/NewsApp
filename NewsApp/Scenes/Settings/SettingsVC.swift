//
//  SettingsVC.swift
//  NewsApp
//
//  Created by Emirhan İpek on 11.04.2025.
//

import UIKit
import StoreKit
import SafariServices

protocol SettingsVCProtocol: AnyObject {
    func updateSwitchValue(_ value: Bool)
    func openAppSettings()
}

final class SettingsVC: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: SettingsViewModel
    
    private let themeKey = "selectedTheme"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let switcher = UISwitch()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown Version"
        return label
    }()
    
    init(viewModel: SettingsViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

// MARK: - Objective Methods

@objc private extension SettingsVC {
    func didChangeTheme(_ sender: UISegmentedControl) {
        updateThemeMode(to: sender.selectedSegmentIndex)
    }
    
    func didToggleNotification(_ sender: UISwitch) {
        viewModel.updateNotificationStatus(isOn: sender.isOn)
    }
}

// MARK: - Private Methods
private extension SettingsVC {
    func configureView() {
        view.backgroundColor = .systemGroupedBackground
        addViews()
        configureLayout()
    }
    
    func addViews() {
        view.addSubview(tableView)
        view.addSubview(appVersionLabel)
    }
    
    func configureLayout() {
        tableView.setupAnchors(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
        
        appVersionLabel.setupAnchors(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingBottom: -16,
            centerX: view.centerXAnchor
        )
    }
    
    func updateThemeMode(to mode: Int) {
        UserDefaults.standard.set(mode, forKey: themeKey)
        switch mode {
        case 1:
            view.window?.overrideUserInterfaceStyle = .light
        case 2:
            view.window?.overrideUserInterfaceStyle = .dark
        default:
            view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func didSelect(item: SettingsItem) {
        switch item.type {
        case .rateApp: promptReview()
        case .privacyPolicy, .termsOfUse: openUrl("https://google.com")
        default: break
        }
    }
    
    func promptReview() {
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openUrl(_ url: String) {
        guard let urlToOpen = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: urlToOpen)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        didSelect(item: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        cell.tintColor = .systemRed
        cell.textLabel?.text = item.title
        cell.textLabel?.textAlignment = .natural
        cell.textLabel?.textColor = .label
        cell.imageView?.image = UIImage(systemName: item.iconName)
        
        switch item.type {
        case .theme:
            let segmentedControl = UISegmentedControl(items: ["Auto", "Light", "Dark"])
            segmentedControl.selectedSegmentIndex = viewModel.fetchThemeMode()
            segmentedControl.addTarget(self, action: #selector(didChangeTheme(_:)), for: .valueChanged)
            cell.accessoryView = segmentedControl
            
        case .notification:
            let switcher = UISwitch()
            viewModel.fetchNotificationStatus{ [weak self] in
                self?.switcher.isOn = $0
            }
            switcher.addTarget(self, action: #selector(didToggleNotification(_:)), for: .valueChanged)
            cell.accessoryView = switcher
            
        case .rateApp, .privacyPolicy, .termsOfUse:
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

extension SettingsVC: SettingsVCProtocol {
    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsURL) {
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsURL)
            }
        }
    }
    
    func updateSwitchValue(_ value: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.switcher.isOn = value
        }
    }
}
