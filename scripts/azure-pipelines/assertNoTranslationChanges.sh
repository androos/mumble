#!/usr/bin/env bash
#
# Copyright 2020 The Mumble Developers. All rights reserved.
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file at the root of the
# Mumble source tree or at <https://www.mumble.info/LICENSE>.

set -e

# Get path to the updatetranslations script
updateScript="`dirname $0`/../updatetranslations.sh"

# Get current commit hash
oldHash=`git rev-parse HEAD`

# In order for any commits to be possible, we'll have to set up a dummy user
git config user.name "CI"
git config user.email "ci@mumble.info"

# Execute updatetranslations that'll commit any translation changes
"./$updateScript" > /dev/null
echo

# Ger new commit hash
newHash=`git rev-parse HEAD`

# Check if the commit hash has changed (aka whether a commit has been made).
# If so that means that there are unprocessed translation changes.
if [[ "$oldHash" = "$newHash" ]]; then
	echo "No translations have changed"
	exit 0
else
	echo "[ERROR]: There are unprocessed translation changes!"
	exit 1
fi
