import XCTest
import Foundation
@testable import MobileClientAccess

class MobileClientAccessSDKTests: XCTestCase {

	override func setUp(){
		self.continueAfterFailure = false
	}

	func testInvalidAuthHeader(){
		let exp = expectation(withDescription: "testMcaSdk")

		MobileClientAccessSDK.sharedInstance.authorizationContext(from: Consts.invalidAuthHeader) { (error, authContext) in
			XCTAssertNotNil(error, "error == nil")
			XCTAssertNil(authContext, "authContext != nil")
			exp.fulfill()
		}

		waitForExpectations(withTimeout: 3) { (error) in
			XCTAssertNil(error, "test timeout")
		}
	}

	func testBadStructureAuthHeader(){
		let exp = expectation(withDescription: "testMcaSdk")

		MobileClientAccessSDK.sharedInstance.authorizationContext(from: Consts.badStructureAuthHeader) { (error, authContext) in
			XCTAssertNotNil(error, "error == nil")
			XCTAssertNil(authContext, "authContext != nil")
			exp.fulfill()
		}

		waitForExpectations(withTimeout: 3) { (error) in
			XCTAssertNil(error, "test timeout")
		}
	}

	func testExpiredAuthHeader(){
		let exp = expectation(withDescription: "testMcaSdk")

		MobileClientAccessSDK.sharedInstance.authorizationContext(from: Consts.expiredAuthHeader) { (error, authContext) in
			XCTAssertNotNil(error, "error == nil")
			XCTAssertNil(authContext, "authContext != nil")
			exp.fulfill()
		}

		waitForExpectations(withTimeout: 3) { (error) in
			XCTAssertNil(error, "test timeout")
		}
	}

	func testValidAuthHeaderWithUserIdentity(){
		let exp = expectation(withDescription: "testMcaSdk")

		MobileClientAccessSDK.sharedInstance.authorizationContext(from: Consts.validAuthHeaderWithUserIdentity) { (error, authContext) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(authContext, "authContext == nil")
			XCTAssertNotNil(authContext?.appIdentity, "authContext?.appIdentity == nil")
			XCTAssertEqual(authContext?.appIdentity.id, "com.my.app", "authContext?.appIdentity.id != com.my.app")
			XCTAssertEqual(authContext?.appIdentity.version, "1.0", "authContext?.appIdentity.version != 1.0")

			XCTAssertNotNil(authContext?.deviceIdentity, "authContext?.deviceIdentity == nil")
			XCTAssertEqual(authContext?.deviceIdentity.id, "d7bf265d-55ae-3787-8058-66f97e7aa349", "authContext?.deviceIdentity.id != d7bf265d-55ae-3787-8058-66f97e7aa349")
			XCTAssertEqual(authContext?.deviceIdentity.OS, "Android", "authContext?.deviceIdentity.OS != Android")
			XCTAssertEqual(authContext?.deviceIdentity.OSVersion, "6.0", "authContext?.deviceIdentity.OSVersion != 6.0")
			XCTAssertEqual(authContext?.deviceIdentity.model, "Android SDK built for x86_64", "authContext?.deviceIdentity.model != Android SDK built for x86_64")

			XCTAssertNotNil(authContext?.userIdentity, "authContext?.userIdentity == nil")
			XCTAssertEqual(authContext?.userIdentity?.id, "testUser", "authContext?.userIdentity.id != testUser")
			XCTAssertEqual(authContext?.userIdentity?.authBy, "imf-authserver", "authContext?.userIdentity.authBy != imf-authserver")
			XCTAssertEqual(authContext?.userIdentity?.displayName, "testUser display", "authContext?.userIdentity.displayName != testUser display")

			XCTAssertNotNil(authContext?.userIdentity?.attributes, "authContext?.userIdentity.attributes == nil")
			XCTAssertEqual(authContext?.userIdentity?.attributes["foo"], "bar", "authContext?.userIdentity.attributes['foo'] != bar")

			exp.fulfill()
		}

		waitForExpectations(withTimeout: 3) { (error) in
			XCTAssertNil(error, "test timeout")
		}
	}

