#!/bin/bash

# Flutter Code Analysis Runner
# Automated script to run comprehensive Flutter code analysis

set -e

echo "🔍 Flutter Code Analysis Tool"
echo "============================"
echo ""

# Configuration
PROJECT_ROOT="/home/runner/work/mobile-app/mobile-app/cannasoltech_automation"
OUTPUT_DIR="/home/runner/work/mobile-app/mobile-app/docs/ai-issues"
ANALYSIS_TOOL="$OUTPUT_DIR/scripts/analysis-tools/flutter_analyzer.py"

# Check prerequisites
echo "📋 Checking prerequisites..."

if [ ! -d "$PROJECT_ROOT" ]; then
    echo "❌ Error: Project root not found at $PROJECT_ROOT"
    exit 1
fi

if [ ! -f "$ANALYSIS_TOOL" ]; then
    echo "❌ Error: Analysis tool not found at $ANALYSIS_TOOL"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 not found"
    exit 1
fi

echo "✅ Prerequisites met"
echo ""

# Run analysis
echo "🚀 Running Flutter code analysis..."
echo "Project: $PROJECT_ROOT"
echo "Output: $OUTPUT_DIR"
echo ""

# Execute the analysis
cd "$(dirname "$ANALYSIS_TOOL")"
python3 flutter_analyzer.py

echo ""
echo "🎉 Analysis complete!"
echo ""

# Generate summary
echo "📊 Analysis Summary"
echo "=================="

# Count issues by category
if [ -d "$OUTPUT_DIR/categories" ]; then
    for category in "$OUTPUT_DIR/categories"/*; do
        if [ -d "$category" ]; then
            category_name=$(basename "$category")
            if [ -f "$category/README.md" ]; then
                issue_count=$(grep -c "^### " "$category/README.md" 2>/dev/null || echo "0")
                echo "  $category_name: $issue_count issues"
            fi
        fi
    done
fi

echo ""
echo "📁 Generated Reports:"
echo "  - Analysis Summary: $OUTPUT_DIR/analysis-summary.md"
echo "  - Category Reports: $OUTPUT_DIR/categories/"
echo "  - Detailed Reports: $OUTPUT_DIR/detailed-reports/"
echo "  - Implementation Guide: $OUTPUT_DIR/implementation-guide.md"
echo ""

# Provide next steps
echo "🔗 Next Steps:"
echo "  1. Review the analysis summary: less $OUTPUT_DIR/analysis-summary.md"
echo "  2. Check the implementation guide: less $OUTPUT_DIR/implementation-guide.md"
echo "  3. Start with high-priority issues in categories/"
echo "  4. Create GitHub issues for tracking progress"
echo ""

# Optional: Open summary in browser if available
if command -v xdg-open &> /dev/null; then
    echo "💡 Tip: Opening analysis summary..."
    xdg-open "$OUTPUT_DIR/analysis-summary.md" 2>/dev/null || true
elif command -v open &> /dev/null; then
    echo "💡 Tip: Opening analysis summary..."
    open "$OUTPUT_DIR/analysis-summary.md" 2>/dev/null || true
fi

echo "✨ Analysis complete! Happy coding! 🚀"