`define AXI_ID_BITS 4
`define AXI_IDS_BITS 8
`define AXI_ADDR_BITS 32
`define AXI_LEN_BITS 4
`define AXI_SIZE_BITS 3
`define AXI_DATA_BITS 32
`define AXI_STRB_BITS 4
`define AXI_LEN_ONE 4'h0
`define AXI_SIZE_BYTE 3'b000
`define AXI_SIZE_HWORD 3'b001
`define AXI_SIZE_WORD 3'b010
`define AXI_BURST_INC 2'h1
`define AXI_STRB_WORD 4'b1111
`define AXI_STRB_HWORD 4'b0011
`define AXI_STRB_BYTE 4'b0001
`define AXI_RESP_OKAY 2'h0
`define AXI_RESP_SLVERR 2'h2
`define AXI_RESP_DECERR 2'h3

`define AXI_BUSET_LEN_MAX   16
`define AXI_ID_MAX          16


// AR {1 + extendID + ID + ADDR + LEN + SIZE + BURST}
`define BL_AR_info          50      // 1+4+`AXI_ID_BITS+`AXI_ADDR_BITS+`AXI_LEN_BITS+`AXI_SIZE_BITS+2
`define BP_AR_info_valid    49
`define BP_AR_info_M        45      // 49 - 4
`define BP_AR_info_S        25      // 49 - (1+4+4+15)

`define BP_AR_info_ERRADDR  40:26
`define BL_AR_info_ERRADDR  15

`define BP_AR_info_IDS      48:41
`define BP_AR_info_ID       44:41
`define BP_AR_info_LEN      8:5

// AR_info_reg
`define BL_AR_info_reg      12      // `AXI_IDS_BITS + `AXI_LEN_BITS
`define BP_AR_info_reg_LEN  3:0
`define BP_AR_info_reg_M    8
`define BP_AR_info_reg_ID   7:4

// R {VALID + IDS + DATA + RESP + LAST + Slave_number}
`define BL_R_info           45      // 1+`AXI_IDS_BITS+`AXI_DATA_BITS+2+1+1
`define BP_R_info_valid     44
`define BP_R_info_S         0
`define BP_R_info_M         40
`define BP_R_info_ID2tail   39:1
`define BP_R_info_IDS       43:36


// mux_R_err_out   {VALID + ID + DATA + RESP + LAST}
`define BL_R_err_out        40      // 1+`AXI_ID_BITS+`AXI_DATA_BITS+2+1 -> 40
`define BP_R_err_out_LAST   0   
`define BP_R_err_out_valid  39   


// AW {VALID + extendID + ID + ADDR + LEN + SIZE + BURST}
`define BL_AW_info          50      // 1+4+`AXI_ID_BITS+`AXI_ADDR_BITS+`AXI_LEN_BITS+`AXI_SIZE_BITS+2
`define BP_AW_info_valid    49
`define BP_AW_info_M        45      // 49 - 4
`define BP_AW_info_S        25      // 49 - (1+4+4+15)

`define BP_AW_info_ERRADDR  40:26
`define BL_AW_info_ERRADDR  15

`define BP_AW_info_IDS      48:41
`define BP_AW_info_LEN      8:5

// AW_info_reg
`define BL_AW_info_reg      9      // IDS + Slave number
`define BP_AW_info_reg_S    0
`define BP_AW_info_reg_ID   4:1     // ID

// W {VALID + DATA + STRB + LAST}
`define BL_W_info           38      // 1+`AXI_DATA_BITS+`AXI_STRB_BITS+1
`define BP_W_info_valid     37
`define BP_W_info_LAST      0


// B {VALID + IDS + RESP}
`define BL_B_info           11      // 1+`AXI_IDS_BITS+2
`define BP_B_info_valid     10
`define BP_B_info_ID2tail   5:0

// B_info_err
`define BL_B_info_err       7








////////////////////////
`define CPU_WRAPPER_RM0_INI  2'd0
`define CPU_WRAPPER_RM0_SEND 2'd1
`define CPU_WRAPPER_RM0_WAIT 2'd2

`define CPU_WRAPPER_RM1_INI    3'd0
`define CPU_WRAPPER_RM1_RSEND  3'd1
`define CPU_WRAPPER_RM1_RWAIT  3'd2
`define CPU_WRAPPER_RM1_WSEND  3'd3
`define CPU_WRAPPER_RM1_WWAIT  3'd4
`define CPU_WRAPPER_RM1_WREADY 3'd5

`define SRAM_WRAPPER_INI    3'd0
`define SRAM_WRAPPER_GETRA  3'd1
`define SRAM_WRAPPER_SEND   3'd2
`define SRAM_WRAPPER_GETWA  3'd3
`define SRAM_WRAPPER_GETW   3'd4
`define SRAM_WRAPPER_WRITE  3'd5


