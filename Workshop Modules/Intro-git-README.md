# intro-git
An example test

This line is from R-Studio

Repository (Repo): A folder to store files.

Clone: Method of copying a remot repository to your local machine

Commit: An additional save. For remebering a specific version of your set of files. Make a commt when you're code is working or when you've completed a task on your to do list. (Or if you're work is still in progress that's OK too). Include a meaning commit message that is concise. 

This is an edit from GitHub

## Workflow tips

Steps for starting Github project:

1) Create a new repository on GitHub
2) Clone (copy the URL) of the repo you just made on Github.
3) Start a new R-Studio project, but this time not using a new directory but rather checking out a version controlled git repo.

Workflow:
1) Make changes locally through R and save.
2) Stage and commit those files
3) Pull changes
4) Push changes

Always COMMIT, PULL, PUSH!

# Git Fundamentals

diffs (differenes): Git doesn't just record a snapshot of your data, it also builds a set of differences over time. Git stores the initial commit of the full and all the subsequent diffs.

## Git Commands

All of these commands can be run from the terminal (shell, bash)

git clone

git add: stages specific files

git commit --message "A commit message"

git pull

git push

# Branches

You can create a new branch from within R, using the terminal.

To create the branch:
git branch name-of-branch 

To checkout: 
git checkout branch-1

git reset HEAD^

git reset HEAD^ allows you to remove temporary commits from your commit history. The reason to do this is to de-clutter your commit history.

## Merging a branch

To merge a branch, first checkout the branch you want a another branch to be merged into. We want to merge branch-1 into master.
To merge:
git merge name-of-branch
