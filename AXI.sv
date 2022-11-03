//================================================
// Auther:      Yang Chun-Wen (Willie)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//================================================
`include "AXI_define.svh"
`include "AW_mux.sv"
`include "AR_mux.sv"
`include "AW_decoder.sv"
`include "AR_decoder.sv"
`include "W_mux.sv"
`include "R_mux.sv"
`include "RRarbiter.sv"

module AXI(

	input ACLK,
	input ARESETn,
	input [1:0] REQUEST,
	output [1:0] cpu_gnt,

	//SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic  AWREADY_M1,
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic  WREADY_M1,
	//WRITE RESPONSE
	output logic  [`AXI_ID_BITS-1:0] BID_M1,
	output logic  [1:0] BRESP_M1,
	output logic  BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic  ARREADY_M0,
	//READ DATA0
	output logic  [`AXI_ID_BITS-1:0] RID_M0,
	output logic  [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic  [1:0] RRESP_M0,
	output logic  RLAST_M0,
	output logic  RVALID_M0,
	input RREADY_M0,
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic  ARREADY_M1,
	//READ DATA1
	output logic  [`AXI_ID_BITS-1:0] RID_M1,
	output logic  [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic  [1:0] RRESP_M1,
	output logic  RLAST_M1,
	output logic  RVALID_M1,
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
	output logic  [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic  [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic  [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic  [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic  [1:0] AWBURST_S1,
	output logic  AWVALID_S1,
	input AWREADY_S1,
	//WRITE DATA1
	output logic  [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic  [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic  WLAST_S1,
	output logic  WVALID_S1,
	input WREADY_S1,
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic  BREADY_S1,
	
	//READ ADDRESS0
	output logic  [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic  [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic  [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic  [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic  [1:0] ARBURST_S0,
	output logic  ARVALID_S0,
	input ARREADY_S0,
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic  RREADY_S0,
	//READ ADDRESS1
	output logic  [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic  [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic  [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic  [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic  [1:0] ARBURST_S1,
	output logic  ARVALID_S1,
	input ARREADY_S1,
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic  RREADY_S1 
	
);
    //---------- you should put your design here ----------//

// arbiter
	logic [1:0] line_grant; 
	RR_ARBITER arbiter(
		.clk(ACLK),
		.rst(ARESETn),
		// .BRESP(line_BRESP), //根據ID給回覆
		// .RRESP(line_RRESP), //根據ID給回覆
		.BVALID_S0(BVALID_S0), 
		.BVALID_S1(BVALID_S1),
		.BREADY_M1(BREADY_M1),
    	.RVALID_S0(RVALID_S0),
		.RVALID_S1(RVALID_S1),
		.RREADY_M1(RREADY_M1),
		.RREADY_M0(RREADY_M0),
		.req(REQUEST),
		.gnt(line_grant)
	);
	assign cpu_gnt = line_grant;

// AW 
	logic [`AXI_ID_BITS-1:0] AWID_mux2dec;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_mux2dec;
	logic [`AXI_LEN_BITS-1:0] AWLEN_mux2dec;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_mux2dec;
	logic [1:0] AWBURST_mux2dec;
	logic AWVALID_mux2dec;
    AW_mux Aw_mux(
        // .AWID_M0(AWID_M0),
        // .AWADDR_M0(AWADDR_M0),
        // .AWLEN_M0(AWLEN_M0),
        // .AWSIZE_M0(AWSIZE_M0),
        // .AWBURST_M0(AWBURST_M0),
        // .AWVALID_M0(AWVALID_M0),
        .AWID_M1(AWID_M1),
        .AWADDR_M1(AWADDR_M1),
        .AWLEN_M1(AWLEN_M1),
        .AWSIZE_M1(AWSIZE_M1),
        .AWBURST_M1(AWBURST_M1),
        .AWVALID_M1(AWVALID_M1),
        .gnt(line_grant), // from arbiter
        .AWID(AWID_mux2dec), // to decoder
        .AWADDR(AWADDR_mux2dec),
        .AWLEN(AWLEN_mux2dec),
        .AWSIZE(AWSIZE_mux2dec),
        .AWBURST(AWBURST_mux2dec),
        .AWVALID(AWVALID_mux2dec)
    );
    AW_decoder AW_decoder(
        .AWID(AWID_mux2dec), 
        .AWADDR(AWADDR_mux2dec),
        .AWLEN(AWLEN_mux2dec),
        .AWSIZE(AWSIZE_mux2dec),
        .AWBURST(AWBURST_mux2dec),
        .AWVALID(AWVALID_mux2dec),
        .AWID_S0(AWID_S0),
        .AWADDR_S0(AWADDR_S0),
        .AWLEN_S0(AWLEN_S0),
        .AWSIZE_S0(AWSIZE_S0),
        .AWBURST_S0(AWBURST_S0),
        .AWVALID_S0(AWVALID_S0),
        .AWID_S1(AWID_S1),
        .AWADDR_S1(AWADDR_S1),
        .AWLEN_S1(AWLEN_S1),
        .AWSIZE_S1(AWSIZE_S1),
        .AWBURST_S1(AWBURST_S1),
        .AWVALID_S1(AWVALID_S1)
    );
//AR
    logic [`AXI_ID_BITS-1:0] ARID_mux2dec;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_mux2dec;
	logic [`AXI_LEN_BITS-1:0] ARLEN_mux2dec;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_mux2dec;
	logic [1:0] ARBURST_mux2dec;
	logic ARVALID_mux2dec;
    AR_mux Ar_mux(
        .ARID_M0(ARID_M0),
        .ARADDR_M0(ARADDR_M0),
        .ARLEN_M0(ARLEN_M0),
        .ARSIZE_M0(ARSIZE_M0),
        .ARBURST_M0(ARBURST_M0),
        .ARVALID_M0(ARVALID_M0),
        .ARID_M1(ARID_M1),
        .ARADDR_M1(ARADDR_M1),
        .ARLEN_M1(ARLEN_M1),
        .ARSIZE_M1(ARSIZE_M1),
        .ARBURST_M1(ARBURST_M1),
        .ARVALID_M1(ARVALID_M1),
        .gnt(line_grant), // from arbiter
        .ARID(ARID_mux2dec), // to decoder
        .ARADDR(ARADDR_mux2dec),
        .ARLEN(ARLEN_mux2dec),
        .ARSIZE(ARSIZE_mux2dec),
        .ARBURST(ARBURST_mux2dec),
        .ARVALID(ARVALID_mux2dec)
    );
    AR_decoder Ar_decoder(
        .ARID(ARID_mux2dec), 
        .ARADDR(ARADDR_mux2dec),
        .ARLEN(ARLEN_mux2dec),
        .ARSIZE(ARSIZE_mux2dec),
        .ARBURST(ARBURST_mux2dec),
        .ARVALID(ARVALID_mux2dec),
        .ARID_S0(ARID_S0),
        .ARADDR_S0(ARADDR_S0),
        .ARLEN_S0(ARLEN_S0),
        .ARSIZE_S0(ARSIZE_S0),
        .ARBURST_S0(ARBURST_S0),
        .ARVALID_S0(ARVALID_S0),
        .ARID_S1(ARID_S1),
        .ARADDR_S1(ARADDR_S1),
        .ARLEN_S1(ARLEN_S1),
        .ARSIZE_S1(ARSIZE_S1),
        .ARBURST_S1(ARBURST_S1),
        .ARVALID_S1(ARVALID_S1)
    );

// Write Data
    W_mux W_mux_S0(
        .WDATA_M0(WDATA_M0),
        .WSTRB_M0(WSTRB_M0),
        .WLAST_M0(WLAST_M0),
        .WVALID_M0(WVALID_M0),
        .WDATA_M1(WDATA_M1),
        .WSTRB_M1(WSTRB_M1),
        .WLAST_M1(WLAST_M1),
        .WVALID_M1(WVALID_M1),
        .gnt(line_grant), // from arbiter
        .WDATA(WDATA_S0),// to Slave 0
        .WSTRB(WSTRB_S0),
        .WLAST(WLAST_S0),
        .WVALID(WVALID_S0)
    );

    W_mux W_mux_S1(
        .WDATA_M0(WDATA_M0),
        .WSTRB_M0(WSTRB_M0),
        .WLAST_M0(WLAST_M0),
        .WVALID_M0(WVALID_M0),
        .WDATA_M1(WDATA_M1),
        .WSTRB_M1(WSTRB_M1),
        .WLAST_M1(WLAST_M1),
        .WVALID_M1(WVALID_M1),
        .gnt(line_grant), // from arbiter
        .WDATA(WDATA_S1),// to Slave 1
        .WSTRB(WSTRB_S1),
        .WLAST(WLAST_S1),
        .WVALID(WVALID_S1)
    );


	R_mux R_mux_M0(
		.RID_S1(RID_S1),
		.RDATA_S1(RDATA_S1),
		.RRESP_S1(RRESP_S1),
		.RLAST_S1(RLAST_S1),
		.RVALID_S1(RVALID_S1),
		.RID_S0(RID_S0),
		.RDATA_S0(RDATA_S0),
		.RRESP_S0(RRESP_S0),
		.RLAST_S0(RLAST_S0),
		.RVALID_S0(RVALID_S0),
		.RID(RID_M0),
		.RDATA(RDATA_M0),
		.RRESP(RRESP_M0),
		.RLAST(RLAST_M0),
		.RVALID(RVALID_M0)
	);

	R_mux R_mux_M1(
		.RID_S1(RID_S1),
		.RDATA_S1(RDATA_S1),
		.RRESP_S1(RRESP_S1),
		.RLAST_S1(RLAST_S1),
		.RVALID_S1(RVALID_S1),
		.RID_S0(RID_S0),
		.RDATA_S0(RDATA_S0),
		.RRESP_S0(RRESP_S0),
		.RLAST_S0(RLAST_S0),
		.RVALID_S0(RVALID_S0),
		.RID(RID_M1),
		.RDATA(RDATA_M1),
		.RRESP(RRESP_M1),
		.RLAST(RLAST_M1),
		.RVALID(RVALID_M1)
	);

	 
	
// BRESP

// RRESP_S1 還沒加上去
// RRESP_S0
// RRESP_M1
// RRESP_M0
always_comb begin //accroding to AWID determine the ready signal pass to whom
	unique if(AWID_S1[7:4] == 4'b0001 && AWVALID_S1 == 1) begin
		AWREADY_M1 = AWREADY_S1; // 若ID前4碼為1且S1有收到VALID
		// BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (AWID_S0[7:4] == 4'b0001 && AWVALID_S0 == 1 ) begin
		AWREADY_M1 = AWREADY_S0; // 若ID前4碼為1且S0有收到VALID
		// BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end

	else ;
end
 
always_comb begin //accroding to AWID determine the ready signal pass to whom
	unique if(AWID_S1[7:4] == 4'b0001 && WVALID_S1) begin
		WREADY_M1 = WREADY_S1; // 若ID前4碼為1且S1有收到VALID
		//BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (AWID_S0[7:4] == 4'b0001 && WVALID_S1) begin
		WREADY_M1 = WREADY_S0; // 若ID前4碼為1且S0有收到VALID
		//BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else ;
end

always_comb begin //accroding to BID determine the response signal pass to whom
	unique if(BID_S1[7:4] == 4'b0001 && BVALID_S1 == 1 ) begin
		BRESP_M1 = BRESP_S1; // 若ID前4碼為1且S1有收到VALID
		// BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		//line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (BID_S0[7:4] == 4'b0001 && BVALID_S0 == 1 ) begin
		BRESP_M1 = BRESP_S0; // 若ID前4碼為1且S0有收到VALID
		// BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		//line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end

	else ;
end

//M0 沒有WRITE PORT

always_comb begin //accroding to AWID determine the ready signal pass to whom
	unique if(ARID_S1[7:4] == 4'b0001 && ARVALID_S1 == 1) begin
		ARREADY_M1 = ARREADY_S1; // 若ID前4碼為1且S1有收到VALID
		// BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (ARID_S0[7:4] == 4'b0001 && ARVALID_S0 == 1 ) begin
		ARREADY_M1 = ARREADY_S0; // 若ID前4碼為1且S0有收到VALID
		// BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if(ARID_S1[7:4] == 4'b0000 && ARVALID_S1 == 1) begin
		ARREADY_M0 = ARREADY_S1; // 若ID前4碼為1且S1有收到VALID
		// BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (ARID_S0[7:4] == 4'b0000 && ARVALID_S0 == 1 ) begin
		ARREADY_M0 = ARREADY_S0; // 若ID前4碼為1且S0有收到VALID
		// BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else ;
end

always_comb begin //accroding to AWID determine the ready signal pass to whom
	unique if(RID_S1[7:4] == 4'b0001 && RVALID_S1 == 1) begin
		RREADY_S1 = RREADY_M1; // 若ID前4碼為1且S1有收到VALID
		//BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (RID_S0[7:4] == 4'b0001 && RVALID_S0 == 1) begin
		RREADY_S0 = RREADY_M1; // 若ID前4碼為1且S0有收到VALID
		//BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if(RID_S1[7:4] == 4'b0000 && RVALID_S1 == 1) begin
		RREADY_S1 = RREADY_M0; // 若ID前4碼為1且S1有收到VALID
		//BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (RID_S0[7:4] == 4'b0000 && RVALID_S0 == 1) begin
		RREADY_S0 = RREADY_M0; // 若ID前4碼為1且S0有收到VALID
		//BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end


	else ;
end

always_comb begin //accroding to AWID determine the ready signal pass to whom
	unique if(RID_S1[7:4] == 4'b0001 && RVALID_S1 == 1) begin
		RREADY_S1 = RREADY_M1; // 若ID前4碼為1且S1有收到VALID
		RRESP_M1 = RRESP_S1;
		//BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (RID_S0[7:4] == 4'b0001 && RVALID_S0 == 1) begin
		RREADY_S0 = RREADY_M1; // 若ID前4碼為1且S0有收到VALID
		RRESP_M1 = RRESP_S0;
		//BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if(RID_S1[7:4] == 4'b0000 && RVALID_S1 == 1) begin
		RREADY_S1 = RREADY_M0; // 若ID前4碼為1且S1有收到VALID
		RRESP_M0 = RRESP_S1;
		//BRESP_M1 = BRESP_S1; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S1; //同時將此RESP拉回去arbiter 解除arbiter disable
	end
	else if (RID_S0[7:4] == 4'b0000 && RVALID_S0 == 1) begin
		RREADY_S0 = RREADY_M0; // 若ID前4碼為1且S0有收到VALID
		RRESP_M0 = RRESP_S0;
		//BRESP_M1 = BRESP_S0; //WRITE response 要assign 給相應的master
		// line_BRESP = BRESP_S0; //同時將此RESP拉回去arbiter 解除arbiter disable
	end

	else ;
end
    
	
endmodule