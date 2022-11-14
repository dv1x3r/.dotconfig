pass_path=${1}
pass_line=${2:-1}
if [ -z $pass_path ]
    then
        echo "pwc <path> [line]"
    else
        pass ${pass_path} | sed -n ${pass_line}p | clip.exe
fi
