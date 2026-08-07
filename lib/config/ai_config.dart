class AiConfig {
  // Groq API Configuration (Free AI Models)
  static const String groqApiKey = String.fromEnvironment(
    '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',
    defaultValue: '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', // Replace with your actual API key or use environment variable
  );
  
  // Groq offers these free models:
  // - llama-3.1-8b-instant (Fast, efficient, latest)
  // - llama-3.1-70b-versatile (More capable)
  // - mixtral-8x7b-32768 (Good for reasoning)
  // - gemma-7b-it (Google's model)
  static const String groqModel = 'llama-3.1-8b-instant';
  static const int maxTokens = 150;
  static const double temperature = 0.7;
  
  // AI Search Configuration
  static const int maxAiSuggestions = 5;
  static const int minSearchResults = 2; // Below this, AI suggestions kick in
  
  // Check if AI is properly configured
  static bool get isConfigured => groqApiKey.isNotEmpty;
}