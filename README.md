# DNSPOD Bash Shell

基于DNSPod用户API实现的纯Shell动态域名客户端，适配外网地址。

# Usage

目前dnspod仅支持密钥登录，申请地址 https://console.dnspod.cn/account/token

不支持腾讯云API访问控制!!!

下载dnspod.sh文件，并根据你的配置修改即可。

执行时直接运行`dnspod.sh`，支持cron任务。

配置文件格式：

# 按`TokenID,Token`格式填写
```
arToken="12345,7676f344eaeaea9074c123451234512d"
```

# 填写域名信息
```
domain="Your_Domain_Name"
subdomain="Your_Sub_Domain_Name"
```

## 安装
ubuntu/debian
```
apt-get update
apt-get install wget curl dnsutils openssl cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/dnspod/master/dnspod.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/dnspod/raw/master/dnspod.sh
chmod +x ./dnspod.sh
```

centos
```
yum install wget curl bind-utils openssl cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/dnspod/master/dnspod.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/dnspod/raw/master/dnspod.sh
chmod +x ./dnspod.sh
```

## 首次操作
第一步，先在DNSPOD管理控制台```https://console.dnspod.cn/account/token```申请Token

第二步，在```dnspod.sh```内按照提示填写相应信息。

第三步，运行```dnspod.sh```，设置定时任务

## 设置定时任务
```
crontab -e
*/1 * * * * bash /root/dnspod.sh
```
