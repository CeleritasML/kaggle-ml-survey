# kaggle-ml-survey
A machine learning research of [the 2021 Kaggle Machine Learning &amp; Data Science Survey](https://www.kaggle.com/c/kaggle-survey-2021) dataset.

## EDA

This [link](https://www.kaggle.com/paultimothymooney/2021-kaggle-data-science-machine-learning-survey) contains an exploring data analysis of the kaggle survey dataset.

## Branch Definition

**main**: master branch, cannot push, only pull request.  
**feat/[branch_name]**: feature branch, several people work together on same branch.  
**p/[username]/[branch_name]**: personal branch, only one person works on the branch.

Example:

    feat/data_clean
    p/gaojingsong/fix_missing_value

A feature branch should be created from **main** and use **pull request** on GitHub to merge the branch back to **main** after developing.

A personal branch should be created from either **main** or a feature branch and also use **pull request** to merge back.


## Commit Username and Email

Set the commit username to your pinyin name and the commit email to GU email. Example:

    git config --global user.name gaojingsong
    git config --global user.email jg2109@georgetown.edu

**--global** is not required.

## Commit Rule
Please use and only use these prefix in your commit message:

- **feat**: add a new feature
- **fix**: fix a bug
- **refactor**: refactor of the code, neither a new feature nor a bug fix
- **perf**: improve the running efficiency
- **docs**: add documentation, for example, README.md
- **chore**: change of build/config files, for example, .gitignore, .gitattributes, etc
- **revert**: revert a previous commit

Commit messages should be like:

    <prefix>: <content>
    feat: add LinearSVC model
    chore: update .gitignore
