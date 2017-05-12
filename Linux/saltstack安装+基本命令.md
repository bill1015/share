# saltstack安装+基本命令

标签（空格分隔）： saltstack

---

**环境：**
node1:172.16.1.60   OS:centos 7.3   master   hostname:centos7u3-1
node2:172.16.1.61   OS:centos 7.3   minion   hostname:centos7u3-2

**准备工作：**
在/etc/hosts文件中添加（如有DNS服务器，此操作可不用操作）
172.16.1.60 centos7u3-1
172.16.1.61 centos7u3-2

**master 安装:**
yum install salt-master salt-minion -y

配置：

$$[root@centos7u3-1 srv]# egrep -v '^#|^$' /etc/salt/master 
```
auto_accept: True       **#打开自动注册**
file_roots:
   base:
     - /srv/salt/
pillar_roots:
  base:
    - /srv/pillar
```
[root@centos7u3-1 srv]# egrep -v '^#|^$' /etc/salt/minion
master: 172.16.1.60

**启动服务：**
systemctl start salt-master salt-minion

**minion安装:**
yum install salt-minion -y 
[root@centos7u3-2 ~]# egrep -v '^#|^$' /etc/salt/minion
master: 172.16.1.60


## 查看当前的salt key信息
salt-key -L

## 测试被控主机的连通性
salt '*' test.ping
## 远程命令执行测试
 salt '*' cmd.run 'uptime'
## 根据被控主机的grains信息进行匹配过滤
salt -G 'os:Centos' test.ping
## 显示被控主机的操作系统类型
 salt '*' grains.item os
## 远程代码执行测试
salt '*' cmd.exec_code python 'import sys; print sys.version'
常用模块介绍
## (1)、cp模块（实现远程文件、目录的复制，以及下载URL文件等操作）
> * 将主服务器file_roots指定位置下的目录复制到被控主机
 salt '*' cp.get_dir salt://hellotest /data
 
> * 将主服务器file_roots指定位置下的文件复制到被控主机
 salt '*' cp.get_file salt://hellotest/rocketzhang /root/rocketzhang
 
> * 下载指定URL内容到被控主机指定位置
 salt '*' cp.get_url http://xxx.xyz.com/download/0/files.tgz /root/files.tgz
 
## (2)、cmd模块（实现远程的命令行调用执行）
 salt '*' cmd.run 'netstat -ntlp'
 
(3)、cron模块（实现被控主机的crontab操作）
## 为指定的被控主机、root用户添加crontab信息
 salt '*' cron.set_job root '*/5' '*' '*' '*' '*' 'date >/dev/null 2>&1'
 salt '*' cron.raw_cron root
 
## 删除指定的被控主机、root用户的crontab信息
 salt '*' cron.rm_job root 'date >/dev/null 2>&1'
 salt '*' cron.raw_cron root
 
## (4)、dnsutil模块（实现被控主机通用DNS操作）
> * 为被控主机添加指定的hosts主机配置项
 salt '*' dnsutil.hosts_append /etc/hosts 127.0.0.1 rocketzhang.qq.com
 
## (5)、file模块（被控主机文件常见操作，包括文件读写、权限、查找、校验等）
 salt '*' file.get_sum /etc/resolv.conf md5
 salt '*' file.stats /etc/resolv.conf
## (6)、network模块（返回被控主机网络信息）
 salt '*' network.ip_addrs
 salt '*' network.interfaces

 
## (7)、pkg包管理模块（被控主机程序包管理，如yum、apt-get等）
 salt '*' pkg.install nmap
 salt '*' pkg.file_list nmap
 
## (8)、service 服务模块（被控主机程序包服务管理）
 salt '*' service.enable crond
 salt '*' service.disable crond
 salt '*' service.status crond
 salt '*' service.stop crond
 salt '*' service.start crond
 salt '*' service.restart crond
 salt '*' service.reload crond

