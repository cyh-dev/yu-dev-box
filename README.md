# yu-dev-box

记录常用的工具和配置的脚本

# 使用方法
1. 下载项目
``` shell
git clone --recursive https://github.com/cyh-dev/yu-dev-box.git
```

## shell常用工具脚本
### zsh终端配置
1. 在.zshrc中加入
``` shell
# yu-dev-box
export YU_DEV_BOX="仓库目录路径"
source $YU_DEV_BOX/yu-zshrc.sh
```
2. 重新加载.zshrc
``` shell
source ~/.zshrc
```

### bash终端配置
1. 在.bashrc中加入
``` shell
# yu-dev-box
export YU_DEV_BOX="仓库目录路径"
source $YU_DEV_BOX/yu-bashrc.sh
```
2. 重新加载.bashrc
``` shell
source ~/.bashrc
```

## docker 常用镜像
### yu-dev-centos7
镜像功能：基础镜像为centos7, 工作空间路径为/workspace, 可以将该工作路径挂载在本地目录，可以将一些容器内的数据保存下来。
| 开发环境 | 是否 | 说明 |
|---------|---------|---------|
| python2  | &#x2714;  | /usr/bin/python  |
| python2-pip  | &#x2714;  | /usr/bin/pip  |
| python3  | &#x2714;  | /usr/local/bin/python3  |
| virtualenvwrapper  | &#x2714;  | python虚拟环境管理工具  |
|   | &#x2714;  | /usr/local/bin/pip3  |
| gvm  | &#x2714;  | golang多环境管理工具，使用gvm install安装golang环境  |
| golang  | &#x2714;  | 可以使用gvm安装后使用  |
| make  | &#x2714;  |  |
| vim  | &#x2714;  |  |
| ssh  | &#x2714;  | 启动/usr/sbin/ssd,root密码随机生成在/root/.passwd文件中 |
| zsh | &#x2714;  | 默认使用zsh |
| oh-my-zsh | &#x2718;  | 需要在将/workspace目录挂在到本地，然后将本项目下载到/workspace后默认开启 |



常用开发环境构建了常用的python2、python3环境，以及虚拟环境工具
1. build镜像
```shell
docker build -t yu-dev-centos7 -f docker/yu-dev-centos7.Dockerfile .
```

2. 启动镜像
```
docker run -it --name yu-dev-centos7 --hostname yu-dev-centos7 -p 2222:22 -v $HOME/workspace/centos7:/workspace yu-dev-centos7 
```

3. 进入镜像
```shell
docker exec -it yu-dev-centos7 /bin/zsh
```


