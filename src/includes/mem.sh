#!/bin/bash

gen_process_str(){
    processes=(${1//,/ })
    local str=''

    for item in "${processes[@]}"; do
        str="$str -C $item"
    done

    echo $str;
}

sum_mem_perc(){
    ps $1 --no-headers -o pmem | xargs | sed -e 's/ /+/g' | bc
}

sum_mem_perc_process(){
    process_str=$(gen_process_str $1)

    res=$(sum_mem_perc "$process_str")

    echo $res
}

print_sum_result(){
    local processes=$1
    local res=$2

    if [[ $res == '' ]]; then
        echo "Process <$processes> not found."
    else
        echo "Memory used by <$processes>:"
        echo "$res%"
    fi
}

case $2 in
    q)
        echo
        echo 'Saliendo.'
        echo
        exit 0
        ;;

    proc)
        mem=$(sum_mem_perc_process $3)
        print_sum_result "$3" $mem
        ;;

    app1)
        mem=$(sum_mem_perc_process $AIUR_BIG_APP_1)
        print_sum_result "$AIUR_BIG_APP_1" $mem
        ;;

    app2)
        mem=$(sum_mem_perc_process $AIUR_BIG_APP_2)
        print_sum_result "$AIUR_BIG_APP_2" $mem
        ;;

    *)
        echo "Parameter '$2' not found."
        ;;
esac
