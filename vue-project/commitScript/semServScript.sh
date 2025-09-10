#!/bin/bash

# holt neusten tag
latest_tag=$(git tag --list "v[0-9]*" --sort=-v:refname | head -n1)
# holt neusten commitmsg
commit_msg=$(git log -1 --pretty=%B)


# prüfung was für ein Commit
if echo "$commit_msg" | grep -qE 'BREAKING CHANGE:|!'; then bump="major"
elif echo "$commit_msg" | grep -qE '^feat(\([^)]+\))?: '; then bump="minor"
elif echo "$commit_msg" | grep -qE '^(fix|perf|refactor|revert|build|ci|chore|style|test|docs)(\([^)]+\))?: '; then bump="patch"
else exit 0


# zerlegt den neusten tag auf major, minor und patch
IFS=. read -r maj min pat <<< "${latest_tag#v}"
maj=${maj:-0}; min=${min:-0}; pat=${pat:-0}

# erhöht die Versionsnummer
if [ "$bump" = "major" ]; then maj=$((maj+1)); min=0; pat=0
elif [ "$bump" = "minor" ]; then min=$((min+1)); pat=0
elif [ "$bump" = "patch" ]; then pat=$((pat+1))
fi

# neuer tag erstellen
next_tag="v$maj.$min.$pat"
git tag -a "$next_tag" -m "chore(release): $next_tag"
echo "Created tag: $next_tag"