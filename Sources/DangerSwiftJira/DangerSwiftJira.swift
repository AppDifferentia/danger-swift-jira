import Danger
import Foundation

public final class DangerSwiftJira {
    private let danger: DangerDSL

    private lazy var prTitle: String = {
        danger.gitLab?.mergeRequest.title ?? danger.github.pullRequest.title
    }()

    private lazy var prBody: String? = {
        danger.gitLab?.mergeRequest.description ?? danger.github.pullRequest.body
    }()

    /// Public initializer.
    /// - Parameter danger: The danger DSL instance. Default to call `Danger()`
    public init(danger: DangerDSL = Danger()) {
        self.danger = danger
    }

    /// Checks the PR for JIRA keys and links them.
    /// - Parameters:
    ///   - keys: An array of JIRA project keys e.g. KEY, JIRA etc
    ///   - url: The JIRA host URL e.g. https://myjira.atlassian.com
    ///   - emoji: The emoji you want to display in the danger message. Default to `":link:"` or 🔗
    ///   - shouldSearchTitle: Option to search JIRA issue in PR title. Default to `true`
    ///   - shouldSearchCommits: Option to search JIRA issue in commit messages in the PR. Default to `false`
    ///   - failOnWarning: Option to fail danger if no JIRA issue is found. Default to `false`
    ///   - reportMissing: Option to report if no JIRA issue is found. Default to `true`
    ///   - skippable: Option to skip report if `"no-jira"` is provided in PR title, description or commits
    public func check(
        keys: [String],
        url: URL,
        emoji: String = ":link:",
        shouldSearchTitle: Bool = true,
        shouldSearchCommits: Bool = false,
        failOnWarning: Bool = false,
        reportMissing: Bool = true,
        skippable: Bool = true
    ) {
        if skippable, shouldSkipJira(shouldSearchTitle: shouldSearchTitle) {
            return
        }

        let jiraIssues = findJiraIssues(
            keys: keys,
            shouldSearchTitle: shouldSearchTitle,
            shouldSearchCommit: shouldSearchCommits
        )

        guard jiraIssues.isEmpty else {
            let jiraLinks = jiraIssues
                .map { htmlLink(url: url, issue: $0) }
                .joined(separator: ", ")
            message("\(emoji) \(jiraLinks)")
            return
        }

        if reportMissing {
            let message = "This PR does not contain any JIRA issue keys in the PR title or commit messages (e.g. KEY-123)"
            if failOnWarning {
                fail(message)
            } else {
                warn(message)
            }
        }
    }

    func findJiraIssues(keys: [String] = [], shouldSearchTitle: Bool = true, shouldSearchCommit: Bool = true) -> [String] {
        let keys = keys.joined(separator: "|")
        let pattern = #"((?:\#(keys))-[0-9]+)"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        var jiraIssues = Set<String>()

        func findJiraIssue(in text: String) {
            let range = NSRange(location: 0, length: text.utf16.count)
            regex.matches(in: text, options: [], range: range)
                .forEach { match in
                    let matchedString = (text as NSString).substring(with: match.range)
                    jiraIssues.insert(matchedString)
                }
        }

        if shouldSearchTitle {
            findJiraIssue(in: prTitle)
        }

        if shouldSearchCommit {
            danger.git.commits
                .map(\.message)
                .forEach(findJiraIssue(in:))
        }

        if jiraIssues.isEmpty {
            prBody.map(findJiraIssue(in:))
        }

        return [String](jiraIssues)
    }

    func shouldSkipJira(shouldSearchTitle: Bool = true) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: "no-jira") else {
            return false
        }

        func matched(in text: String) -> Bool {
            regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) != nil
        }

        if shouldSearchTitle, matched(in: prTitle) {
            return true
        }

        if let prBody = prBody, matched(in: prBody) {
            return true
        }

        return false
    }

    func htmlLink(url: URL, issue: String) -> String {
        let href = url.appendingPathComponent(issue)
        return "<a href=\(href.absoluteString)>\(issue)</a>"
    }
}
