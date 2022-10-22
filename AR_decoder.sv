module AR_decoder(
	input [`AXI_ID_BITS+3:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
    
    output [`AXI_IDS_BITS+3:0] ARID_S0,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output [1:0] ARBURST_S0,
	output ARVALID_S0,

    output [`AXI_IDS_BITS+3:0] ARID_S1,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output [1:0] ARBURST_S1,
	output ARVALID_S1
);

    always_comb begin //broadcast

        ARID_S0 = ARID;
        ARADDR_S0 = ARADDR;
        ARLEN_S0 = ARLEN;
        ARSIZE_S0 = ARSIZE;
        ARBURST_S0 = ARBURST;
        ARID_S1 = ARID;
        ARADDR_S1 = ARADDR;
        ARLEN_S1 = ARLEN;
        ARSIZE_S1 = ARSIZE;
        ARBURST_S1 = ARBURST;

    end

    always_comb begin // accroding address to assign valid signal
        
        if(ARADDR >= 32'h0 && ARADDR <= 32'hffff) begin // assign valid signel to slave 0 
            ARVALID_S0 = 1;
            ARVALID_S1 = 0;
        end
        else if(ARADDR > 32'hffff && ARADDR <= 32'h1_ffff) begin // assign valid signel to slave 1 
            ARVALID_S0 = 0;
            ARVALID_S1 = 1;
        end
        else begin  // there is no valid signal and Re need to assign (RESP == DECERR)
            ARVALID_S0 = 0;
            ARVALID_S1 = 0;
            // assign (RESP == DECERR) here
        end

    end

endmodule