#!/bin/bash
echo "[Test font ligatures]"
echo "-<< -< -<- <-- <--- <<- <- -> ->> --> ---> ->- >- >>-"
echo "=<< =< =<= <== <=== <<= <= => =>> ==> ===> =>= >= >>="
echo "<-> <--> <---> <----> <=> <==> <===> <====> -------->"
echo "<~~ <~ ~> ~~> :: ::: == != /= ~= <> === !== =/= =!="
echo ":= :- :+ <* <*> *> <| <|> |> <. <.> .> +: -: =: :> >=> <=<"
echo "(* *)  [| |] {| |} ++ +++  \\/  /\\ |- -| <!-- <!--- <***>"

echo
echo "[Test emoji]"
echo "😝 🥹 😂 👍 🐶 🍭 "

echo
echo "[Test Chinese]"
echo "门复关直径"
echo "あいうえお"

echo
echo "[Test icon]"
echo "powerline:                                         " 
echo "nerd font:                     "
echo "codicon  :                                             "
echo  "┌─────┬─────┐   ┏━━━━━┳━━━━━┓"
echo  "│     │     │   ┃     ┃     ┃"
echo  "├─────┼─────┤   ┣━━━━━╋━━━━━┫"
echo  "│     │     │   ┃     ┃     ┃"
echo  "└─────┴─────┘   ┗━━━━━┻━━━━━┛"

echo
echo "[Test font style]"
printf "Regular font                       ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\n"
printf "\e[1mBold or increased intensity        ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[2mFaint, decreased intensity, or dim ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[3mItalic                             ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[3m\e[1mbold italic                        ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[4mUnderline                          ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[5mSlow Blink                         ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[6mRapid Blink                        ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[7mReverse video or invert            ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[8mConceal or hide                    ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[9mCrossed-out, or strike             ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[10mPrimary (default) font             ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"
printf "\e[21mDoubly underlined; or: not bold    ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"

printf "\e[4:3mundercurls                         ABCDEFGHIJKLMNOPQRSTUVWXYZabcedefghijklmnopqrstuvwxyz0123456789\e[0m\n"


echo
printf "测试中英文等宽效果这两行文字应该等宽\n"
printf "abcdefghijklmnopqrstuvwxyz0123456789\n"

echo
echo
echo "[Test color]"

for fgbg in 38 48 ; do # Foreground / Background
    for color in {0..255} ; do # Colors
        # Display the color
        printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
        # Display 6 colors per lines
        # if [ $((($color + 1) % 6)) == 4 ] ; then
        #     echo
        # fi
        
        # Display 12 colors per lines
        if [ $color -le 15 -a $((($color) % 8)) == 7 ] ; then
            echo # New line
        elif [ $color -gt 15 -a $((($color) % 12)) == 3 ] ; then
            echo
        fi
    done
    echo # New line
done
printf '\e[48;2;238;212;159m\e[38;2;0;0;0m  #EED49F  \e[0m'
printf '\e[48;2;138;173;244m\e[38;2;0;0;0m  #8AADF4  \e[0m'
printf '\e[48;2;244;219;214m\e[38;2;0;0;0m  #F4DBD6  \e[0m'
printf '\e[48;2;166;218;149m\e[38;2;0;0;0m  #A6DA95  \e[0m'
printf '\e[48;2;198;160;246m\e[38;2;0;0;0m  #C6A0F6  \e[0m'
printf '\e[48;2;125;196;228m\e[38;2;0;0;0m  #7DC4E4  \e[0m'
printf '\e[48;2;169;161;225m\e[38;2;0;0;0m  #A9A1E1  \e[0m'

echo
echo

