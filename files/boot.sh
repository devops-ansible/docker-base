#!/usr/bin/env bash

###
## adjust timezone
###

echo -e "\033[0;30;42m Now working on timezone and define it to be \"${TIMEZONE}\" ... \033[0m"
timezone_file="/usr/share/zoneinfo/${TIMEZONE}"
localtime_file="/etc/localtime"
host_timezone="/etc/timezone"

if [ -e $timezone_file ]; then
    if [ -e $host_timezone ]; then
        echo "${TIMEZONE}" > "${host_timezone}"
    fi
    ln -sf "${timezone_file}" "${localtime_file}"
fi

###
## adjust locale
###
#update-locale "LANG=${SET_LOCALE}"
echo -e "\033[0;30;42m Adjusting locale and setting it to be \"${SET_LOCALE}\" ... \033[0m"
export LC_ALL="${SET_LOCALE}"
export LANG="${SET_LOCALE}"
export LANGUAGE="${SET_LOCALE}"


###
## additional bootup things
###

bootDir="/boot.d/"
echo -e "\033[0;30;42m Doing additional bootup things from \`${bootDir}\` ... \033[0m"
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

echo -e "\033[0;30;42m \"boot.sh\" finished - continue with container ENTRYPOINT / CMD. \033[0m"