## (9)、更多功能
更多的功能，比如：grains、pillar、states、modules、returner、runners、reactor等，还有如下高级命令的使用，以及模板配置的渲染、扩展模块的二次开发等，可以自己去深入学习哈。


**salt相关的管理命令：**
salt-run manage.up                               # 查看存活的minion
salt-run manage.down                            # 查看死掉的minion
salt-run manage.down removekeys=True      # 查看down掉的minion，并将其删除
salt-run manage.status                          # 查看minion的相关状态
salt-run manage.versions                        # 查看salt的所有master和minion的版本信息
salt-run jobs.active                               # 查看哪些系统任务还在处理中
salt-run jobs.list_jobs                            # 显示所有的已完成或部分完成的任务信息
salt '*' saltutil.running                           # 查看运行的jobs ID
salt \* saltutil.kill_job 20151209034239907625 # kill掉进程ID
salt -d                                              # 查看帮助文档
salt -d|grep service                               # 查看service相关模块命令
salt '*' sys.doc                                   # 查看帮助文档
salt-key  -L                                       # 查询所有接收到的证书
salt-key  -a <证书名>                           # 接收单个证书
salt-key  -A                                    # 接受所有证书
salt-key  -d <证书名>                          # 删除单个证书
salt-key  -D                                    # 删除所有证书
salt '*' service.get_all                        # 获取主机所有服务
salt '*' service.reload sshd                        # 重载sshd服务
salt '*' pkg.list_pkgs                                 # 显示软件包版本列表
salt '*' pkg.version python                        # 显示软件包版本信息
salt '*' pkg.install httpd                        # 安装软件包
salt 'node1.com' service.status mysql                # 查看mysql服务状态
salt 'node1.com' service.start mysql                # 启动mysql服务
salt 'node1.com' cmd.run 'service mysql status'        # 与上面一样查看服务
salt '*' sys.list_modules                        # 模块列表
salt-cp '*'  /etc/hosts   /etc/hosts               # 把master上的hosts文件分发到所有主机
salt '*' cp.get_file salt://ceshi/b /tmp/test       # 把salt-master端相应的文件，分发文件到minion端
salt '*' cp.get_dir salt://zabbix /tmp               # 把salt-master端相应的目录，分发文件到minion端
salt '*' file.copy /tmp/zabbix.sls /tmp/sls        # 把salt-master端对应文件拷贝到minion端相应目录下
salt '*' cmd.run 'uptime'                         # 远程命令执行测试

远程执行脚本：
'cmd.script:'
        salt '*' cmd.script salt://scripts/runme.sh
        salt '*' cmd.script salt://scripts/runme.sh 'arg1 arg2 "arg 3"'
        salt '*' cmd.script salt://scripts/windows_task.ps1 args=' -Input c:\tmp\infile.txt' shell='powershell'
        salt '*' cmd.script salt://scripts/runme.sh stdin='one\ntwo\nthree\nfour\nfive\n'
'cmd.shell:'
        This passes the cmd argument directly to the shell
        salt '*' cmd.shell "ls -l | awk '/foo/{print \$2}'"
        salt '*' cmd.shell template=jinja "ls -l /tmp/{{grains.id}} | awk '/foo/{print \$2}'"
        salt '*' cmd.shell "Get-ChildItem C:\ " shell='powershell'
        salt '*' cmd.shell "grep f" stdin='one\ntwo\nthree\nfour\nfive\n'
        salt '*' cmd.shell cmd='sed -e s/=/:/g'
'cmd.shells:'
        salt '*' cmd.shells
'cmd.tty:'
        salt '*' cmd.tty tty0 'This is a test'
        salt '*' cmd.tty pts3 'This is a test'
'cmd.which:'
        salt '*' cmd.which cat



**grains选项：**
salt '*' grains.ls                    # 查看grains分类
salt '*' grains.items                      # 查看grains所有信息
salt '*' grains.item osrelease                  # 查看grains某个信息







