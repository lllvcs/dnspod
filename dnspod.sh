#!/bin/sh
# 目前dnspod仅支持密钥登录，申请地址 https://console.dnspod.cn/account/token
# 不支持腾讯云API访问控制!!!

# 请填写Token 域名等信息
# arToken="你的密钥ID,你的密钥Token"
# domain="你的主域名"
# subdomain="你的子域"

arToken="TokenID,Token"
domain="Your_Domain_Name"
subdomain="Your_Sub_Domain_Name"

arIpAddress() {
    curltest=$(which curl)
    if [ -z "$curltest" ] || [ ! -s "$(which curl)" ]; then
        curl -4 -L -k -s ip.sb | grep -E -o '([0-9]+\.){3}[0-9]+'
        #curl -4 -k -s "http://members.3322.org/dyndns/getip" | grep -E -o '([0-9]+\.){3}[0-9]+'
        #curl -4 -k -s ip.6655.com/ip.aspx | grep -E -o '([0-9]+\.){3}[0-9]+'
        #curl -4 -k -s ip.3322.net | grep -E -o '([0-9]+\.){3}[0-9]+'
        #curl -4 -k -s api.myip.la | grep -E -o '([0-9]+\.){3}[0-9]+'
    else
        wget --no-check-certificate --quiet --output-document=- "http://ip.sb" | grep -E -o '([0-9]+\.){3}[0-9]+'
        #wget --no-check-certificate --quiet --output-document=- "http://members.3322.org/dyndns/getip" | grep -E -o '([0-9]+\.){3}[0-9]+'
        #wget --no-check-certificate --quiet --output-document=- "ip.6655.com/ip.aspx" | grep -E -o '([0-9]+\.){3}[0-9]+'
        #wget --no-check-certificate --quiet --output-document=- "ip.3322.net" | grep -E -o '([0-9]+\.){3}[0-9]+'
        #wget --no-check-certificate --quiet --output-document=- "api.myip.la" | grep -E -o '([0-9]+\.){3}[0-9]+'

    fi
}

arIpAddress=$(arIpAddress)

arDdnsInfo() {
    local recordID recordIP

    # Get Record ID
    recordID=$(arApiPost "Record.List" "domain=$domain&sub_domain=$subdomain")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')

    # Last IP
    recordIP=$(arApiPost "Record.Info" "domain=$domain&record_id=$recordID")
    recordIP=$(echo $recordIP | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/')

    # Output IP
    case "$recordIP" in
    [1-9]*)
        echo $recordIP
        ;;
    *)
        echo "$recordIP"
        echo "Get Record Info Failed!"
        ;;
    esac
}

arApiPost() {
    local inter="https://dnsapi.cn/${1:?'Info.Version'}"
    local param="login_token=${arToken}&format=json&${2}"
    curl -s -k -X POST $inter -d "$param"
}

arDdnsUpdate() {
    local recordID recordRS recordCD recordIP myIP

    # Get Record ID
    recordID=$(arApiPost "Record.List" "domain=${domain}&sub_domain=${subdomain}")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')

    # Update IP
    myIP=$(arIpAddress)
    recordRS=$(arApiPost "Record.Ddns" "domain=${domain}&record_id=${recordID}&sub_domain=${subdomain}&record_type=A&value=${myIP}&record_line=默认")
    recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')
    recordIP=$(echo $recordRS | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/')

    # Output IP
    if [ "$recordIP" = "$myIP" ]; then
        if [ "$recordCD" = "1" ]; then
            echo $recordIP
        fi
        # Echo error message
        echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/'
    else
        echo "Update Failed! Please check your network."
    fi
}

hostIP=$(arIpAddress)
lastIP=$(arDdnsInfo)

echo "Updating Domain: $subdomain.$domain"
echo "HostIP: ${hostIP}"
echo "LastIP: ${lastIP}"
if [ "$lastIP" != "$hostIP" ]; then

    case "$lastIP" in
    [1-9]*)
        postRS=$(arDdnsUpdate)
        echo "postRS: ${postRS}"
        echo "Domain A record has been updated!"
        ;;
    *)
        echo "Got LastIP Error! Stopped!"
        ;;
    esac

elif [ "$lastIP" == "$hostIP" ]; then
    echo "Last Domain A Record Is The Same as The Current IP!"
    echo "Skipped!"
else
    echo "ERROR!"
fi
