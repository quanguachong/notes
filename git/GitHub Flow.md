# GitHub Flow

## 1.Create a branch

1. The master branch is always deployable. So when working on a project, create a new branch.
2. Your branch name should be descriptive, so that others can see what is being worked on.(e.g., refactor-authentication, user-content-cache-key, make-retina-avatars)

## 2.Add commits

1. Change your branch and add commits. Each commit has a message, and considered a separate unit of change. This lets you roll back changes.
2. Commit messages are important

## 3.Open a pull request

1. Pull Requests initiate discussion about your commits. Because they're tightly integrated with the underlying Git repository, anyone can see exactly what changes would be merged if they accept your request.
2. You can open a Pull Request at any point during the development process:
* when you're ready for someone to review your work
* when you have little or no code but want to share some screenshots or general ideas
* when you're stuck and need help or advice

## 4.Discuss and review your code

1. Once a Pull Request has been opened, the person or team reviewing your changes may have questions or comments.
2. Pull Request comments are written in Markdown, so you can embed images and emoji...

## 5.Deploy

You can deploy from a branch for final testing in production before merging to master.If your branch causes issues, you can roll it back.

## 6.Merge

1. Now that your changes have been verified in production, it is time to merge your code into the master branch.
2. Once merged, Pull Requests preserve a record of the historical changes to your code. They are searchable.
3. By incorporating certain keywords into the text of your Pull Request, you can associate issues with code. When your Pull Request is merged, the related issues are also closed. For example:
    * Entering the phrase Closes #32 would close issue number 32 in the repository.
    * A commit message with Fixes #45 will close issue 45 in that repository once the commit is merged into the default branch.