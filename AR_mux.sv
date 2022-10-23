module AR_mux (
    input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0, 

    input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,

    input logic gnt,

    output [`AXI_ID_BITS+3:0] ARID,
	output [`AXI_ADDR_BITS-1:0] ARADDR,
	output [`AXI_LEN_BITS-1:0] ARLEN,
	output [`AXI_SIZE_BITS-1:0] ARSIZE,
	output [1:0] ARBURST,
	output ARVALID,
);
    
    always_comb begin

        case (gnt)

            2'b01:begin
                ARID = {{4'b0000},{ARID_M0}};
				ARADDR = ARADDR_M0;
				ARLEN = ARLEN_M0;
				ARSIZE = ARSIZE_M0;
				ARBURST = ARBURST_M0;
				ARVALID = ARVALID_M0;
            end

			2'b10:begin
				ARID = {{4'b0001},{ARID_M1}};
				ARADDR = ARADDR_M1;
				ARLEN = ARLEN_M1;
				ARSIZE = ARSIZE_M1;
				ARBURST = ARBURST_M1;
				ARVALID = ARVALID_M1;
			end

			default: ;
            
        endcase

    end


endmodule