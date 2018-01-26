AppDelegate-Firebase
============

Example of using Firebase PushMessages in iOS

## Instruction
1. Add these pods to your project

```ruby
pod 'Firebase/Core'
pod 'Firebase/Messaging'
```

2. Add ```GoogleService-Info.plist``` file to your project

3. Copy [AppDelegate+Firebase.swift](https://github.com/steelkiwi/AppDelegate-Firebase/blob/master/AppDelegate+Firebase.swift) file to your project

4. Add next code to your AppDelegate ```didFinishLaunchingWithOptions``` method:
```swift
initNotifications(application: application)
```

5. Add fcm token handling (storage / sending / etc) logic into ```didReceiveRegistrationToken``` method

6. And add this method to your AppDelegate file:
```swift
internal func openNotification(userData: PushNotification) {

    // Push handling here
}
```

[Example of AppDelegate](https://github.com/steelkiwi/AppDelegate-Firebase/blob/master/AppDelegate.swift)
