module Ax_mux (
    input [`AXI_ID_BITS-1:0] AxID_M0,
	input [`AXI_ADDR_BITS-1:0] AxADDR_M0,
	input [`AXI_LEN_BITS-1:0] AxLEN_M0,
	input [`AXI_SIZE_BITS-1:0] AxSIZE_M0,
	input [1:0] AxBURST_M0,
	input AxVALID_M0, 

    input [`AXI_ID_BITS-1:0] AxID_M1,
	input [`AXI_ADDR_BITS-1:0] AxADDR_M1,
	input [`AXI_LEN_BITS-1:0] AxLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AxSIZE_M1,
	input [1:0] AxBURST_M1,
	input AxVALID_M1,

    input logic gnt,

    output [`AXI_ID_BITS+3:0] AxID,
	output [`AXI_ADDR_BITS-1:0] AxADDR,
	output [`AXI_LEN_BITS-1:0] AxLEN,
	output [`AXI_SIZE_BITS-1:0] AxSIZE,
	output [1:0] AxBURST,
	output AxVALID,
);
    
    always_comb begin

        case (gnt)

            1'b0:begin
                AxID = {{4'b0000},{AxID_M0}};
				AxADDR = AxADDR_M0;
				AxLEN = AxLEN_M0;
				AxSIZE = AxSIZE_M0;
				AxBURST = AxBURST_M0;
				AxVALID = AxVALID_M0;
            end

			1'b1:begin
				AxID = {{4'b0001},{AxID_M1}};
				AxADDR = AxADDR_M1;
				AxLEN = AxLEN_M1;
				AxSIZE = AxSIZE_M1;
				AxBURST = AxBURST_M1;
				AxVALID = AxVALID_M1;
			end
            
        endcase

    end


endmodule