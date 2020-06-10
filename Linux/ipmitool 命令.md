# ipmitool 命令

标签（空格分隔）： ipmi

---
安装ipmi 
yum install ipmitool -y 

载入支持 ipmi 功能的系统模块 
```
modprobe ipmi_msghandler 
modprobe ipmi_devintf 
modprobe ipmi_poweroff 
modprobe ipmi_si 
modprobe ipmi_watchdog 
```


**User**

-  查询用户概要信息
``` ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user summary```
- 查询BMC上所有用户
``` ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user list ```
- 设置用户名
```ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user set name <用户ID> <用户名>```
- 设置用户密码
``` 
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user set password <用户ID> <密码>
```
- 使用用户
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user enable <用户ID>
```
- 禁用用户
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user disable <用户ID>
```
- 设置用户权限
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user priv <用户ID> <级别>
```
- 用户密码测试 
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> user test <16|20> <密码>
```

**Channel**

- 获取通道信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> channel info <channel>
```
- 获取通道认证鉴权能力
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> channel authcap <channel number> <max privilege>
```
- 获取用户权限信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> channel getaccess <channel number>[user id]
```
- 设置用户权限信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> channel setaccess <channel number> <user id> [privilege=level]
```
- 获取通道的加密法套件
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> channel getciphers <ipmi|sol> <channel>
```
**Lan**

- 打印Lan 参数配置信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan print 1
```
- 设置通道IP地址
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> ipaddr <*.*.*.*>
```
- 设置通道子掩码
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> netmask <*.*.*.*>
```
- 设置通道mac地址
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> macaddr <*:*:*:*:*:*>
```
- 设置通道默认网关IP
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> defgw ipaddr <*.*.*.*>
```
- 设置snmp团体名
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> snmp <团体名>
```
- 通道对于IPMI 消息的访问模式
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> access <on>
```
- 使能、禁用虚拟局域网(Virtual Local Area Network)，设置ID
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> vlan id <off|<id>>
```
- 设置通道认证类型
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan set <channel> auth <level> <type,..>
```
- 打印告警信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan alert print <channel number> <alert destination>
```
- 设置告警ip地址
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan alert set <channel number> <alert destination> ipaddr <x.x.x.x>
```
- 设置告警mac地址
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan alert set <channel number> <alert destination> macaddr <x:x:x:x:x:x>
```
- 设置目的地址类型，PET或者OEM
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> lan alert set <channel number> <alert destination> type <pet|oem1>
```
**SOL**

- 显示SOL参数配置信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol info
```
- 建立SOL会话
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol activate
```
- 去激活SOL会话
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol deactivate
```
- 设置SOL通道1使能状态
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set enabled <true|false> <channel>
```
- 设置SOL参数状态
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set set-in-progress <set-complete|set-in-progress|commit-write>
```
- 设置SOL负载是否强制加密
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set force-encryption <true|false>
```
- 设置SOL负载是否强制认证
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set force-authentication <true|false>
```
- 设置建立SOL会话的最低权限级别
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set privilege-level <user|operator|admin|oem>
```
- 设置SOL字符发送间隔，一个单位为5 ms
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set character-accumulate-level <level>
```
- 设置SOL字符门限(32字节)
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set character-send-threshold <bytes>
```
- 设置SOL重发次数
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set retry-count <count>
```
- 设置SOL重发时间间隔（一个单位为10 ms）
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol set retry-interval <interval>
```
- 设置用户对负载的访问权限（和命令参数名不一致）
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol payload <enable|disable> <channel> <用户ID>
```
- SOL连接压力测试
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sol looptest <loop-times> <loop-interval>
```
**BMC**

