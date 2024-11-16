#!/bin/bash

# Get Repo Name
OWNER_NAME=$1
REPO_NAME=$2

# Create the release notes file
release_notes_file="RELEASE_NOTES.md"
touch "$release_notes_file"

# Add a header to the release notes file
echo "# Release Notes" > "$release_notes_file"
echo >> "$release_notes_file"

# Get the latest two tags sorted in descending order (newest first)
tags=$(git tag --sort=-version:refname | head -n 2)

# Split the tags into an array
IFS=$'\n' read -d '' -r -a tag_array <<< "$tags"

# Debug output
echo "Latest two tags:"
echo "${tag_array[0]}"
echo "${tag_array[1]}"

# Check if there are at least two tags
if [ ${#tag_array[@]} -ge 2 ]; then
    current_tag="${tag_array[0]}"
    previous_tag="${tag_array[1]}"

    echo "Current tag: $current_tag"
    echo "Previous tag: $previous_tag"

    # Get the commit messages between the previous tag and the current tag
    echo "## Version $current_tag" >> "$release_notes_file"
    echo >> "$release_notes_file"

    # Commit types and sections in the specified order
    commit_types_order=("feat" "fix" "perf" "refactor" "revert" "test" "docs")
    declare -A commit_type_titles=(
        ["feat"]="Features"
        ["fix"]="Fixes"
        ["perf"]="Performance Improvements"
        ["refactor"]="Refactorings"
        ["revert"]="Reversions"
        # ["build"]="Builds"
        # ["ci"]="Continuous Integration"
        ["test"]="Test Cases"
        ["docs"]="Documentation"
        # ["chore"]="Chores"
        # ["style"]="Code Style Changes"
    )

    # Track if any sections were created
    sections_created=false

    # Iterate over the commit types in the specified order
    for commit_type in "${commit_types_order[@]}"; do
        # Extract log entries for the current commit type
        log_entries=$(git log --pretty=format:"* [%s](https://github.com/$OWNER_NAME/$REPO_NAME/commit/%H)%n%b" "$previous_tag..$current_tag" --grep="^$commit_type")

        # Debug output
        echo "$commit_type log content:"
        echo "$log_entries"

        # Add section to release notes if there are entries for this type
        if [[ -n $log_entries ]]; then
            section_title=${commit_type_titles[$commit_type]}
            echo "### $section_title" >> "$release_notes_file"
            
            # Process each log entry, maintaining line spacing
            while IFS= read -r line; do
                if [[ "$line" =~ ^\* ]]; then
                    # If it's a new commit entry, print it as-is
                    echo "$line" >> "$release_notes_file"
                elif [[ -n "$line" ]]; then
                    # If it's a description, indent it with two spaces
                    echo "  $line" >> "$release_notes_file"
                fi
            done <<< "$log_entries"

            echo >> "$release_notes_file"
            sections_created=true
        fi
    done

    # If no sections were created, add a default message
    if [ "$sections_created" = false ]; then
        echo "No changes found." >> "$release_notes_file"
        echo >> "$release_notes_file"
    fi

else
    echo "Not enough tags found for comparison."
fi

echo "Created $release_notes_file."
