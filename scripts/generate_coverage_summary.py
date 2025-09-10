#!/usr/bin/env python3
"""
Generate coverage summary JSON artifact following company release standards.
Converts Flutter/LCOV coverage data into the standardized coverage-summary.json format.
"""

import json
import os
import sys
import subprocess
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any


def get_git_info() -> Dict[str, str]:
    """Get git repository information."""
    try:
        commit = subprocess.check_output(['git', 'rev-parse', 'HEAD'], text=True).strip()
        short_commit = subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD'], text=True).strip()
        
        try:
            tag = subprocess.check_output(['git', 'describe', '--tags', '--exact-match'], text=True).strip()
        except subprocess.CalledProcessError:
            branch = subprocess.check_output(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], text=True).strip()
            tag = f"{branch}-{short_commit}"
        
        return {
            'commit': short_commit,
            'full_commit': commit,
            'tag': tag
        }
    except subprocess.CalledProcessError:
        return {
            'commit': 'unknown',
            'full_commit': 'unknown',
            'tag': 'unknown'
        }


def parse_lcov_file(lcov_path: Path) -> Dict[str, Any]:
    """Parse LCOV coverage file and extract summary data."""
    
    totals = {
        "lines": {"pct": 0.0, "covered": 0, "total": 0},
        "statements": {"pct": 0.0, "covered": 0, "total": 0},
        "functions": {"pct": 0.0, "covered": 0, "total": 0},
        "branches": {"pct": 0.0, "covered": 0, "total": 0}
    }
    
    files = []
    
    if not lcov_path.exists():
        print(f"Warning: LCOV file not found at {lcov_path}")
        return {"totals": totals, "files": files}
    
    try:
        with open(lcov_path, 'r') as f:
            content = f.read()
        
        current_file = None
        file_data = {}
        
        for line in content.split('\n'):
            line = line.strip()
            
            if line.startswith('SF:'):
                # Source file
                if current_file and file_data:
                    files.append(file_data)
                current_file = line[3:]  # Remove 'SF:'
                file_data = {
                    "path": current_file,
                    "lines": {"pct": 0.0, "covered": 0, "total": 0}
                }
            
            elif line.startswith('LH:'):
                # Lines hit
                covered = int(line[3:])
                file_data["lines"]["covered"] = covered
                totals["lines"]["covered"] += covered
            
            elif line.startswith('LF:'):
                # Lines found
                total = int(line[3:])
                file_data["lines"]["total"] = total
                totals["lines"]["total"] += total
                
                # Calculate percentage for this file
                if total > 0:
                    file_data["lines"]["pct"] = round((file_data["lines"]["covered"] / total) * 100, 1)
            
            elif line.startswith('FNH:'):
                # Functions hit
                totals["functions"]["covered"] += int(line[4:])
            
            elif line.startswith('FNF:'):
                # Functions found
                totals["functions"]["total"] += int(line[4:])
            
            elif line.startswith('BRH:'):
                # Branches hit
                totals["branches"]["covered"] += int(line[4:])
            
            elif line.startswith('BRF:'):
                # Branches found
                totals["branches"]["total"] += int(line[4:])
        
        # Add last file
        if current_file and file_data:
            files.append(file_data)
        
        # Calculate total percentages
        if totals["lines"]["total"] > 0:
            totals["lines"]["pct"] = round((totals["lines"]["covered"] / totals["lines"]["total"]) * 100, 1)
        
        if totals["functions"]["total"] > 0:
            totals["functions"]["pct"] = round((totals["functions"]["covered"] / totals["functions"]["total"]) * 100, 1)
        
        if totals["branches"]["total"] > 0:
            totals["branches"]["pct"] = round((totals["branches"]["covered"] / totals["branches"]["total"]) * 100, 1)
        
        # For Flutter, statements are usually the same as lines
        totals["statements"] = totals["lines"].copy()
        
    except Exception as e:
        print(f"Error parsing LCOV file: {e}")
    
    return {"totals": totals, "files": files}


def generate_coverage_summary():
    """Generate the coverage summary JSON file."""
    
    git_info = get_git_info()
    
    # Look for LCOV files in common Flutter locations
    lcov_paths = [
        Path("cannasoltech_automation/coverage/lcov.info"),
        Path("coverage/lcov.info"),
        Path("lcov.info")
    ]
    
    coverage_data = {"totals": {}, "files": []}
    
    for lcov_path in lcov_paths:
        if lcov_path.exists():
            print(f"Found LCOV file: {lcov_path}")
            coverage_data = parse_lcov_file(lcov_path)
            break
    else:
        print("No LCOV coverage file found, generating placeholder data")
        # Create placeholder data for CI setup
        coverage_data = {
            "totals": {
                "lines": {"pct": 0.0, "covered": 0, "total": 0},
                "statements": {"pct": 0.0, "covered": 0, "total": 0},
                "functions": {"pct": 0.0, "covered": 0, "total": 0},
                "branches": {"pct": 0.0, "covered": 0, "total": 0}
            },
            "files": []
        }
    
    # Create the coverage summary structure following company standards
    coverage_summary = {
        "version": "1.0.0",
        "owner": "Cannasol-Tech",
        "repo": "mobile-app",
        "releaseTag": git_info['tag'],
        "commit": git_info['commit'],
        "createdAt": datetime.utcnow().isoformat() + "Z",
        "totals": coverage_data["totals"],
        "files": coverage_data["files"]
    }
    
    # Ensure final directory exists
    final_dir = Path("final")
    final_dir.mkdir(exist_ok=True)
    
    # Write the coverage summary
    summary_path = final_dir / "coverage-summary.json"
    with open(summary_path, 'w') as f:
        json.dump(coverage_summary, f, indent=2)
    
    print(f"✅ Generated coverage summary: {summary_path}")
    print(f"   - Lines coverage: {coverage_summary['totals']['lines']['pct']}%")
    print(f"   - Functions coverage: {coverage_summary['totals']['functions']['pct']}%")
    print(f"   - Files analyzed: {len(coverage_summary['files'])}")


if __name__ == "__main__":
    try:
        generate_coverage_summary()
    except Exception as e:
        print(f"❌ Error generating coverage summary: {e}")
        sys.exit(1)