	func testValidAuthHeaderWithoutUserIdentity(){
		let exp = expectation(withDescription: "testMcaSdk")

		MobileClientAccessSDK.sharedInstance.authorizationContext(from: Consts.validAuthHeaderWithoutUserIdentity) { (error, authContext) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(authContext, "authContext == nil")
			XCTAssertNil(authContext?.userIdentity, "authContext?.userIdentity != nil")
			exp.fulfill()
		}

		waitForExpectations(withTimeout: 3) { (error) in
			XCTAssertNil(error, "test timeout")
		}
	}
	
	func testValidAuthHeaderWithoutIdHeader(){
		let exp = expectation(withDescription: "testMcaSdk")
		
		MobileClientAccessSDK.sharedInstance.authorizationContext(from: Consts.validAuthHeaderWithoutIdToken) { (error, authContext) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNil(authContext, "authContext != nil")
			exp.fulfill()
		}
		
		waitForExpectations(withTimeout: 3) { (error) in
			XCTAssertNil(error, "test timeout")
		}

	}
}


class Consts {
	static let invalidAuthHeader = "asdAS sadfa sdf as"

	static let badStructureAuthHeader = "Bearer asdf askjdga s;dl";

	static let expiredAuthHeader = "Bearer eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjEwNjAzMTE2ODgsImF1ZCI6IjJmZTM1NDc3LTUxYjAtNGM4Ny04MDNkLWFjYTU5NTExNDMzYiIsImlzcyI6Imh0dHA6XC9cL2FibXMubXlibHVlbWl4Lm5ldDo4MFwvaW1mLWF1dGhzZXJ2ZXJcL2F1dGhvcml6YXRpb25cLyIsInBybiI6IjYzODA4MDJkZjZkZjlhNzAzODA2MzVjMDA4MmJmOTEzMjA1MTc2ZTAifQ.UDLdkoCDcM9i3k1QR4NGVbJr2O7vic2v1PRKxetNF-ToOink-zQFfMLtHOIgfxxrI65hbo4b_jYYr4LHaryZNis3bb5YUbtfmH3EFkrp_UHQZVZ_X9OTQnA3zAu_VjDyB0ta8zMPHS3nXZfjqHg_WlPy2WpkfUh94Jwpj5l39mVKFOA3FyD6KPOv_DJQ3STiMBP62kJ9jYGyrURZJPFlAJ48ktiPPWQ9zms0x_lQLjGVkoIt8-SDy1n1pT3mfKhvie7unQbZUDdSSgoJnLEaFTO4LzBwn6b4TtQhSmEV_OjFqinOuTeqwYOZIpaqjGRD8h_0PeChcWCnXXwwuXyC5g eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjE0NjAzMTE2ODgsInN1YiI6Ijo6NjM4MDgwMmRmNmRmOWE3MDM4MDYzNWMwMDgyYmY5MTMyMDUxNzZlMCIsImltZi5hcHBsaWNhdGlvbiI6eyJpZCI6bnVsbCwidmVyc2lvbiI6IjEuMCJ9LCJhdWQiOiIyZmUzNTQ3Ny01MWIwLTRjODctODAzZC1hY2E1OTUxMTQzM2IiLCJpc3MiOiJodHRwOlwvXC9hYm1zLm15Ymx1ZW1peC5uZXQ6ODBcL2ltZi1hdXRoc2VydmVyXC9hdXRob3JpemF0aW9uXC8iLCJpYXQiOjE0NjAzMDgwODgsImltZi5kZXZpY2UiOnsiaWQiOiJkN2JmMjY1ZC01NWFlLTM3ODctODA1OC02NmY5N2U3YWEzNDkiLCJwbGF0Zm9ybSI6IkFuZHJvaWQiLCJtb2RlbCI6IkFuZHJvaWQgU0RLIGJ1aWx0IGZvciB4ODZfNjQiLCJvc1ZlcnNpb24iOiI2LjAifX0.aNSzQB16G9WPv8z1Q5nFyyQAvX5P-llkqmfOJiyO51krzFTiBZCx3WeqqnRA4Hd_ltQAReAq5JYp0ZHo0bN0qtdEeJBGXsR9PGj4uWWCFV1AQrZBBdZfn_Y_6MqkQng4k3VJh3896y3FBAB5qiubAuNt2-7WP-NOAAq-k_3myvyqOwkIcgqnlyCZ_TnayigSwBuiGnfMQ8AUl6vO05UuqGWhuaZNzduW826wI6P8_sjGZLv8f_ZTf5v2WHiK1RhEN-VnbQMV6nMDRtMS9n4M7KiFcGXkQn3KRsfYCTxtia0yXpaReACHm3mJt5xTNmunQ0tr62d49Quqhd0aoTqvHA";

