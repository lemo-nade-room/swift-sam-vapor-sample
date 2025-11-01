import Vapor

func configure(_ app: Application) async throws {
  app.get("hello") { _ in
    "Hello, World!"
  }
}
