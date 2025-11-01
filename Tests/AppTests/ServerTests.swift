import Testing
import VaporTesting

@testable import App

@Test func helloWorld() async throws {
  try await withApp { app in
    try await configure(app)

    try await app.testing()
      .test(.GET, "hello") { res in
        #expect(res.status == .ok)
        #expect(res.body.string == "Hello, World!")
      }
  }
}
