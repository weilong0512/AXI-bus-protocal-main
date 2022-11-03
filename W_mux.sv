module W_mux (
	// input [`AXI_DATA_BITS-1:0] WDATA_M0,
	// input [`AXI_STRB_BITS-1:0] WSTRB_M0,
	// input WLAST_M0,
	// input WVALID_M0,
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
    input gnt,
	output logic  [`AXI_DATA_BITS-1:0] WDATA,
	output logic  [`AXI_STRB_BITS-1:0] WSTRB,
	output logic  WLAST,
	output logic  WVALID
);
    

    always_comb begin

        case (gnt)

            1'b0:begin
                WDATA = 0;
                WSTRB = 0;
                WLAST = 0;
                WVALID = 0;
            end
            
            1'b1:begin
                WDATA = WDATA_M1;
                WSTRB = WSTRB_M1;
                WLAST = WLAST_M1;
                WVALID = WVALID_M1;
            end

            default:;

        endcase

    end
    
endmodule
