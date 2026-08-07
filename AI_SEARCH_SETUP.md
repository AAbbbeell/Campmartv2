# AI Search Integration Setup Guide (Groq - Free AI)

## Overview
Your Campmart app now has AI-powered search with intelligent fallback using **Groq's free AI models**. When users search for products/services:

1. **First**: Exact keyword search using your existing API
2. **Fallback**: If fewer than 3 results found, AI suggests similar items
3. **Display**: AI suggestions appear in a highlighted section above regular results

## Why Groq?
- **100% Free**: No API costs for development or production
- **Fast Performance**: Groq's specialized AI chips deliver lightning-fast responses
- **Quality Models**: Access to Llama 3, Mixtral, and other state-of-the-art models
- **Easy Setup**: Simple API key registration

## Files Created/Modified

### New Files Created:
- `lib/config/ai_config.dart` - AI configuration settings
- `lib/services/groq_service.dart` - Groq API integration
- `lib/services/ai_search_service.dart` - Main AI search logic with fallback
- `lib/widgets/ai_suggestions_widget.dart` - UI components for AI suggestions

### Modified Files:
- `lib/screens/products_screen.dart` - Integrated AI search for products
- `lib/screens/services_screen.dart` - Integrated AI search for services

## Setup Instructions

### 1. Get Groq API Key (Free)
- Sign up at [Groq Console](https://console.groq.com/)
- Navigate to API Keys section
- Create a new API key
- Copy the key (starts with `gsk_...`)

### 2. Configure API Key

**Option A: Environment Variable (Recommended)**
```bash
flutter run --dart-define=GROQ_API_KEY=your_actual_api_key_here
```

**Option B: Direct Configuration**
Edit `lib/config/ai_config.dart`:
```dart
static const String groqApiKey = 'your_actual_api_key_here';
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## How It Works

### Search Flow:
1. User types search query (e.g., "gaming laptop")
2. App performs exact search using existing API
3. If results < 3, AI analyzes the query and available products
4. AI suggests similar alternatives from your inventory
5. Suggestions appear in highlighted "AI Suggestions" section
6. Users can dismiss suggestions or tap to view products

### AI Behavior:
- **Semantic Understanding**: AI understands user intent, not just keywords
- **Context-Aware**: Considers product categories, descriptions, and pricing
- **Smart Fallback**: Only activates when needed (fewer than 3 exact matches)
- **Safe Suggestions**: Only recommends products that actually exist in your database

## Configuration Options

Edit `lib/config/ai_config.dart` to customize:

```dart
class AiConfig {
  // Groq Settings
  static const String groqApiKey = ''; // Your API key
  static const String groqModel = 'llama-3.1-8b-instant'; // Available models:
                                                     // - llama-3.1-8b-instant (Fast, efficient, latest)
                                                     // - llama-3.1-70b-versatile (More capable)
                                                     // - mixtral-8x7b-32768 (Good reasoning)
                                                     // - gemma-7b-it (Google's model)
  static const int maxTokens = 150; // Response length
  static const double temperature = 0.7; // Creativity (0.0-1.0)
  
  // Search Settings
  static const int maxAiSuggestions = 5; // Max AI suggestions
  static const int minSearchResults = 3; // AI fallback threshold
}
```

## Cost Considerations

- **100% Free**: Groq's API is completely free for development and production use
- **No Hidden Costs**: No token counting or billing worries
- **Unlimited Usage**: Use as much as you need for your application

## Testing the Implementation

### Test Product Search:
1. Run the app
2. Go to Products screen
3. Search for something specific like "gaming laptop"
4. If few/no exact matches, AI suggestions should appear

### Test Service Search:
1. Go to Services screen  
2. Search for "web development"
3. AI suggestions should appear if few exact matches

### Disable AI for Testing:
Set the threshold higher in `ai_config.dart`:
```dart
static const int minSearchResults = 100; // AI rarely activates
```

## Troubleshooting

### No AI suggestions appearing:
- Check API key is configured correctly
- Verify you have products/services in your database
- Ensure search query returns < 3 exact matches
- Check console for "Groq API error" messages

### API errors:
- Verify your Groq API key is valid (starts with `gsk_...`)
- Ensure network connectivity
- Try a different model (llama-3.1-8b-instant vs llama-3.1-70b-versatile)
- Check Groq service status at [Groq Status](https://status.groq.com/)

### Performance issues:
- Increase `minSearchResults` to reduce AI calls
- Reduce `maxAiSuggestions` for faster responses
- Use llama-3.1-8b-instant for fastest responses
- Use llama-3.1-70b-versatile for better quality (slightly slower)

## Next Steps

### Optional Enhancements:
1. **Add Loading States**: Show loading indicator during AI search
2. **Cache Results**: Cache AI suggestions for common queries
3. **Analytics**: Track AI suggestion click-through rates
4. **Custom Prompts**: Fine-tune AI prompts for your specific products
5. **A/B Testing**: Test different AI configurations

### Backend Integration:
For production, consider moving AI logic to your backend:
1. Create `/api/ai-suggestions` endpoint
2. Perform AI search server-side using Groq
3. Return suggestions to Flutter app
4. Better security and rate limiting

## Security Notes

- **Never commit API keys** to version control
- Use environment variables in production
- Implement rate limiting on your backend
- Groq is free, but still follow security best practices

## Support

For issues with:
- **Groq API**: Check [Groq Status](https://status.groq.com/) or [Groq Documentation](https://console.groq.com/docs)
- **Flutter/Dart**: Refer to Flutter documentation
- **This implementation**: Review the code comments in created files

## Groq Model Comparison

### llama-3.1-8b-instant (Default)
- **Speed**: Fastest
- **Quality**: Good for most use cases
- **Best for**: Quick responses, high-volume searches

### llama-3.1-70b-versatile
- **Speed**: Fast
- **Quality**: Higher accuracy and reasoning
- **Best for**: Complex queries, better suggestions

### mixtral-8x7b-32768
- **Speed**: Medium
- **Quality**: Excellent reasoning capabilities
- **Best for**: Complex product matching, nuanced suggestions

### gemma-7b-it
- **Speed**: Fast
- **Quality**: Good general performance
- **Best for**: Lightweight applications, simple matching