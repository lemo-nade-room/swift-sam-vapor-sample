import Vapor

@main
enum Server: Sendable {
  static func main() async throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)

    let app = try await Application.make(env)

    do {
      try await app.execute()
    } catch {
      app.logger.report(error: error)
      try? await app.asyncShutdown()
      throw error
    }
    try await app.asyncShutdown()
  }
}