	static let validAuthHeaderWithUserIdentity = "Bearer eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjE5NjAzMTE2ODgsImF1ZCI6IjJmZTM1NDc3LTUxYjAtNGM4Ny04MDNkLWFjYTU5NTExNDMzYiIsImlzcyI6Imh0dHA6XC9cL2FibXMubXlibHVlbWl4Lm5ldDo4MFwvaW1mLWF1dGhzZXJ2ZXJcL2F1dGhvcml6YXRpb25cLyIsInBybiI6IjYzODA4MDJkZjZkZjlhNzAzODA2MzVjMDA4MmJmOTEzMjA1MTc2ZTAifQ.UDLdkoCDcM9i3k1QR4NGVbJr2O7vic2v1PRKxetNF-ToOink-zQFfMLtHOIgfxxrI65hbo4b_jYYr4LHaryZNis3bb5YUbtfmH3EFkrp_UHQZVZ_X9OTQnA3zAu_VjDyB0ta8zMPHS3nXZfjqHg_WlPy2WpkfUh94Jwpj5l39mVKFOA3FyD6KPOv_DJQ3STiMBP62kJ9jYGyrURZJPFlAJ48ktiPPWQ9zms0x_lQLjGVkoIt8-SDy1n1pT3mfKhvie7unQbZUDdSSgoJnLEaFTO4LzBwn6b4TtQhSmEV_OjFqinOuTeqwYOZIpaqjGRD8h_0PeChcWCnXXwwuXyC5g eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjE0NjAzMTE2ODgsInN1YiI6Ijo6NjM4MDgwMmRmNmRmOWE3MDM4MDYzNWMwMDgyYmY5MTMyMDUxNzZlMCIsImltZi5hcHBsaWNhdGlvbiI6eyJpZCI6ImNvbS5teS5hcHAiLCJ2ZXJzaW9uIjoiMS4wIn0sImltZi51c2VyIjp7ImlkIjoidGVzdFVzZXIiLCJhdXRoQnkiOiJpbWYtYXV0aHNlcnZlciIsImRpc3BsYXlOYW1lIjoidGVzdFVzZXIgZGlzcGxheSIsImF0dHJpYnV0ZXMiOnsiZm9vIjoiYmFyIn19LCJhdWQiOiIyZmUzNTQ3Ny01MWIwLTRjODctODAzZC1hY2E1OTUxMTQzM2IiLCJpc3MiOiJodHRwOlwvXC9hYm1zLm15Ymx1ZW1peC5uZXQ6ODBcL2ltZi1hdXRoc2VydmVyXC9hdXRob3JpemF0aW9uXC8iLCJpYXQiOjE0NjAzMDgwODgsImltZi5kZXZpY2UiOnsiaWQiOiJkN2JmMjY1ZC01NWFlLTM3ODctODA1OC02NmY5N2U3YWEzNDkiLCJwbGF0Zm9ybSI6IkFuZHJvaWQiLCJtb2RlbCI6IkFuZHJvaWQgU0RLIGJ1aWx0IGZvciB4ODZfNjQiLCJvc1ZlcnNpb24iOiI2LjAifX0.aNSzQB16G9WPv8z1Q5nFyyQAvX5P-llkqmfOJiyO51krzFTiBZCx3WeqqnRA4Hd_ltQAReAq5JYp0ZHo0bN0qtdEeJBGXsR9PGj4uWWCFV1AQrZBBdZfn_Y_6MqkQng4k3VJh3896y3FBAB5qiubAuNt2-7WP-NOAAq-k_3myvyqOwkIcgqnlyCZ_TnayigSwBuiGnfMQ8AUl6vO05UuqGWhuaZNzduW826wI6P8_sjGZLv8f_ZTf5v2WHiK1RhEN-VnbQMV6nMDRtMS9n4M7KiFcGXkQn3KRsfYCTxtia0yXpaReACHm3mJt5xTNmunQ0tr62d49Quqhd0aoTqvHA";

