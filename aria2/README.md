1. 修改aria2.conf文件，修改里面的密码、下载保存位置；
2. 在`${HOME}/.config`目录创建指向`aria2`的软链接
3. 复制`aria2@.service`文件到`/usr/lib/systemd/system/`目录
4. 启动aria2：`systemctl start aria2@root.service`
5. 设置开机启动：`systemctl enable aria2@root.service`
