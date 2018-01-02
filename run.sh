#!/bin/sh

set -x

FIO_FILE=bench
FIO_RUNTIME=600
FIO_IODEPTH=32
FIO_JOBS=1
#FIO_ENG=libaio
#FIO_BS=4k
#FIO_MODE=randwrite
#FIO_READ_RATIO=0

fio_exec()
{
    FIO_MODE=$1
    FIO_READ_RATIO=$2
    TYPE=$3
    FIO_ENG=$4
    BS=$5
    ENG=$FIO_ENG RUNTIME=$FIO_RUNTIME IODEPTH=$FIO_IODEPTH JOBS=$FIO_JOBS BS=$BS MODE=$FIO_MODE RATIO=$FIO_READ_RATIO FILE=$FIO_FILE fio $TYPE.fio > $TYPE-$FIO_MODE-$BS-r$FIO_READ_RATIO 2>&1
}

test()
{
    TYPE=$1
    ENG=$2
    fio_exec randwrite 0 $TYPE $ENG 4k
    sleep 15

    fio_exec randread 0 $TYPE $ENG 4k
    sleep 15

    fio_exec write 0 $TYPE $ENG 128k
    sleep 15

    fio_exec read 0 $TYPE $ENG 128k
    sleep 15

    fio_exec randrw 30 $TYPE $ENG 4k
    sleep 15

    fio_exec randrw 70 $TYPE $ENG 4k
    sleep 15
}

case "$1" in
    disk)
        test disk libaio
        break
        ;;
    file)
        test file libaio
        break
        ;;
    rbd)
        test rbd rbd
        break
        ;;
    *)
        echo "input error"
        break
        ;;
esac