	static let validAuthHeaderWithoutUserIdentity = "Bearer eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjE5NjAzMTE2ODgsImF1ZCI6IjJmZTM1NDc3LTUxYjAtNGM4Ny04MDNkLWFjYTU5NTExNDMzYiIsImlzcyI6Imh0dHA6XC9cL2FibXMubXlibHVlbWl4Lm5ldDo4MFwvaW1mLWF1dGhzZXJ2ZXJcL2F1dGhvcml6YXRpb25cLyIsInBybiI6IjYzODA4MDJkZjZkZjlhNzAzODA2MzVjMDA4MmJmOTEzMjA1MTc2ZTAifQ.UDLdkoCDcM9i3k1QR4NGVbJr2O7vic2v1PRKxetNF-ToOink-zQFfMLtHOIgfxxrI65hbo4b_jYYr4LHaryZNis3bb5YUbtfmH3EFkrp_UHQZVZ_X9OTQnA3zAu_VjDyB0ta8zMPHS3nXZfjqHg_WlPy2WpkfUh94Jwpj5l39mVKFOA3FyD6KPOv_DJQ3STiMBP62kJ9jYGyrURZJPFlAJ48ktiPPWQ9zms0x_lQLjGVkoIt8-SDy1n1pT3mfKhvie7unQbZUDdSSgoJnLEaFTO4LzBwn6b4TtQhSmEV_OjFqinOuTeqwYOZIpaqjGRD8h_0PeChcWCnXXwwuXyC5g eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjE0NjAzMTE2ODgsInN1YiI6Ijo6NjM4MDgwMmRmNmRmOWE3MDM4MDYzNWMwMDgyYmY5MTMyMDUxNzZlMCIsImltZi5hcHBsaWNhdGlvbiI6eyJpZCI6ImNvbS5teS5hcHAiLCJ2ZXJzaW9uIjoiMS4wIn0sImF1ZCI6IjJmZTM1NDc3LTUxYjAtNGM4Ny04MDNkLWFjYTU5NTExNDMzYiIsImlzcyI6Imh0dHA6XC9cL2FibXMubXlibHVlbWl4Lm5ldDo4MFwvaW1mLWF1dGhzZXJ2ZXJcL2F1dGhvcml6YXRpb25cLyIsImlhdCI6MTQ2MDMwODA4OCwiaW1mLmRldmljZSI6eyJpZCI6ImQ3YmYyNjVkLTU1YWUtMzc4Ny04MDU4LTY2Zjk3ZTdhYTM0OSIsInBsYXRmb3JtIjoiQW5kcm9pZCIsIm1vZGVsIjoiQW5kcm9pZCBTREsgYnVpbHQgZm9yIHg4Nl82NCIsIm9zVmVyc2lvbiI6IjYuMCJ9fQ.aNSzQB16G9WPv8z1Q5nFyyQAvX5P-llkqmfOJiyO51krzFTiBZCx3WeqqnRA4Hd_ltQAReAq5JYp0ZHo0bN0qtdEeJBGXsR9PGj4uWWCFV1AQrZBBdZfn_Y_6MqkQng4k3VJh3896y3FBAB5qiubAuNt2-7WP-NOAAq-k_3myvyqOwkIcgqnlyCZ_TnayigSwBuiGnfMQ8AUl6vO05UuqGWhuaZNzduW826wI6P8_sjGZLv8f_ZTf5v2WHiK1RhEN-VnbQMV6nMDRtMS9n4M7KiFcGXkQn3KRsfYCTxtia0yXpaReACHm3mJt5xTNmunQ0tr62d49Quqhd0aoTqvHA";

