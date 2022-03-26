#!/usr/bin/env bash

###
## adjust timezone
###

echo "Now working on your timezone and define it to ${TIMEZONE} ..."
timezone_file="/usr/share/zoneinfo/${TIMEZONE}"
host_timezone="/etc/timezone"
if [ -e $host_timezone ]; then
    echo "${TIMEZONE}" > $host_timezone
    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
fi

###
## adjust locale
###
#update-locale "LANG=${SET_LOCALE}"
export LC_ALL="${SET_LOCALE}"
export LANG="${SET_LOCALE}"
export LANGUAGE="${SET_LOCALE}"


###
## additional bootup things
###

bootDir="/boot.d/"
echo "Doing additional bootup things from \`${bootDir}\` ..."
cd "${bootDir}"

# find all (sub(sub(...))directories of the /boot.d/ folder to be
# checked for executable Shell (!) scripts.
#
# `\( ! -name . \)` would exclude current directory
# find . -type d \( ! -name . \) -exec bash -c "cd '{}' && pwd" \;
dirs=$( find . -type d -exec bash -c "cd '{}' && pwd" \; )
while IFS= read -r cur; do
    bootpath="${cur}/*.sh"
    count=`ls -1 ${bootpath} 2>/dev/null | wc -l`
    if [ $count != 0 ]; then
        echo "... Handling files in directory ${cur}"
        echo
        chmod a+x ${bootpath}
        for f in ${bootpath}; do
            echo "    ... running ${f}"
            source "${f}"
            echo "    ... done with ${f}"
            echo
        done
    fi
done <<< "${dirs}"
