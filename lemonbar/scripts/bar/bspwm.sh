#!/usr/bin/env bash

if ! type bspc &> /dev/null; then
	echo "bspc not found"
	exit 1
fi

process () {
	case $1 in
		W*)
			IFS=':'
			set -- ${1#?}
            RET="B"
            IFS=$'\n'
			while [ $# -gt 0 ]; do
				item="$1"
				name="${item#?}"

                if [[ $name =~ ^[0-9]+$ ]]; then
                    num=$( bspc query -N -n .window -d $name | wc -l )
                    RET="${RET}%{A:bspc desktop -f $name:}"

                    case $item in
                        f*)
                            # free desktop
                            RET="${RET}%{F-}"
                            ;;
                        F*)
                            # focused free desktop
                            RET="${RET}%{F#$THEME_BAR_HIGHLIGHT}"
                            ;;
                        o*)
                            # occupied desktop
                            RET="${RET}%{F-}"
                            ;;
                        O*)
                            # focused occupied desktop
                            RET="${RET}%{F#$THEME_BAR_HIGHLIGHT}"
                            ;;
                        u*)
                            # urgent desktop
                            RET="${RET}%{F#$THEME_BAR_HIGHLIGHT}"
                            ;;
                        U*)
                            # focused urgent desktop
                            RET="${RET}%{F#$THEME_BAR_HIGHLIGHT}"
                            ;;
                    esac

                    case $num in
                        0)
                            RET="${RET} \ue001 "
                            ;;
                        1)
                            RET="${RET} \ue000 "
                            ;;
                        2)
                            RET="${RET} \ue006 "
                            ;;
                        3)
                            RET="${RET} \ue004 "
                            ;;
                        4)
                            RET="${RET} \ue002 "
                            ;;
                        *)
                            RET="${RET} \ue007 "
                            ;;
                    esac

                    RET="${RET}%{A}%{F-}"
				fi

				shift
			done
	esac
	echo -e $RET
}

while read -r line; do
    process "$line"
done < <(bspc subscribe report)