	static let validAuthHeaderWithoutIdToken = "Bearer eyJhbGciOiJSUzI1NiIsImpwayI6eyJhbGciOiJSU0EiLCJleHAiOiJBUUFCIiwibW9kIjoiQUkzT2YyZFd5VnVwY183OHY3WVl6WXRpZ05mZ083ZHdxYmtscHZQaE5MYWpOR1ROdWRfc1Nqb2x0QWJCVnFCZFRpYmMybDNXUmlWUzJSWUxkbnhidG9jRkNka0cyLWJLdC0xNWNVM1VFTW5QeGw5TW9Rc2U1cXlJMEVzcFVkelh4RjY1dVNEeUR2VnhvekFXZkdocXNMSUE0THlOV1phU1dOUERWUzhxelc4Zi1HUjlfb3ZIaGhXVEZWRzlCQ3JwV0VqTGZDaTFSWEREWWY3MXkzQ0tQUXY4RzYxSGZBQVMwRC1zMndEbC1mUGZJTDlHQUdnS29LSnQ5T0V6VlRwakt0cW5YNHNxeWUyVXZhWm5FYkRtUDdVTGtpSGtCdlUwSEhwNmM1cnF6QlFxUGxyNGhiYVhPM3JDZW5DNl80Ml9lZDEyNEYxWjVCS21WVmo3NUYzckpROCJ9fQ.eyJleHAiOjE5NjAzMTE2ODgsImF1ZCI6IjJmZTM1NDc3LTUxYjAtNGM4Ny04MDNkLWFjYTU5NTExNDMzYiIsImlzcyI6Imh0dHA6XC9cL2FibXMubXlibHVlbWl4Lm5ldDo4MFwvaW1mLWF1dGhzZXJ2ZXJcL2F1dGhvcml6YXRpb25cLyIsInBybiI6IjYzODA4MDJkZjZkZjlhNzAzODA2MzVjMDA4MmJmOTEzMjA1MTc2ZTAifQ.UDLdkoCDcM9i3k1QR4NGVbJr2O7vic2v1PRKxetNF-ToOink-zQFfMLtHOIgfxxrI65hbo4b_jYYr4LHaryZNis3bb5YUbtfmH3EFkrp_UHQZVZ_X9OTQnA3zAu_VjDyB0ta8zMPHS3nXZfjqHg_WlPy2WpkfUh94Jwpj5l39mVKFOA3FyD6KPOv_DJQ3STiMBP62kJ9jYGyrURZJPFlAJ48ktiPPWQ9zms0x_lQLjGVkoIt8-SDy1n1pT3mfKhvie7unQbZUDdSSgoJnLEaFTO4LzBwn6b4TtQhSmEV_OjFqinOuTeqwYOZIpaqjGRD8h_0PeChcWCnXXwwuXyC5g";
}




extension MobileClientAccessSDKTests {
	static var allTests : [(String, MobileClientAccessSDKTests -> () throws -> Void)] {
		return [
		       	("testInvalidAuthHeader", testInvalidAuthHeader),
		       	("testBadStructureAuthHeader", testBadStructureAuthHeader),
		       	("testExpiredAuthHeader", testExpiredAuthHeader),
		       	("testValidAuthHeaderWithUserIdentity", testValidAuthHeaderWithUserIdentity),
		       	("testValidAuthHeaderWithoutUserIdentity", testValidAuthHeaderWithoutUserIdentity),
		       	("testValidAuthHeaderWithoutIdHeader", testValidAuthHeaderWithoutIdHeader)
		]
	}
}
