# PostlyiOSSwiftUI

A social media iOS app built with SwiftUI as part of the Postly iOS coding challenge. This is the SwiftUI counterpart to the UIKit version, sharing the same architecture and feature set.

## Features

- **Login** — authenticate with username/password or continue as a guest
- **Post List** — browse all posts with user avatars, usernames, titles, and descriptions
- **User Information** — tap any avatar or username to view user details in a sheet, with email domain validation

## How to Build and Run

1. Open `PostlyiOSSwiftUI.xcodeproj` in Xcode 16+
2. Select an iOS Simulator (iPhone 15 or later recommended)
3. Press `Cmd + R` to build and run

Minimum deployment target: **iOS 17.0**. No third-party dependencies or package managers required.

## API Endpoint

This app talks to a small, zero-dependency clone of the challenge API. The base URL is hardcoded to `http://192.168.2.56:3005/`, which is a Node server running on the author's local network — **it is not reachable from other networks**, so the app will fail to load data when cloned elsewhere.

To run against your own backend, change the base URL in `PostlyiOSSwiftUI/Services/NetworkService.swift` (`baseUrlString`). Expected contract:

- `GET /login` — HTTP Basic Auth header (empty credentials = guest) → `{ "api_key": "..." }`
- `GET /posts` — header `x-access-token: <api_key>` → list of posts
- `GET /users` — header `x-access-token: <api_key>` → list of users (each with an `avatar` URL)

## Architecture

The project follows the **MVVM + Coordinator** pattern with the **Observation** framework (`@Observable`) for state — no Combine.

```
Model          → Data structs (UserModel, PostModel, etc.)
ViewModel      → Business logic and state (@Observable, @MainActor)
View           → SwiftUI views (declarative UI bound to the view model)
Coordinator    → AppCoordinator drives navigation via NavigationStack(path:)
```

### Key Design Decisions

- **@Observable over ObservableObject** — view models use the iOS 17 Observation macro, so views track only the properties they actually read; no `@Published`/Combine subscriptions
- **Coordinator-driven navigation** — `AppCoordinator` owns a typed `[Route]` path; `RootView` binds it to a `NavigationStack`, keeping navigation out of the views
- **Dependency Injection** — a `DependencyContainer` builds views and view models, injecting services and navigation callbacks, making dependencies explicit and testable
- **Protocol-Oriented Networking** — `NetworkServiceProtocol` and `ImageLoaderServiceProtocol` abstract the network layer
- **Callback-based events** — view models surface navigation events (e.g. `onAuthenticated`) through injected closures rather than exposing navigation state directly
- **Async/Await** — all networking uses Swift concurrency; the post list joins users and posts with `async let`
- **Custom image loading** — `AvatarView` uses an injected `ImageLoaderService` with an in-memory cache instead of `AsyncImage`

## Project Structure

```
PostlyiOSSwiftUI/
├── PostlyiOSSwiftUIApp.swift          (app entry point)
├── Root/
│   ├── AppCoordinator.swift           (@Observable navigation path)
│   ├── Route.swift                    (Hashable navigation routes)
│   ├── RootView.swift                 (NavigationStack host)
│   └── DependencyContainer.swift      (view/view-model factory)
├── Models/
│   ├── UserModel.swift
│   ├── PostModel.swift
│   └── LoginResponse.swift
├── Services/
│   ├── NetworkService.swift
│   └── ImageLoaderService.swift
├── Screens/
│   ├── Login/
│   │   ├── LoginView.swift
│   │   └── LoginViewModel.swift
│   ├── PostList/
│   │   ├── PostListView.swift
│   │   ├── PostListViewModel.swift
│   │   ├── PostRowView.swift
│   │   └── AvatarView.swift
│   └── UserInfo/
│       └── UserInfoView.swift
└── Utilities/
    └── EmailValidator.swift
```

## Assumptions

- The guest flow uses empty credentials, which the API accepts
- User avatars are loaded asynchronously with an in-memory cache to avoid redundant network calls
- Posts without a matching user are filtered out rather than displayed with missing data
- Email domain validation only checks the suffix (.com, .net, .biz) as specified, not full RFC 5322 compliance

## Future Improvements

- **Disk Caching** — persist avatar images to disk for offline support
- **Pagination** — load posts in pages rather than all at once
- **Error Retry** — allow users to retry failed network requests from the error state
- **Search and Filter** — search or filter posts by user or keyword
- **Unit Tests** — add a test target covering view models, the email validator, and the coordinator
