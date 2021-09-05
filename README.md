
# danger-swift-jira

[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)

A Danger-Swift plugin for that links JIRA issues to pull requests for both GitHub and GitLab. Inspired by [RestlessThinker/danger-jira](https://github.com/RestlessThinker/danger-jira)

## Installation

Add `DangerSwiftJira` to your `Package.swift`

```Swift
.package(url: "https://github.com/AppDifferentia/danger-swift-jira", from: "0.0.1")
```

## Usage

Add to your `Dangerfile.swift`
```Swift
import Danger
import DangerSwiftJira

let danger = Danger()

// ...

let jira = DangerSwiftJira(danger: danger)
jira.check(
        keys: ["KEY", "PM"],
        url: URL(string: "https://myjira.atlassian.net/browse")!,
        emoji: ":link:",
        shouldSearchTitle: true,
        shouldSearchCommits: false,
        failOnWarning: false,
        reportMissing: true,
        skippable: true
    )
```

## Skipping
You can skip danger checking for a JIRA issue by having [no-jira] in your title or PR body.

## License
MIT