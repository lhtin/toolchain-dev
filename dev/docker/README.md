```
# 准备环境（包括zsh、gdb、vim、git等配置）
./pre.sh

# 构建镜像
./build.py --image-name gcc-dev-env --build-dir . 

# 启动镜像（以Daemon的形式运行在后台）
# 以当前用户的user_id和group_id创建一个用户
# 也可以通过--user-id和--group-id指定其他用户
./run.py --image-name gcc-dev-env --volume ~/your/project --ssh-port 2222

# 使用SSH登录该镜像（密码为1）
ssh docker@localhost -p 2222
# or
sshpass -p 1 ssh docker@localhost -p 2222
```
