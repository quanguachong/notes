# git command

```bash
git branch <name>                         本地创建新分支
(git checkout -b <name>                   创建并切换到新分支)
git branch -d <name>                      删除本地分支
git checkout <name>                       切换到分支
git rebase master

rm -rf .git                               删除本地仓库

git push origin <name>                    将新分支发布在gitlab上
git branch <name>  origin/<name>         拉取远程某个分支到本地
git branch -a                             查看远程分支
git branch -r -d origin/<name>            删除远程分支
git checkout tags/<tag_name> -b <branch_name> 拉取远程tags分支到本地
```