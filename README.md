# Linux_Tips
  [Readme Help](https://levelup.gitconnected.com/github-readme-cheatsheet-617dff61fa23) 
| [Github Formatting](https://levelup.gitconnected.com/github-readme-cheatsheet-617dff61fa23)
| [Linux Tips](https://github.com/onceupon/Bash-Oneliner/blob/master/README.md#handy-bash-one-liners)
| [Github Emojis](https://github.com/ikatyang/emoji-cheat-sheet/blob/master/README.md#smileys--emotion)
| [Tmux](https://tmuxcheatsheet.com/)


<hr>

### :grinning:	Copy file(s) using base64
https://superuser.com/questions/434210/how-to-copy-files-between-two-open-ssh-shells\
<br>Copy file(s) to destinations without server communication

```
Source:  tar -cz <filestocopy> | base64
Destination: base64 -d | tar -xzv
# Then Paste, and hit enter, then control+d 
```

<details><summary>Alias</summary>

```
alias base="echo 'tar -cz <filestocopy> | base64'
            echo 'base64 -d | tar -xzv'"
```
  
</details>  
<hr>

### :grinning:	Grep IP IP addresses
Input values or files and pipe it to the following to find IP addresses
  
```
grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
```
<details><summary>Alias</summary>
  
```
alias grepip="grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'"
```
</details>  
<hr>

  
### :grinning:	Sort IP Addresses
Input IP addresses and pipe it to the following to sort IP addresses
  
```
sort -nt. -k 1,1 -k 2,2 -k 3,3 -k 4,4
```
<details><summary>Alias</summary>
  
```
alias ipsort='sort -nt. -k 1,1 -k 2,2 -k 3,3 -k 4,4'
```
</details>  
<hr>
