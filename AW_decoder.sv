module AW_decoder(
	input [`AXI_ID_BITS+3:0] AWID,
	input [`AXI_ADDR_BITS-1:0] AWADDR,
	input [`AXI_LEN_BITS-1:0] AWLEN,
	input [`AXI_SIZE_BITS-1:0] AWSIZE,
	input [1:0] AWBURST,
	input AWVALID,

    output [`AXI_IDS_BITS+3:0] AWID_S0,
	output [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output [1:0] AWBURST_S0,
	output AWVALID_S0,

    output [`AXI_IDS_BITS+3:0] AWID_S1,
	output [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output [1:0] AWBURST_S1,
	output AWVALID_S1
);

    always_comb begin //broadcast

        AWID_S0 = AWID;
        AWADDR_S0 = AWADDR;
        AWLEN_S0 = AWLEN;
        AWSIZE_S0 = AWSIZE;
        AWBURST_S0 = AWBURST;
        AWID_S1 = AWID;
        AWADDR_S1 = AWADDR;
        AWLEN_S1 = AWLEN;
        AWSIZE_S1 = AWSIZE;
        AWBURST_S1 = AWBURST;

    end

    always_comb begin // accroding address to assign valid signal
        
        if(AWADDR >= 32'h0 && AWADDR <= 32'hffff) begin // assign valid signel to slave 0 
            AWVALID_S0 = 0;
            AWVALID_S1 = 0;
        end
        else if(AWADDR > 32'hffff && AWADDR <= 32'h1_ffff) begin // assign valid signel to slave 1 
            AWVALID_S0 = 0;
            AWVALID_S1 = 1;
        end
        else begin  // there is no valid signal and we need to assign (RESP == DECERR)
            AWVALID_S0 = 0;
            AWVALID_S1 = 0;
            // assign (RESP == DECERR) here
        end

    end

    
endmodule