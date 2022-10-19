module Ax_decoder(
	input [`AXI_ID_BITS-1:0] AxID,
	input [`AXI_ADDR_BITS-1:0] AxADDR,
	input [`AXI_LEN_BITS-1:0] AxLEN,
	input [`AXI_SIZE_BITS-1:0] AxSIZE,
	input [1:0] AxBURST,
	input AxVALID,

    output [`AXI_IDS_BITS-1:0] AxID_S0,
	output [`AXI_ADDR_BITS-1:0] AxADDR_S0,
	output [`AXI_LEN_BITS-1:0] AxLEN_S0,
	output [`AXI_SIZE_BITS-1:0] AxSIZE_S0,
	output [1:0] AxBURST_S0,
	output AxVALID_S0,

    output [`AXI_IDS_BITS-1:0] AxID_S1,
	output [`AXI_ADDR_BITS-1:0] AxADDR_S1,
	output [`AXI_LEN_BITS-1:0] AxLEN_S1,
	output [`AXI_SIZE_BITS-1:0] AxSIZE_S1,
	output [1:0] AxBURST_S1,
	output AxVALID_S1
);

    always_comb begin //broadcast

        AxID_S0 = AxID;
        AxADDR_S0 = AxADDR;
        AxLEN_S0 = AxLEN;
        AxSIZE_S0 = AxSIZE;
        AXBURST_S0 = AxBURST;
        AxID_S1 = AxID;
        AxADDR_S1 = AxADDR;
        AxLEN_S1 = AxLEN;
        AxSIZE_S1 = AxSIZE;
        AxBURST_S1 = AxBURST;

    end

    always_comb begin // accroding address to assign valid signal
        
        if(AxADDR >= 32'h0 && AxADDR <= 32'hffff) begin // assign valid signel to slave 0 
            AxVALID_S0 = 1;
            AxVALID_S1 = 0;
        end
        else if(AxADDR > 32'hffff && AxADDR <= 32'h1_ffff) begin // assign valid signel to slave 1 
            AxVALID_S0 = 0;
            AxVALID_S1 = 1;
        end
        else begin  // there is no valid signal and we need to assign (RESP == DECERR)
            AxVALID_S0 = 0;
            AxVALID_S1 = 0;
            // assign (RESP == DECERR) here
        end

    end