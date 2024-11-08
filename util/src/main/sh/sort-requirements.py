#!/usr/bin/env python3

# Path to the requirements.txt file
file_path = "requirements.txt"

# Sort the requirements.txt file
with open(file_path, "r") as f:
    lines = f.readlines()

# Sort and filter out any blank lines or comments, then write back in place
sorted_lines = sorted(line for line in lines if line.strip() and not line.strip().startswith("#"))

with open(file_path, "w") as f:
    f.write("".join(sorted_lines))

print(f"Sorted and updated {file_path}")