- BMC执行热（冷）复位
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc reset <warm|cold>
```
- 查询BMC guid信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc guid
```
- 查询BMC的版本信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc info
```
- 设置和查询BMC看门狗状态
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc watchdog <get|reset|off>
```
- 查询BMC自测试结果
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc selftest
```
- 显示目前BMC已经使能的选项的信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc getenables
```
- 设置BMC使能的选项的信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> mc setenables <system_event_log|event_msg|event_msg_intr|oem0|oem1|oem2> <on|off>
```
**Chassis**

- 获取设置底板电源状态信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis status
```
- 设置底板电源状态
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis power <status|on|off|reset|cycle|soft>
```
- 控制前插板指示灯亮
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis identify
```
- 设置单板底板在上电失败后的处理方案
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis policy <list|always-on|always-off|previous>
```
- 查询单板最后一次重起的原因
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis restart_cause
```
- 设置单板下一次启动的启动顺序
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis bootdev <none|pxe|disk|cdrom|floppy>

ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis bootparam set bootflag <force_pxe|force_disk|force_cdrom|force_bios>
  
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> chassis selftest
```

**Event**
- 发送预先定义好的系统事件的编号给单板，可以支持以下3种事件 1 温度过高告警 2 电压过低告警 3 内存ECC错误
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> event <1|2|3>
```
**FRU**
- 查询 FRU 等制造信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> fru
```
**SDR**
- 查询SDR 的相关信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sdr info
```
- 获取传感器信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sdr list <all|full|compact|event|mcloc|fru|generic>
```
**SEL**
- 显示日志的相关信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sel info
```
- 清除BMC上的SEL
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sel clear
```
- 按照指定格式显示日志信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sel list
```
- 显示某一条日志
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sel get <id>
```
- 将日志保存到文件
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sel save <filename>
```
**Sensor**
- 查询传感器信息
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> sensor list
```
**Power**
- 查询电源状态
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> power status
```
- 上电
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> power on
```
- 下电
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> power off
```
- 循环上下电
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> power cycle
```
- 复位
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> power reset
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> power soft
```
>#Raw
- 发送原始命令
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> raw <netfn> <cmd> [data]
```
**PEF**
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> pef <info| status |policy |list>
```
**Session**
- get information regarding which users
presently have active sessions

```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> session info <active >
```
**Exec**
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> exec <filename>
```
**Set**
```
ipmitool -H *.*.*.* -I lanplus -U <用户名> -P <密码> shell
```
**实例**
- 进入grub环境
```
ipmitool -H $BMC_IP -I lanplus -U $USERNAME -P $PASSWORD sol activate
```
- 查看电源状态
```
ipmitool -H $BMC_IP -I lan -U $USERNAME -P $PASSWORD power status
```
- 强制修改启动项，让机器重启后自动进入BIOS设置界面
```
ipmitool -H $BMC_IP -I lanplus -U $USERNAME -P $PASSWORD chassis bootparam set bootflag force_bios
```
- 关掉服务器电源，再打开
```
ipmitool -H $BMC_IP -I lan -U $USERNAME -P $PASSWORD power cycle
```
- 查看BMC信息
```
ipmitool -H $BMC_IP -I lan -U $USERNAME -P $PASSWORD mc info
```
- 显示lan的信息
```
ipmitool -H $BMC_IP -I lan -U $USERNAME -P $PASSWORD lan print
```
- 命令可以获取传感器中的各种监测值和该值的监测阈值，包括（CPU温度，电压，风扇转速，电源调制模块温度，电源电压等信息）
```
Ipmitool –I open sensor list
```
- 可以获取ID为CPU0Temp监测值，CPU0Temp是sensor的ID，服务器不同，ID表示也不同
```
Ipmitool –I open sensor get "CPU0Temp"
```
- 设置ID值等于id的监测项的各种限制值
```
Ipmitool –I open sensor thresh
```
- 查看底盘状态，其中包括了底盘电源信息，底盘工作状态等
```
Ipmitool –I open chassis status
```
- 查看上次系统重启的原因
```
Ipmitool –I open chassis restart_cause
```
- 查看支持的底盘电源相关策略
```
Ipmitool –I open chassis policy list
```
- 启动底盘，用此命令可以远程开机
```
Ipmitool –I open chassis power on
```
- 关闭底盘，用此命令可以远程开机
```
Ipmitool –I open chassis power off
```
- 实现硬重启，用此命令可以远程开机
```
Ipmitool –I open chassis power reset
```
- 使BMC重新硬启动
```
Ipmitool –I open mc reset
```
- 查看BMC硬件信息
```
Ipmitool –I open mc info
```
- 列出BMC所有允许的选项
```
Ipmitool –I open mc getenables
Ipmitool –I open mc setenables
```
- 命令可以用测试配置的IPMI中的snmp功能是否成功
```
Ipmitool-I open event
```
- 打印现咱channel 1的信息 
```
Ipmitool -I open lan print 1
```
- 设置channel 1 的地址为10.10.113.95
```
Ipmitool -I open lan set 1 ipaddr 10.10.113.95
```
- 设置channel 1 上snmp的community为public
```
Ipmitool -I open lan set 1 snmp public
```
- 设置channel 1允许访问
Ipmitool -I open lan set 1 access on

- 打印Platform Event Filtering （pef）信息
Ipmitool -I open pef info
 
- 查看Platform Event Filtering （pef）状态
Ipmitool -I open pef status

- 查看Platform Event Filtering （pef）策略设置
Ipmitool -I open pef policy

- 读取fru信息并显示（但我的服务器有问题，该项读取不到）
Ipmitool -I open sdr list fru









  



  

 





