#!/bin/bash
uLength="24"
uCount="1"
buf=""
for (( u = 0 ; u < uCount ; u++ )) ; do
    # Output is concatenated to maintain continuity of demonstration.
    # For the real deal, use gpg's --output option and forego looping.
    buf="${buf}$(gpg --armor --gen-random 2 "$uLength")"
done

echo "${buf}"
