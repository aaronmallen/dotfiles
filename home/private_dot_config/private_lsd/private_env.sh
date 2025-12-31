#!/usr/bin/env sh

# Monokai-inspired LS_COLORS for lsd
# di=directory, ln=symlink, so=socket, pi=pipe, ex=executable
# bd=block device, cd=char device, su=setuid, sg=setgid
# tw=sticky+other-writable, ow=other-writable, st=sticky

export LS_COLORS="\
di=1;34:\
ln=1;35:\
so=1;35:\
pi=33:\
ex=1;32:\
bd=1;33:\
cd=1;33:\
su=37;41:\
sg=30;43:\
tw=1;34:\
ow=1;34:\
st=1;34:\
*.tar=1;31:\
*.gz=1;31:\
*.zip=1;31"
