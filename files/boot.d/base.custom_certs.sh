#!/usr/bin/env bash

###
## Import Custom Certificate
###

certPath="${CUSTOM_CERTS_PATH:-/certs}"
certDst="/usr/share/ca-certificates"

if [ -d "$certPath" ] && [ "$( ls -A $certPath )" ]; then

    echo -e "\033[0;30;42m Now adding certificates from directory \"${certPath}\": \033[0m"
    cd "${certPath}"

    for cert in $( find -name \*.crt -o -name \*.pem ); do
        cert="${cert:2}"
        echo ""
        echo -e "\033[0;30;42m    ... adding \"${cert}\" \033[0m"
        cp "${certPath}/${cert}" "${certDst}"
        chmod 0755 "${certDst}/${cert}"
        echo "${cert}" >> /etc/ca-certificates.conf
    done

    update-ca-certificates

    echo -e "\033[0;30;42m ... done with certificates. \033[0m"
    echo
fi
