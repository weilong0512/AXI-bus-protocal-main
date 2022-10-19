module W_mux (
	input [`AXI_DATA_BITS-1:0] WDATA_M0,
	input [`AXI_STRB_BITS-1:0] WSTRB_M0,
	input WLAST_M0,
	input WVALID_M0,
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
    input gnt,
	output [`AXI_DATA_BITS-1:0] WDATA,
	output [`AXI_STRB_BITS-1:0] WSTRB,
	output WLAST,
	output WVALID, 
);
    

    always_comb begin

        case (gnt)

            1'b0:begin
                WDATA = WDATA_M0;
                WSTRB = WSTRB_M0;
                WLAST = WLAST_M0;
                WVALID = WVALID_M0;
            end
            
            1'b1:begin
                WDATA = WDATA_M1;
                WSTRB = WSTRB_M1;
                WLAST = WLAST_M1;
                WVALID = WVALID_M1;
            end

        endcase

    end
endmodule