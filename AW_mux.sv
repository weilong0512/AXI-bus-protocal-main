module AW_mux (
    // input [`AXI_ID_BITS-1:0] AWID_M0,
	// input [`AXI_ADDR_BITS-1:0] AWADDR_M0,
	// input [`AXI_LEN_BITS-1:0] AWLEN_M0,
	// input [`AXI_SIZE_BITS-1:0] AWSIZE_M0,
	// input [1:0] AWBURST_M0,
	// input AWVALID_M0, 

    input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,

    input logic gnt,

    output [`AXI_IDS_BITS+3:0] AWID,
	output [`AXI_ADDR_BITS-1:0] AWADDR,
	output [`AXI_LEN_BITS-1:0] AWLEN,
	output [`AXI_SIZE_BITS-1:0] AWSIZE,
	output [1:0] AWAWBURST,
	output AWVALID,
);
    
    always_comb begin

        case (gnt)

            2'b01:begin
                AWID = {{4'b0000},{4'b0000}};
				AWADDR = 0;
				AWLEN = 0;
				AWSIZE = 0;
				AWBURST = 0;
				AWVALID = 0;
            end

			2'b10:begin
				AWID = {{4'b0001},{AWID_M1}};
				AWADDR = AWADDR_M1;
				AWLEN = AWLEN_M1;
				AWSIZE = AWSIZE_M1;
				AWBURST = AWBURST_M1;
				AWVALID = AWVALID_M1;
			end

			default: ;
            
        endcase

    end


endmodule