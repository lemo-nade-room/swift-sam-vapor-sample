import Vapor

func configure(_ app: Application) async throws {
  app.get { _ in
    "It works!"
  }

  app.get("hello") { _ in
    "Hello, World!"
  }
}
