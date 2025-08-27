#!/bin/bash

# Postman to Flutter Service Generator
# Usage examples

echo "🚀 Postman to Flutter Service Generator Examples"
echo "================================================="

# Example 1: Basic usage
echo ""
echo "📝 Example 1: Basic generation from sample collection"
echo "Command: node generator.js -i sample_collection.json"
echo ""
node generator.js -i sample_collection.json

echo ""
echo "📂 Generated files:"
ls -la generated_services/

echo ""
echo "================================================="
echo ""

# Example 2: Custom output directory
echo "📝 Example 2: Custom output directory"
echo "Command: node generator.js -i sample_collection.json -o ./custom_output"
echo ""
node generator.js -i sample_collection.json -o ./custom_output

echo ""
echo "📂 Generated files in custom directory:"
ls -la custom_output/

echo ""
echo "================================================="
echo ""

# Example 3: Custom service name
echo "📝 Example 3: Custom service name"
echo "Command: node generator.js -i sample_collection.json -n MyCustomService -o ./named_output"
echo ""
node generator.js -i sample_collection.json -n MyCustomService -o ./named_output

echo ""
echo "📂 Generated files with custom name:"
ls -la named_output/

echo ""
echo "================================================="
echo "✅ All examples completed!"
echo ""
echo "📖 Usage: node generator.js [options]"
echo "Options:"
echo "  -i, --input <file>    Postman collection JSON file (required)"
echo "  -o, --output <dir>    Output directory (default: ./generated_services)"
echo "  -n, --name <name>     Custom service class name"
echo "  -u, --url <url>       Base URL override"
echo ""
echo "📁 Check the generated files and copy them to your Flutter project!"
