#!/bin/zsh
buf=""
find "${HOME}/.local/share/text_snippets" -name "*.txt" | while read _p; do
    buf+="`basename ${_p}` - `cat ${_p} | tr '\n' ' ' | cut -c-50`"
    if [ "`wc -c ${_p} | awk '{print $1}'`" -gt 50 ]; then
        buf+="..."
    fi
    buf+="\n"
done

selection=`echo -n "${buf}" | rofi -dmenu`
snip=`printf "%s " "${selection}" | awk '{print $1}'`
cat "${HOME}/.local/share/text_snippets/${snip}" | perl -p -e 'chomp if eof' | xsel -ib

# Buggy, causes ? to become _ etc. Keyboard layout issue?
#xdotool type --clearmodifiers --file - 1>/dev/null
