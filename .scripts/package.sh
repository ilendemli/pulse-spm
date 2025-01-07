#!/bin/bash

latest_release_number () {
    # Github cli to get the latest release
    gh release list --repo $1 --limit 1 |
    # Regex to find the version number, assumes semantic versioning
    grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' |
    # Take the first match in the regex
    head -1 || echo '0.0.0'
}

create_scratch () {
    # Create temporary directory
    scratch=$(mktemp -d -t TemporaryDirectory)
    if [[ $debug ]]; then open $scratch; fi
    # Run cleanup on exit
    trap "if [[ \$debug ]]; then read -p \"\"; fi; rm -rf \"$scratch\"" EXIT
}

zip_frameworks () {
    zip -rqo Pulse.xcframework.zip Pulse.xcframework
    zip -rqo PulseUI.xcframework.zip PulseUI.xcframework
}

template_replace () {
    local file=$(cat $1)
    # Replace the template with the contents of the replacement file
    local result=${file//"$2"/"$(trim_empty_lines $3; cat $3)"}
    # Write the result back to the original file
    rm -f $1; touch $1; printf "$result" >> $1
}

xcframework_name () {
    # Filter out path and extension to get the framework name
    # Ex. xcframework_name "FirebaseFirestore/leveldb-library.xcframework" = "leveldb-library"
    echo $1 | sed -E 's/.*\/|\.xcframework|\.xcframework\.zip//g'
}

generate_target () {
    local target="$1"

    mkdir $target
    touch $target/Empty.m
}

generate_sources () {
    generate_target Pulse
    generate_target PulseUI
}

trim_empty_lines () {
    # Delete all empty lines in a file
    sed -i '' '/^$/d' $1
}

generate_swift_package () {
    local repo="$1"
    local binaries="binaries.txt"

    # Create package file
    cp -f $home/package_template.swift Package.swift

    write_binary Pulse.xcframework.zip $repo $latest $binaries
    write_binary PulseUI.xcframework.zip $repo $latest $binaries

    echo "Creating release Package.swift..."
    template_replace Package.swift "// GENERATED BINARY TARGETS" $binaries
    rm -f $binaries
}

write_binary () {
    local file=$1
    local repo=$2
    local version=$3
    local output=$4

    # Get the checksum
    local checksum=$(swift package compute-checksum "$file")
    local name=$(xcframework_name $file)

    # Write to file
    printf "
        .binaryTarget(
            name: \"$name\",
            url: \"$repo/releases/download/$version/$name.xcframework.zip\",
            checksum: \"$checksum\"
        )," >> $output
}

commit_changes() {
    local branch=$1
    git checkout -b $branch
    git add .
    git commit -m "Updated Package.swift"
    git push -u origin $branch
}

# Exit when any command fails
set -e
set -o pipefail

# Repos
source_repo="https://github.com/kean/Pulse"
target_repo="https://github.com/ilendemli/pulse-spm"

# Release versions
latest=$(latest_release_number $source_repo)
current=$(latest_release_number $target_repo)

# Args
if echo $@ | grep -q "debug"; then
    debug=1
fi

if echo $@ | grep -q "skip-release"; then
    skip_release=1
fi

if [[ $latest != $current || $debug ]]; then
    echo "$current is out of date. Updating to $latest..."

    # Generate files in a temporary directory
    # Use subshell to return to original directory when finished with scratchwork
    create_scratch
    (
        cd $scratch
        home=$OLDPWD

        echo "Downloading latest release..."
        gh release download $latest --repo $source_repo --pattern pulse-xcframeworks-all-platforms.zip

        echo "Unzipping.."
        unzip -q pulse-xcframeworks-all-platforms.zip

        echo "Preparing xcframeworks for distribution..."
        zip_frameworks

        echo "Creating source files..."
        generate_sources
        generate_swift_package $target_repo

        echo "Validating..."
        swift package dump-package | read pac
    )

    echo "Moving files to repo..."; cd ..

    if [ -d Pulse ]; then rm -rf Pulse; fi
    if [ -d PulseUI ]; then rm -rf PulseUI; fi
    if [ -f Package.swift ]; then rm -f Package.swift; fi

    mv $scratch/Pulse .
    mv $scratch/PulseUI .
    mv $scratch/Package.swift .

    # Skips deploy
    if [[ $skip_release ]]; then echo "Done."; exit 0; fi

    # Deploy to repository
    echo "Merging changes to Github..."
    commit_changes "release/$latest"

    echo "Release $latest"
    gh release create --title "Release $latest" --target "release/$latest" $latest $scratch/*.xcframework.zip

    echo "Create PR and merge"
    gh pr create --fill
    gh pr merge --merge --delete-branch
else
    echo "$current is up to date."
fi
