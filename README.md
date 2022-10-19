# AXI-bus-protocal

DESIGN

    Memory mapping

    slave1 : 0000 to FFFF - I-MEM (read only ?)
    slave2 : 1_0000 to 1_FFFF - D-MEM (valid read and write)
    Defalut slave : 20000 - ffff_ffff (會response ERROR -> RESP == DECERR)
        注意 : 不用寫Default slave, 只要當mem access address at Default slave時 valid = 0就好

    Master : Single Transfer -> Burst Length = 1
    Bridge and Slave : Burst Transfer -> 要做到Burst Length = 4
    要做2M 2S


    burst modes are:
        1、fixed
        2、incremental
        3、wrapping // we only need to implement INCR
    

    The AMBA AXI3 has 5 channels
        1、Write Address Channel
        2、Write Data Channel
        3、Write Response Channel
        4、Read Address Channel
        5、Read Data Channel

    目前寫了master slave 的module 但是各個長度還要再調整


