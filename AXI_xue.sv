//================================================
// Auther:      Chen Tsung-Chi (Michael)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//================================================
`include "AXI_define.svh"

module AXI(

	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output AWREADY_M1,
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output WREADY_M1,
	//WRITE RESPONSE
	output [`AXI_ID_BITS-1:0] BID_M1,
	output [1:0] BRESP_M1,
	output BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output ARREADY_M0,
	//READ DATA0
	output [`AXI_ID_BITS-1:0] RID_M0,
	output [`AXI_DATA_BITS-1:0] RDATA_M0,
	output [1:0] RRESP_M0,
	output RLAST_M0,
	output RVALID_M0,
	input RREADY_M0,
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output ARREADY_M1,
	//READ DATA1
	output [`AXI_ID_BITS-1:0] RID_M1,
	output [`AXI_DATA_BITS-1:0] RDATA_M1,
	output [1:0] RRESP_M1,
	output RLAST_M1,
	output RVALID_M1,
	input RREADY_M1,

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	output [`AXI_IDS_BITS-1:0] AWID_S0,
	output [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output [1:0] AWBURST_S0,
	output AWVALID_S0,
	input AWREADY_S0,
	//WRITE DATA0
	output [`AXI_DATA_BITS-1:0] WDATA_S0,
	output [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output WLAST_S0,
	output WVALID_S0,
	input WREADY_S0,
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output BREADY_S0,
	
	//WRITE ADDRESS1
	output [`AXI_IDS_BITS-1:0] AWID_S1,
	output [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output [1:0] AWBURST_S1,
	output AWVALID_S1,
	input AWREADY_S1,
	//WRITE DATA1
	output [`AXI_DATA_BITS-1:0] WDATA_S1,
	output [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output WLAST_S1,
	output WVALID_S1,
	input WREADY_S1,
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output BREADY_S1,
	
	//READ ADDRESS0
	output [`AXI_IDS_BITS-1:0] ARID_S0,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output [1:0] ARBURST_S0,
	output ARVALID_S0,
	input ARREADY_S0,
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output RREADY_S0,
	//READ ADDRESS1
	output [`AXI_IDS_BITS-1:0] ARID_S1,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output [1:0] ARBURST_S1,
	output ARVALID_S1,
	input ARREADY_S1,
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output RREADY_S1
	
);
    //---------- you should put your design here ----------//

	////////////////// Declaration //////////////////
	wire [`BL_AR_info-1:0] AR_info_M0, AR_info_M1, AR_info_BUS_M;
	wire [`BL_R_info-1:0] R_info_S0, R_info_S1, R_info_BUS_S;
	wire AR_ready_BUS_S, R_ready_BUS_M, tmp_ARREADY;
	wire [`BL_R_err_out-1:0] R_info_err;
        wire [`BL_R_err_out-1:0] mux_R_err_out;


	wire [`BL_AW_info-1:0] AW_info_M1, AW_info_BUS_M;
	wire [`BL_W_info-1:0] W_info_M1, W_info_BUS_M;
	wire [`BL_B_info-1:0] B_info_S0, B_info_S1, B_info_BUS_S;
	wire AW_ready_BUS_S, W_ready_BUS_S, B_ready_BUS_M;
	wire [`BL_B_info_err-1:0] B_info_err, B_info_input;


	wire prior_AR, prior_R;
	wire mux_R_M_sel;
	wire AR_M_both_valid, R_S_both_valid;
	wire handle_err_R;
	wire is_err_last_R;
	wire is_terminal_R;
	wire d_AR_S, d_AR_M, d_R_M, d_R_S;


	wire is_terminal_W, is_terminal_B;
	wire has_AW, has_W;
	wire m_sel_AW_ready, m_sel_W_ready, prior_B;
	wire d_AW_S, d_W_S, d_B_S;


	logic stall_AR;
	logic last_prior_AR;
	logic pending_err_AR;
	logic [`BL_AR_info_reg-1:0] AR_info_reg;
	logic is_done_AR;

	logic stall_R;
	logic last_prior_R;
	logic [`AXI_LEN_BITS-1:0] err_counter_R;

	logic stall_AW;
	logic [`BL_AW_info_reg-1:0] AW_info_reg;
	logic pending_err_AW;
	logic is_done_AW, is_done_W;

	assign	AR_info_M0 	= {ARVALID_M0, 4'd0, ARID_M0, ARADDR_M0, ARLEN_M0, ARSIZE_M0, ARBURST_M0};
	assign	AR_info_M1 	= {ARVALID_M1, 4'd1, ARID_M1, ARADDR_M1, ARLEN_M1, ARSIZE_M1, ARBURST_M1};

	assign	R_info_S0	= {RVALID_S0, RID_S0, RDATA_S0, RRESP_S0, RLAST_S0, 1'b0};
	assign	R_info_S1	= {RVALID_S1, RID_S1, RDATA_S1, RRESP_S1, RLAST_S1, 1'b1};
	
    ///////// Data Path /////////
	// AR Channel
	// M REQ AR {VALID + ID + ADDR + LEN + SIZE + BURST}
	assign AR_info_BUS_M = (prior_AR) ? AR_info_M1 : AR_info_M0;

	// S RES AR {ARREADY}
	assign AR_ready_BUS_S = (AR_info_BUS_M[`BP_AR_info_S]) ? ARREADY_S1 : ARREADY_S0;


	// R Channel
	// S Push Data R {VALID + IDS + DATA + RESP + LAST + Slave_number}

    assign R_info_BUS_S = (prior_R) ? R_info_S1 : R_info_S0;

	// R_info_err {VALID + ID + DATA + RESP + LAST}
	assign R_info_err = {1'b1, AR_info_reg[`BP_AR_info_reg_ID], `AXI_DATA_BITS'd0, `AXI_RESP_DECERR, is_err_last_R};
    assign mux_R_err_out = (handle_err_R) ? R_info_err : {R_info_BUS_S[`BP_R_info_valid], R_info_BUS_S[`BP_R_info_ID2tail]};

	// M RES R {RREADY}
	assign mux_R_M_sel = (handle_err_R) ? AR_info_reg[`BP_AR_info_reg_M] : R_info_BUS_S[`BP_R_info_M];
    assign R_ready_BUS_M = (mux_R_M_sel) ? RREADY_M1 : RREADY_M0;

	//// Arbiter + err handler////
	
	// AR
	assign  AR_M_both_valid = ARVALID_M0 & ARVALID_M1;
	assign	prior_AR =	(stall_AR) ? last_prior_AR : 
						(AR_M_both_valid) ? ~last_prior_AR :
						(ARVALID_M0) ? 1'b0 : 1'b1;

	// AR : stall_AR
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			stall_AR <= 1'b0;
		end
		else if (~stall_AR & AR_info_BUS_M[`BP_AR_info_valid]) begin
			stall_AR <= 1'b1;
		end
		else if (is_terminal_R) begin
			stall_AR <= 1'b0;
		end
		else begin
			stall_AR <= stall_AR;
		end
    end

	// AR : last_prior_AR
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			last_prior_AR <= 1'b1;
		end
		else if (~stall_AR & AR_info_BUS_M[`BP_AR_info_valid]) begin
			last_prior_AR <= prior_AR;
		end
		else begin
			last_prior_AR <= last_prior_AR;
		end
	end
	
	// AR : pending_err_AR
	assign	err_AR = AR_info_BUS_M[`BP_AR_info_valid] & (AR_info_BUS_M[`BP_AR_info_ERRADDR] != `BL_AR_info_ERRADDR'd0);
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			pending_err_AR <= 1'b0;
			AR_info_reg <= `BL_AR_info_reg'd0;
		end
		else if (~stall_AR & err_AR) begin
			pending_err_AR <= 1'b1;
			AR_info_reg <= {AR_info_BUS_M[`BP_AR_info_IDS], AR_info_BUS_M[`BP_AR_info_LEN]};
		end
		else if (handle_err_R & is_terminal_R) begin
			pending_err_AR <= 1'b0;
			AR_info_reg <= `BL_AR_info_reg'd0;
		end
		else begin
			pending_err_AR <= pending_err_AR;
			AR_info_reg <= AR_info_reg;
		end
	end

	// R : stall_R / last_prior_R
	assign	handle_err_R = ~stall_R & pending_err_AR;
	assign  R_S_both_valid = RVALID_S0 & RVALID_S1;
	assign	prior_R =	(stall_R | pending_err_AR) ? last_prior_R :
						(R_S_both_valid) ? ~last_prior_R :
						(RVALID_S0) ? 1'b0 : 1'b1;
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			stall_R <= 1'b0;
			last_prior_R <= 1'b1;
		end
		else if (handle_err_R) begin
			stall_R <= stall_R;
			last_prior_R <= last_prior_R;
		end
		else if (R_info_BUS_S[`BP_R_info_valid]) begin
			last_prior_R <= prior_R;
			if (is_terminal_R) begin   ////////////  is there can be read data inteleving between different transaction ? (R_ready_BUS_M)
				stall_R <= 1'b0;
			end
			else begin
				stall_R <= 1'b1;
			end
		end
		else begin
			stall_R <= stall_R;
			last_prior_R <= last_prior_R;
		end
	end

	// R : err_count_R
	assign  is_err_last_R = (err_counter_R == AR_info_reg[`BP_AR_info_reg_LEN]) ? 1'b1 : 1'b0;
	assign  is_terminal_R =	mux_R_err_out[`BP_R_err_out_valid] & mux_R_err_out[`BP_R_err_out_LAST] & R_ready_BUS_M;
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			err_counter_R <= `AXI_LEN_BITS'd0;
		end
		else if (handle_err_R) begin
			if (is_terminal_R) begin
				err_counter_R <= `AXI_LEN_BITS'd0;
			end
			else if (R_ready_BUS_M) begin
				err_counter_R <= err_counter_R + `AXI_LEN_BITS'd1;
			end
			else begin
				err_counter_R <= err_counter_R;
			end
		end
		else begin
			err_counter_R <= `AXI_LEN_BITS'd0;
		end
	end



	// AR : is_done_AR
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			is_done_AR <= 1'b0;
		end
		else if (stall_AR & is_terminal_R) begin
			is_done_AR <= 1'b0;
		end
		else if (stall_AR & AR_ready_BUS_S) begin
			is_done_AR <= 1'b1;
		end
		else if (~stall_AR & AR_info_BUS_M[`BP_AR_info_valid] & tmp_ARREADY) begin
			is_done_AR <= 1'b1;
		end
		else begin
			is_done_AR <= is_done_AR;
		end
	end
	
	


	//// Decoder ////
	// AR REQ to S
	assign d_AR_S = AR_info_BUS_M[`BP_AR_info_S];

	assign {ARVALID_S0, ARID_S0, ARADDR_S0, ARLEN_S0, ARSIZE_S0, ARBURST_S0} = (is_done_AR | err_AR | d_AR_S)  ? `BL_AR_info'd0 : AR_info_BUS_M;
	assign {ARVALID_S1, ARID_S1, ARADDR_S1, ARLEN_S1, ARSIZE_S1, ARBURST_S1} = (is_done_AR | err_AR | ~d_AR_S) ? `BL_AR_info'd0 : AR_info_BUS_M;

	// AR RES to M
	assign d_AR_M = AR_info_BUS_M[`BP_AR_info_M];
	assign tmp_ARREADY = (err_AR) ? 1'b1 : AR_ready_BUS_S;

	assign ARREADY_M0 = (is_done_AR | d_AR_M)  ? 1'd0 : tmp_ARREADY;
	assign ARREADY_M1 = (is_done_AR | ~d_AR_M) ? 1'd0 : tmp_ARREADY;

	// R Data to M
	assign d_R_M = mux_R_M_sel;

	assign {RVALID_M0, RID_M0, RDATA_M0, RRESP_M0, RLAST_M0} = (d_R_M)  ? `BL_R_err_out'd0 : mux_R_err_out;
	assign {RVALID_M1, RID_M1, RDATA_M1, RRESP_M1, RLAST_M1} = (~d_R_M) ? `BL_R_err_out'd0 : mux_R_err_out;
        

	// R RES to S
	assign d_R_S = R_info_BUS_S[`BP_R_info_S];

	assign RREADY_S0 = (handle_err_R | d_R_S)  ? 1'd0 : R_ready_BUS_M;
	assign RREADY_S1 = (handle_err_R | ~d_R_S) ? 1'd0 : R_ready_BUS_M;









	assign is_terminal_W = W_info_BUS_M[`BP_W_info_valid] & W_info_BUS_M[`BP_W_info_LAST] & WREADY_M1;
	assign is_terminal_B = BVALID_M1 & B_ready_BUS_M;

	assign has_AW = AW_info_BUS_M[`BP_AW_info_valid];
    assign has_W  = W_info_BUS_M[`BP_W_info_valid];

	// AW : stall_AW / AW_info_reg
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			stall_AW <= 1'b0;
			AW_info_reg <= `BL_AW_info_reg'd0;
		end
		else if (stall_AW & is_terminal_B) begin
			stall_AW <= 1'b0;
			AW_info_reg <= `BL_AW_info_reg'd0;
		end
		else if (~stall_AW & has_AW) begin
			stall_AW <= 1'b1;
			AW_info_reg <= {AW_info_BUS_M[`BP_AW_info_IDS], AW_info_BUS_M[`BP_AW_info_S]};
		end
		else begin
			stall_AW <= stall_AW;
			AW_info_reg <= AW_info_reg;
		end
	end

	// AW : pending_err_AW
	assign err_AW = AW_info_BUS_M[`BP_AW_info_valid] & (AW_info_BUS_M[`BP_AW_info_ERRADDR] != `BL_AW_info_ERRADDR'd0);
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			pending_err_AW <= 1'b0;
		end
                else if (stall_AW & is_terminal_B) begin
			pending_err_AW <= 1'b0;
		end
		else if (~stall_AW & err_AW) begin
			pending_err_AW <= 1'b1;
		end
		else begin
			pending_err_AW <= pending_err_AW;
		end
	end

	// AW : is_done_AW
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			is_done_AW <= 1'b0;
		end
		else if (stall_AW & is_terminal_B) begin
			is_done_AW <= 1'b0;
		end
		else if (stall_AW & AW_ready_BUS_S) begin
			is_done_AW <= 1'b1;
		end
		else if (~stall_AW & has_AW & AWREADY_M1) begin
			is_done_AW <= 1'b1;
		end
		else begin
			is_done_AW <= is_done_AW;
		end
	end
	// W : is_done_W
	always_ff @ (posedge ACLK or negedge ARESETn) begin
		if (~ARESETn) begin
			is_done_W <= 1'b0;
		end
		else if (stall_AW & is_terminal_B) begin
			is_done_W <= 1'b0;
		end
		else if (stall_AW & is_terminal_W) begin
			is_done_W <= 1'b1;
		end
		else begin
			is_done_W <= is_done_W;
		end
	end


	assign m_sel_AW_ready	= (stall_AW) ? AW_info_reg[`BP_AW_info_reg_S] : AW_info_BUS_M[`BP_AW_info_S];
	assign m_sel_W_ready	= (stall_AW) ? AW_info_reg[`BP_AW_info_reg_S] : AW_info_BUS_M[`BP_AW_info_S];
	assign prior_B			= (stall_AW) ? AW_info_reg[`BP_AW_info_reg_S] : AW_info_BUS_M[`BP_AW_info_S];


	assign AW_info_M1		= {AWVALID_M1, 4'd1, AWID_M1, AWADDR_M1, AWLEN_M1, AWSIZE_M1, AWBURST_M1};
	assign W_info_M1		= {WVALID_M1, WDATA_M1, WSTRB_M1, WLAST_M1};

	assign B_info_S0		= {BVALID_S0, BID_S0, BRESP_S0};
	assign B_info_S1		= {BVALID_S1, BID_S1, BRESP_S1};


	assign AW_info_BUS_M 	= AW_info_M1;
	assign W_info_BUS_M 	= W_info_M1;
	assign B_ready_BUS_M 	= BREADY_M1;


	assign AW_ready_BUS_S 	= (m_sel_AW_ready) ? AWREADY_S1 : AWREADY_S0;
	assign W_ready_BUS_S 	= (m_sel_W_ready) ? WREADY_S1 : WREADY_S0;
	assign B_info_BUS_S 	= (prior_B) ? B_info_S1 : B_info_S0;


	assign AWREADY_M1		= 	(is_done_AW) ? 1'b0 : 
								(stall_AW) ? AW_ready_BUS_S :
                                (err_AW) ? 1'b1 : AW_ready_BUS_S;

	assign WREADY_M1		= 	(is_done_W) ? 1'b0 : (has_W) ? (
                                                (pending_err_AW) ? 1'b1 :
                                                (stall_AW) ? W_ready_BUS_S :
                                                (err_AW) ? 1'b1 :
                                                (has_AW) ? W_ready_BUS_S :1'b0) : 1'b0;


	assign B_info_err		= 	{1'b1, AW_info_reg[`BP_AW_info_reg_ID], `AXI_RESP_DECERR};
	assign B_info_input 	= 	{B_info_BUS_S[`BP_B_info_valid], B_info_BUS_S[`BP_B_info_ID2tail]};
	assign {BVALID_M1, BID_M1, BRESP_M1}	= 	(is_done_AW & is_done_W & pending_err_AW) ? B_info_err : (is_done_AW & is_done_W) ? B_info_input : `BL_B_info_err'd0;


	assign d_AW_S = m_sel_AW_ready;
    assign {AWVALID_S0, AWID_S0, AWADDR_S0, AWLEN_S0, AWSIZE_S0, AWBURST_S0} = (is_done_AW | err_AW | d_AW_S)  ? `BL_AW_info'd0 : AW_info_BUS_M;
    assign {AWVALID_S1, AWID_S1, AWADDR_S1, AWLEN_S1, AWSIZE_S1, AWBURST_S1} = (is_done_AW | err_AW | ~d_AW_S) ? `BL_AW_info'd0 : AW_info_BUS_M;


	assign d_W_S = m_sel_W_ready;
    assign {WVALID_S0, WDATA_S0, WSTRB_S0, WLAST_S0} = (is_done_W | pending_err_AW | err_AW | d_W_S)  ? `BL_W_info'd0 : W_info_BUS_M;
    assign {WVALID_S1, WDATA_S1, WSTRB_S1, WLAST_S1} = (is_done_W | pending_err_AW | err_AW | ~d_W_S) ? `BL_W_info'd0 : W_info_BUS_M;

	assign d_B_S = prior_B;
	assign BREADY_S0 = (pending_err_AW | err_AW | d_B_S)  ? 1'd0 : B_ready_BUS_M;
	assign BREADY_S1 = (pending_err_AW | err_AW | ~d_B_S) ? 1'd0 : B_ready_BUS_M;


endmodule
