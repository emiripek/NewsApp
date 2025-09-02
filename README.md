# NewsApp

A simple, production‑minded iOS news application built with UIKit and MVVM. It fetches headlines from NewsAPI, supports search with debouncing, infinite scrolling, detail views, theme selection, and basic notification permission handling.

## Features
- Top headlines: Fetches country‑specific top news (default: US)
- Search: Debounced search with minimal text length checks
- Pagination: Infinite scroll for smooth content loading
- Detail view: Full article headline, image, and description
- Theming: System/Light/Dark appearance selection
- Notifications: Request and reflect authorization status
- Settings: Rate app, Privacy Policy, Terms of Use (opens in Safari)
- Splash + Tabs: Clean splash screen and a two‑tab layout (News, Settings)

## Tech Stack
- Language: Swift 5
- UI: UIKit (programmatic constraints via a custom `UIView.setupAnchors` helper)
- Architecture: MVVM + lightweight service layer
- Networking: URLSession with a small `NetworkManager` wrapper
- Images: Kingfisher (Swift Package Manager)
- Other: StoreKit, SafariServices, UserNotifications

## Project Structure
- `NewsApp/App`: App/Scene lifecycle and window setup
- `NewsApp/Scenes`:
  - `Splash`: Launch splash then routes to the tab bar
  - `TabBarController`: Hosts News and Settings in navigation stacks
  - `News`: `NewsVC`, `NewsViewModel`, `NewsCell` (list, search, pagination)
  - `Detail`: `DetailVC`, `DetailViewModel` (article detail)
  - `Settings`: `SettingsVC`, `SettingsViewModel`, `SettingsItem` (theme, notifications, rate, legal)
- `NewsApp/Network`: `NetworkManager`, `NewsService`, `NetworkConstants`, `NetworkError`
- `NewsApp/Models`: `NewsModel` (API response and `Article`)
- `NewsApp/Utilites/Extensions`: `UIView+Ext` for Auto Layout utility
- `NewsApp/Resources`: Launch screen and asset catalog

## Key Flows
- Headlines: `NewsService.fetchTopNews(country:page:pageSize:)` → `NewsViewModel.fetch(reset:)` → updates `articles` → `NewsVC.reloadData()`
- Search: Debounced in `NewsViewModel.search(term:)` → switches `mode` to `.search` or `.top` → `fetch(reset:)`
- Pagination: `UITableView.willDisplay` triggers `viewModel.loadMore()` when reaching the last row
- Detail: Selecting a row pushes `DetailVC` with its `DetailViewModel`
- Settings:
  - Theme: Persists selection in `UserDefaults` and applies in `SceneDelegate`
  - Notifications: `NotificationManager` requests permission and reflects current status
  - Rate/Legal: Uses StoreKit/SafariServices

## Requirements
- Xcode 15+
- iOS 17.0+ Deployment Target (as configured in the project)
- A NewsAPI key (https://newsapi.org)

## Setup
1) Open `NewsApp.xcodeproj` in Xcode.
2) Dependencies: The project uses Swift Package Manager; Xcode resolves Kingfisher automatically on first build.
3) API Key:
   - The key is currently defined in `NewsApp/Network/NetworkConstants.swift` as `apiKey`.
   - For production, consider moving it to a secure location (e.g., environment‑specific `.xcconfig`, remote config, or a build‑time script) and avoid committing secrets.
4) Build & Run on a simulator or device.

## Configuration
- Country for top headlines: Hardcoded as `"us"` in `NewsViewModel.fetchTopNews()` and `fetch(reset:)`. Adjust as needed.
- Search behavior: Debounce interval is `1s` and search triggers for terms with 3+ characters.
- Pagination: Page size is 10; tweak in calls to `NewsService`.
- Theme persistence: Stored under `selectedTheme` in `UserDefaults`.

## Notable Files
- `NewsApp/Network/NetworkManager.swift:1`: Thin Result‑based request wrapper over URLSession
- `NewsApp/Network/NewsService.swift:1`: Endpoint builder for top headlines and search
- `NewsApp/Scenes/News/NewsViewModel.swift:1`: Core list/search/pagination logic with debounce
- `NewsApp/Scenes/News/NewsVC.swift:1`: Table view, search controller, and navigation to detail
- `NewsApp/Scenes/News/NewsCell.swift:1`: Cell layout and image loading via Kingfisher
- `NewsApp/Scenes/Detail/DetailVC.swift:1`: Detail presentation for selected article
- `NewsApp/Scenes/Settings/SettingsVC.swift:1`: Theme, notifications, rate app, and legal links
- `NewsApp/NotificationManager.swift:1`: Async notification permission request + status cache
- `NewsApp/Utilites/Extensions/UIView+Ext.swift:1`: Flexible Auto Layout helper

## Error Handling
- Centralized via `NetworkError` enum; `NetworkManager` maps transport/decoding issues to typed errors.
- UI currently logs failures to the console; adapt toasts/alerts per your UX needs.

## Privacy & Security
- Do not ship with a hardcoded API key. Prefer secure config management.
- The app opens external URLs (Privacy Policy, Terms) in `SFSafariViewController`.

## Roadmap Ideas
- Pull‑to‑refresh for headlines
- Offline caching and image prefetching
- Unit/UI tests for view models and networking
- Country/Category filters for headlines
- Error/empty states in UI
- Deep links and share sheet for articles

## Acknowledgements
- NewsAPI (https://newsapi.org)
- Kingfisher (https://github.com/onevcat/Kingfisher)

