
### :smirk:	TMUX  
Link:  [TMUX Github](https://github.com/tmux/tmux/wiki)
| [Command Cheat Sheet](https://tmuxcheatsheet.com/)

Tmux is a terminal multiplexer that can minipulate the terminal in ways to increase productivity by opening up multiple isolated panes of the same session.

### :smirk:	Tmux Commands

Start a new session
```
tmux
OR
tmux new -s SessionName
```

List sessions
```
tmux ls
```

Attach to session
```
tmux a
OR
tmux a -t SessionName
```

When inside a tmux session, use prefix ctrl+b followed by the following to navigate through tmux. 

Key | Description | Notes
------------ | ------------- | -------------
d | detach from session | can be used for log running queries
x | kill pane | can also use ctrl+d
" | creates horizontal pane |
% | creates vertical pane |
q | show pane numbers | 
z | zoom inside pane | for full screen view to that pane
c | creates new window |
n | move to next window |
p | move to previous window |
Spacebar | Switch between layouts |
arrow keys | move through panes | holding down ctrl while using ctrl+b prefix and using arrow keys resizes panes
\[ |  enables scrolling | 
:setw synchronize-panes | syncronizes keyboard input to all open panes |




<hr>

### :smirk:	xmux: A script to automatically launch multiple windows.
<br>

My Usage:  Created a file in /usr/bin called xmux  and make it executable (you can choose another word).  

[^note]:
    Named footnotes will still render with numbers instead of the text but allow easier identification and linking.  
    This footnote also has been made with a different syntax using 4 spaces for new lines.

  
```bash
#!/bin/sh
# ssh-multi
# D.Kovalov
# Based on http://linuxpixies.blogspot.jp/2011/06/tmux-copy-mode-and-how-to-control.html
# Modified by johnko https://gist.github.com/johnko/a8481db6a83ec5ea2f37

# a script to ssh multiple servers over multiple tmux panes


starttmux() {
    count=0
    if [ -z "${1}" ]; then
        echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
        read HOSTS
    else
        HOSTS=$*
    fi

    for i in ${HOSTS} ; do
        count=$(( count + 1 ))
        if [ ${count} -eq 1 ]; then
            if tmux ls >/dev/null 2>/dev/null ; then
                tmux new-window "ssh ${i}"
            else
                tmux new-session -d "ssh ${i}"
            fi
        else
            tmux split-window -h  "ssh ${i}"
            tmux select-layout tiled >/dev/null
        fi
    done

    tmux select-pane -t 0
    #tmux set-window-option synchronize-panes on >/dev/null

}

starttmux $*

tmux attach
```
| :point_up:     Uncommenting tmux set-window-option synchronize-panes on >/dev/null will syncronize keyboard input to all panes once opened  |
|-----------------------------------------|

Then call it by typing:
```
xmux host1 host2 host3 etc.  
```
<hr>

