# git command

```bash
git branch <name>                         本地创建新分支
(git checkout -b <name>                   创建并切换到新分支)
git branch -d <name>                      删除本地分支
git checkout <name>                       切换到分支

rm -rf .git                               删除本地仓库

git push origin <name>                    将新分支发布在gitlab上
git push origin <local_branch_name>:<remote_branch_name> 本地分支push到远程
git branch <name>  origin/<name>          拉取远程某个分支到本地
git branch -a                             查看远程分支
git branch -r -d origin/<name>            删除远程分支
git checkout tags/<tag_name> -b <branch_name> 拉取远程tags分支到本地

git reset --hard <commitID>               强行设成commitID对应的版本
git rebase master                         同步master到当前分支
git rebase -i <commitID> 进行commit message修改
```