import OpenAI
import Vapor

struct PromptController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let prompt = routes.grouped("prompt")
    prompt.post(use: answerPrompt)
  }

  func answerPrompt(req: Request) async throws -> PromptResponse {
    let prompt = try req.content.decode(PromptRequest.self)

    // for usage check https://github.com/MacPaw/OpenAI
    let openAI = OpenAI(apiToken: "YOUR_TOKEN_HERE")

    let query = CompletionsQuery(
      model: .gpt3_5Turbo, prompt: prompt.prompt, temperature: 0, maxTokens: 100, topP: 1,
      frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
    let result = try await openAI.completions(query: query)

    return PromptResponse(answer: result.choices.first?.text ?? "no choice")
  }
}
