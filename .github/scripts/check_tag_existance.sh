#!/bin/bash
echo "START OF REPO COMMIT MESSAGE CHECK SCRIPT"

# Function to check if the latest tag's commit ID matches the branch head
checkTag() {
    # Get the latest tag name
    local latestTag=$(git describe --tags --abbrev=0)
    echo "Latest tag: $latestTag"
    
    # Get the commit ID of the latest tag
    local latestTagCommitID=$(git rev-list -n 1 "$latestTag")
    echo "Commit ID of the latest tag: $latestTagCommitID"
    
    # Get the commit ID of the current branch head
    local branchHeadCommitID=$(git rev-parse HEAD)
    echo "Commit ID of the branch head: $branchHeadCommitID"
    
    # Compare the two commit IDs
    [[ "$latestTagCommitID" == "$branchHeadCommitID" ]]
}

# Validate input
if [ $# -eq 0 ]; then
    echo "Error: No repositories provided"
    exit 1
fi

# Get user input as a single string
inputString="$1"

# Replace commas with spaces
repoString=${inputString//,/ }

# Convert the space-separated string into an array
read -ra repoArray <<< "$repoString"

# Initialize arrays for repositories with and without "bumped version"
arrRepoWithBump=()
arrRepoWithoutBump=()

# Loop through each repository
for repo in "${repoArray[@]}"; do
    # Create a temporary directory for cloning
    tmpDir=$(mktemp -d)
    
    # Clone the repository
    if gh repo clone "$REPOOWNER/$repo" "$tmpDir"; then
        # Change into the cloned repository directory
        cd "$tmpDir"
        
        # Check if the latest tag's commit ID matches the branch head
        if checkTag; then
            echo "The latest tag's commit ID matches the branch head."
            arrRepoWithBump+=("$repo")
        else
            echo "The latest tag's commit ID does not match the branch head."
            arrRepoWithoutBump+=("$repo")
        fi
        
        # Clean up: go back to the original directory
        cd - > /dev/null
    else
        echo "Error: Could not clone repository $repo"
    fi
    
    # Remove temporary directory
    rm -rf "$tmpDir"
done

# Write results to files
printf '%s\n' "${arrRepoWithBump[@]}" | tr '\n' ',' | sed 's/,$//' > with_bump_version.txt
printf '%s\n' "${arrRepoWithoutBump[@]}" | tr '\n' ',' | sed 's/,$//' > without_bump_version.txt

echo "Process completed. Check 'with_bump_version.txt' and 'without_bump_version.txt' for the results."