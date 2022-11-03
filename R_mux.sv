module R_mux (
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic  [`AXI_ID_BITS-1:0] RID,
	output logic  [`AXI_DATA_BITS-1:0] RDATA,
	output logic  [1:0] RRESP,
	output logic  RLAST,
	output logic  RVALID
);
    

    always_comb begin

        if(RVALID_S1 == 1) begin
            RID = RID_S1[3:0];
	        RDATA = RDATA_S1;
            RRESP= RRESP_S1;
            RLAST= RLAST_S1;
            RVALID = RVALID_S1;
        end
        else if(RVALID_S0 == 1) begin
            RID = RID_S0[3:0];
	        RDATA = RDATA_S0;
            RRESP= RRESP_S0;
            RLAST= RLAST_S0;
            RVALID = RVALID_S0;
        end
        else begin
			RID = 0;
	        RDATA = 0;
            RRESP= 0;
            RLAST= 0;
            RVALID = 0;
		end

    end
    
endmodule