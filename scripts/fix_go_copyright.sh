#!/usr/bin/env bash

# Copyright header to be added
COPYRIGHT="// Copyright © 2025 Ping Identity Corporation"

# Find all Go files
find . -type f -name "*.go" | while read -r file; do
    # Check if the file already contains the copyright
    if ! grep -q "$COPYRIGHT" "$file"; then
        echo "🔧 Fixing missing copyright in: $file"
        
        # Use Python to insert the copyright before the package declaration
        python3 - <<EOF
import sys

file_path = "$file"
copyright_line = "$COPYRIGHT"

# Read file content
with open(file_path, "r") as f:
    lines = f.readlines()

# Find the first occurrence of "package"
for i, line in enumerate(lines):
    if line.startswith("package "):
        insert_index = i
        break
else:
    insert_index = 0  # Fallback if "package" is missing

# Insert the copyright before the package declaration
new_lines = lines[:insert_index] + [copyright_line + "\n\n"] + lines[insert_index:]

# Write the updated content back to the file
with open(file_path, "w") as f:
    f.writelines(new_lines)
EOF
    fi
done

echo "✅ All Go files have the required copyright notice."
