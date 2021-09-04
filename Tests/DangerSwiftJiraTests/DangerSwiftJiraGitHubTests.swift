import XCTest
@testable import DangerSwiftJira
@testable import Danger
import DangerFixtures

final class DangerSwiftJiraGitHubTests: XCTestCase {

    private var dangerDSL: DangerDSL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        dangerDSL = parseDangerDSL(with: DSLGitHubJiraJSON)
    }

    override func tearDownWithError() throws {
        dangerDSL = nil
        resetDangerResults()

        try super.tearDownWithError()
    }

    func testFindJiraIssueInPullRequestTitle() {
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        let issues = dangerJira.findJiraIssues(keys: ["TEST"], shouldSearchTitle: true, shouldSearchCommit: false)

        XCTAssertEqual(issues, ["TEST-123"])
    }

    func testFindJiraIssueInPullRequestCommits() {
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        let issues = dangerJira.findJiraIssues(keys: ["TEST"], shouldSearchTitle: false, shouldSearchCommit: true)

        XCTAssertEqual(issues, ["TEST-123"])
    }

    func testFindJiraIssueInPullRequestBody() {
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        let issues = dangerJira.findJiraIssues(keys: ["TEST"], shouldSearchTitle: false, shouldSearchCommit: false)

        XCTAssertEqual(issues, ["TEST-123"])
    }

    func testDoNotSkipJiraInPullRequest() {
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        XCTAssertFalse(dangerJira.shouldSkipJira(shouldSearchTitle: true))
        XCTAssertFalse(dangerJira.shouldSkipJira(shouldSearchTitle: false))
    }

    func testSkipJiraInPullRequest() {
        dangerDSL = parseDangerDSL(with: DSLGitHubSkipJiraJSON)
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        XCTAssertTrue(dangerJira.shouldSkipJira(shouldSearchTitle: true))
        XCTAssertTrue(dangerJira.shouldSkipJira(shouldSearchTitle: false))
    }


    func testOnlyFindUniqueIssues() {
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        let issues = dangerJira.findJiraIssues(keys: ["TEST", "MOCK"], shouldSearchTitle: true, shouldSearchCommit: false)

        XCTAssertEqual(issues.sorted(), ["MOCK-321", "TEST-123"])
    }

    func testGenerateJiraLink() {
        let dangerJira = DangerSwiftJira(danger: dangerDSL)
        let jiraHtmlLink = dangerJira.htmlLink(url: URL(string: "https://fakejira.mock")!, issue: "TEST-123")
        XCTAssertEqual(jiraHtmlLink, "<a href=https://fakejira.mock/TEST-123>TEST-123</a>")
    }

}
