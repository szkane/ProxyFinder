#!/bin/bash

# 代理列表文件路径
PROXY_LIST='proxies.txt'

# 成功的代理将被写入此文件
WORKING_PROXIES='working_proxies.txt'

# 测试的URL
URL='http://www.gstatic.com/generate_204'

# 清空或创建工作代理文件
> "$WORKING_PROXIES"

# 读取代理列表并进行测试
while IFS= read -r proxy
do
    echo "Testing proxy: $proxy"
    STATUS_CODE=$(curl -s -o /dev/null -w '%{http_code}' --proxy "$proxy" "$URL" --connect-timeout 3)
    
    if [ "$STATUS_CODE" -eq 204 ]; then
        echo "Proxy $proxy is working."
        echo "$proxy" >> "$WORKING_PROXIES"
    else
        echo "Proxy $proxy failed."
    fi
done < "$PROXY_LIST"

# 统计工作代理文件中的行数
WORKING_COUNT=$(wc -l < "$WORKING_PROXIES")
echo -e "\033[0;31m Result: $WORKING_COUNT working proxies have been saved to $WORKING_PROXIES"
