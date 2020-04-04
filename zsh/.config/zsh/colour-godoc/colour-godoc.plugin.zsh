#!/bin/sh

function go() {
    if [ $1 = "doc" ]; then
        command go $@ | sed -re \
            "s/([^A-Za-z0-9]?)(int64|int32|int16|int8|int|rune)([^A-Za-z0-9])/\1`tput setaf 3`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(float64|float32)([^A-Za-z0-9])/\1`tput setaf 3`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(uint64|uint32|uint16|uint8|uintptr|uint|byte)([^A-Za-z0-9])/\1`tput setaf 3`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(complex128|complex64)([^A-Za-z0-9])/\1`tput setaf 3`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(string)([^A-Za-z0-9])/\1`tput setaf 2`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(var|type)([^A-Za-z0-9])/\1`tput setaf 1`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(map|interface)([^A-Za-z0-9])/\1`tput setaf 5`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(func|class)([^A-Za-z0-9])/\1`tput setaf 4`\2`tput sgr0`\3/g;\
            s/([^A-Za-z0-9]?)(bool)([^A-Za-z0-9])/\1`tput setaf 2`\2`tput sgr0`\3/g;"\
            | less -r
    else
        command go $@
    fi
}
