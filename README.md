# DNSPOD Bash Shell

基于DNSPod用户API实现的纯Shell动态域名客户端，适配外网地址。

# Usage

下载dnspod.sh文件，并根据你的配置修改即可。

执行时直接运行`dnspod.sh`，支持cron任务。

配置文件格式：

# 按`TokenID,Token`格式填写
arToken="12345,7676f344eaeaea9074c123451234512d"

# 填写域名信息
domain="Your_Domain_Name"
subdomain="Your_Sub_Domain_Name"
