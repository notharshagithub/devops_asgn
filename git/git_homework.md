# Git Homework

## Task 1: git commit -a -m

### Using `git commit -m`

```bash
harsha@pop-os:~/git-homework$ git init
harsha@pop-os:~/git-homework$ touch file.txt
harsha@pop-os:~/git-homework$ git add file.txt
harsha@pop-os:~/git-homework$ git commit -m "Add file"
[main (root-commit) 1111111] Add file
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 file.txt
```

### Using `git commit -a -m`

```bash
harsha@pop-os:~/git-homework$ echo "Hello Git" >> file.txt
harsha@pop-os:~/git-homework$ git commit -a -m "Update file"
[main 2222222] Update file
 1 file changed, 1 insertion(+)
```

`git commit -a -m` automatically stages modified and deleted tracked files, while `git commit -m` commits only files that are already staged.

---

## Task 2: Git Cherry-Pick

### Create commits in `main`

```bash
harsha@pop-os:~/git-homework$ echo "First" > main.txt
harsha@pop-os:~/git-homework$ git add main.txt
harsha@pop-os:~/git-homework$ git commit -m "Add main file"

harsha@pop-os:~/git-homework$ echo "Second" >> main.txt
harsha@pop-os:~/git-homework$ git commit -am "Update main file"

harsha@pop-os:~/git-homework$ echo "Third" >> main.txt
harsha@pop-os:~/git-homework$ git commit -am "Third main commit"

harsha@pop-os:~/git-homework$ git log --oneline
3333333 Third main commit
2222222 Update main file
1111111 Add main file
```

### Create a new branch

```bash
harsha@pop-os:~/git-homework$ git checkout -b feature
Switched to a new branch 'feature'
```

### Create commits in the new branch

```bash
harsha@pop-os:~/git-homework$ echo "Feature 1" > feature.txt
harsha@pop-os:~/git-homework$ git add feature.txt
harsha@pop-os:~/git-homework$ git commit -m "Add feature file"

harsha@pop-os:~/git-homework$ echo "Feature 2" >> feature.txt
harsha@pop-os:~/git-homework$ git commit -am "Update feature file"

harsha@pop-os:~/git-homework$ git log --oneline
5555555 Update feature file
4444444 Add feature file
3333333 Third main commit
2222222 Update main file
1111111 Add main file
```

### Cherry-pick a specific commit

```bash
harsha@pop-os:~/git-homework$ git checkout main
Switched to branch 'main'

harsha@pop-os:~/git-homework$ git cherry-pick 4444444
[main 6666666] Add feature file
 1 file changed, 1 insertion(+)
 create mode 100644 feature.txt
```

### Verify the cherry-picked commit

```bash
harsha@pop-os:~/git-homework$ git log --oneline
6666666 Add feature file
3333333 Third main commit
2222222 Update main file
1111111 Add main file

harsha@pop-os:~/git-homework$ cat feature.txt
Feature 1
```
