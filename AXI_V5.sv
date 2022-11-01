//================================================
// Auther:      Yang Chun-Wen (Willie)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//=================================================
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
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,
	
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
	output logic RREADY_S1 
	
);
	//logic [1:0] REQUEST_reg_d, REQUEST_reg_q;

	//SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	logic AWREADY_M1_reg_d, AWREADY_M1_reg_q;
	//WRITE DATA
	// logic [`AXI_DATA_BITS-1:0] WDATA_M1_reg_d, WDATA_M1_reg_q;
	// logic [`AXI_STRB_BITS-1:0] WSTRB_M1_reg_d, WSTRB_M1_reg_q;
	// logic WLAST_M1_reg_d, WLAST_M1_reg_q;
	// logic WVALID_M1_reg_d, WVALID_M1_reg_q;
	logic WREADY_M1_reg_d, WREADY_M1_reg_q;
	//WRITE RESPONSE
	logic [`AXI_ID_BITS-1:0] BID_M1_reg_d, BID_M1_reg_q;
	logic [1:0] BRESP_M1_reg_d, BRESP_M1_reg_q;
	logic BVALID_M1_reg_d, BVALID_M1_reg_q;
	// logic BREADY_M1_reg_d, BREADY_M1_reg_q;

	//READ ADDRESS0
	// logic [`AXI_ID_BITS-1:0] ARID_M0_reg_d, ARID_M0_reg_q;
	// logic [`AXI_ADDR_BITS-1:0] ARADDR_M0_reg_d, ARADDR_M0_reg_q;
	// logic [`AXI_LEN_BITS-1:0] ARLEN_M0_reg_d, ARLEN_M0_reg_q;
	// logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0_reg_d, ARSIZE_M0_reg_q;
	// logic [1:0] ARBURST_M0_reg_d, ARBURST_M0_reg_q;
	// logic ARVALID_M0_reg_d, ARVALID_M0_reg_q;
	logic ARREADY_M0_reg_d, ARREADY_M0_reg_q;
	//READ DATA0
	logic [`AXI_ID_BITS-1:0] RID_M0_reg_d, RID_M0_reg_q;
	logic [`AXI_DATA_BITS-1:0] RDATA_M0_reg_d, RDATA_M0_reg_q;
	logic [1:0] RRESP_M0_reg_d, RRESP_M0_reg_q;
	logic RLAST_M0_reg_d, RLAST_M0_reg_q;
	logic RVALID_M0_reg_d, RVALID_M0_reg_q;
	logic RREADY_M0_reg_d, RREADY_M0_reg_q;
	//READ ADDRESS1
	logic [`AXI_ID_BITS-1:0] ARID_M1_reg_d, ARID_M1_reg_q;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_M1_reg_d, ARADDR_M1_reg_q;
	logic [`AXI_LEN_BITS-1:0] ARLEN_M1_reg_d, ARLEN_M1_reg_q;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1_reg_d, ARSIZE_M1_reg_q;
	logic [1:0] ARBURST_M1_reg_d, ARBURST_M1_reg_q;
	logic ARVALID_M1_reg_d, ARVALID_M1_reg_q;
	logic ARREADY_M1_reg_d, ARREADY_M1_reg_q;
	//READ DATA1
	logic [`AXI_ID_BITS-1:0] RID_M1_reg_d, RID_M1_reg_q;
	logic [`AXI_DATA_BITS-1:0] RDATA_M1_reg_d, RDATA_M1_reg_q;
	logic [1:0] RRESP_M1_reg_d, RRESP_M1_reg_q;
	logic RLAST_M1_reg_d, RLAST_M1_reg_q;
	logic RVALID_M1_reg_d, RVALID_M1_reg_q;
	logic RREADY_M1_reg_d, RREADY_M1_reg_q;

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	logic [`AXI_ID_BITS-1:0] AWID_S0_reg_d, AWID_S0_reg_q, AWID_S0_temp;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_S0_reg_d, AWADDR_S0_reg_q, AWADDR_S0_temp;
	logic [`AXI_LEN_BITS-1:0] AWLEN_S0_reg_d, AWLEN_S0_reg_q, AWLEN_S0_temp;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0_reg_d, AWSIZE_S0_reg_q, AWSIZE_S0_temp;
	logic [1:0] AWBURST_S0_reg_d, AWBURST_S0_reg_q, AWBURST_S0_temp;
	logic AWVALID_S0_reg_d, AWVALID_S0_reg_q, AWVALID_S0_temp;

	//WRITE DATA0
	logic [`AXI_DATA_BITS-1:0] WDATA_S0_reg_d, WDATA_S0_reg_q, WDATA_S0_temp;
	logic [`AXI_STRB_BITS-1:0] WSTRB_S0_reg_d, WSTRB_S0_reg_q, WSTRB_S0_temp;
	logic WLAST_S0_reg_d, WLAST_S0_reg_q, WLAST_S0_temp;
	logic WVALID_S0_reg_d, WVALID_S0_reg_q, WVALID_S0_temp;

	//WRITE RESPONSE0
	logic [`AXI_IDS_BITS-1:0] BID_S0_reg_d, BID_S0_reg_q, BID_S0_temp;
	logic [1:0] BRESP_S0_reg_d, BRESP_S0_reg_q, BRESP_S0_temp;
	logic BVALID_S0_reg_d, BVALID_S0_reg_q, BVALID_S0_temp;
	// logic BREADY_S0_reg_d, BREADY_S0_reg_q;
	
	//WRITE ADDRESS1
	logic [`AXI_ID_BITS-1:0] AWID_S1_reg_d, AWID_S1_reg_q, AWID_S1_temp;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_S1_reg_d, AWADDR_S1_reg_q, AWADDR_S1_temp;
	logic [`AXI_LEN_BITS-1:0] AWLEN_S1_reg_d, AWLEN_S1_reg_q, AWLEN_S1_temp;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1_reg_d, AWSIZE_S1_reg_q, AWSIZE_S1_temp;
	logic [1:0] AWBURST_S1_reg_d, AWBURST_S1_reg_q, AWBURST_S1_temp;
	logic AWVALID_S1_reg_d, AWVALID_S1_reg_q, AWVALID_S1_temp;

	//WRITE DATA1
	logic [`AXI_DATA_BITS-1:0] WDATA_S1_reg_d, WDATA_S1_reg_q, WDATA_S1_temp;
	logic [`AXI_STRB_BITS-1:0] WSTRB_S1_reg_d, WSTRB_S1_reg_q, WSTRB_S1_temp;
	logic WLAST_S1_reg_d, WLAST_S1_reg_q, WLAST_S1_temp;
	logic WVALID_S1_reg_d, WVALID_S1_reg_q, WVALID_S1_temp;

	//WRITE RESPONSE1
	// logic [`AXI_IDS_BITS-1:0] BID_S1_reg_d, BID_S1_reg_q, BID_S1_temp;
	// logic [1:0] BRESP_S1_reg_d, BRESP_S1_reg_q, BRESP_S1_temp;
	// logic BVALID_S1_reg_d, BVALID_S1_reg_q, BVALID_S1_temp;
	logic BREADY_S1_reg_d, BREADY_S1_reg_q;
	
	//READ ADDRESS0
	logic [`AXI_IDS_BITS-1:0] ARID_S0_reg_d, ARID_S0_reg_q;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_S0_reg_d, ARADDR_S0_reg_q;
	logic [`AXI_LEN_BITS-1:0] ARLEN_S0_reg_d, ARLEN_S0_reg_q;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0_reg_d, ARSIZE_S0_reg_q;
	logic [1:0] ARBURST_S0_reg_d, ARBURST_S0_reg_q;
	logic ARVALID_S0_reg_d, ARVALID_S0_reg_q;
	logic ARREADY_S0_reg_d, ARREADY_S0_reg_q;
	//READ DATA0
	logic [`AXI_IDS_BITS-1:0] RID_S0_reg_d, RID_S0_reg_q;
	logic [`AXI_DATA_BITS-1:0] RDATA_S0_reg_d, RDATA_S0_reg_q;
	logic [1:0] RRESP_S0_reg_d, RRESP_S0_reg_q;
	logic RLAST_S0_reg_d, RLAST_S0_reg_q;
	logic RVALID_S0_reg_d, RVALID_S0_reg_q;
	logic RREADY_S0_reg_d, RREADY_S0_reg_q;
	//READ ADDRESS1
	logic [`AXI_IDS_BITS-1:0] ARID_S1_reg_d, ARID_S1_reg_q;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_S1_reg_d, ARADDR_S1_reg_q;
	logic [`AXI_LEN_BITS-1:0] ARLEN_S1_reg_d, ARLEN_S1_reg_q;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1_reg_d, ARSIZE_S1_reg_q;
	logic [1:0] ARBURST_S1_reg_d, ARBURST_S1_reg_q;
	logic ARVALID_S1_reg_d, ARVALID_S1_reg_q;
	logic ARREADY_S1_reg_d, ARREADY_S1_reg_q;
	//READ DATA1
	logic [`AXI_IDS_BITS-1:0] RID_S1_reg_d, RID_S1_reg_q;
	logic [`AXI_DATA_BITS-1:0] RDATA_S1_reg_d, RDATA_S1_reg_q;
	logic [1:0] RRESP_S1_reg_d, RRESP_S1_reg_q;
	logic RLAST_S1_reg_d, RLAST_S1_reg_q;
	logic RVALID_S1_reg_d, RVALID_S1_reg_q;
	logic RREADY_S1_reg_d, RREADY_S1_reg_q;
    //---------- you should put your design here ----------//


// arbiter
	logic [1:0] line_grant; 
	RR_ARBITER arbiter(
		.clk(ACLK),
		.rst(ARESETn),
		// .BRESP(line_BRESP), //根據ID給回覆
		// .RRESP(line_RRESP), //根據ID給回覆
		.BVALID_S0(BVALID_S0_reg_q), 
		.BVALID_S1(BVALID_S1_reg_q),
		.BREADY_M1(BREADY_M1_reg_q),
    	.RVALID_S0(RVALID_S0_reg_q),
		.RVALID_S1(RVALID_S1_reg_q),
		.RREADY_M1(RREADY_M1_reg_q),
		.RREADY_M0(RREADY_M0_reg_q),
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
        .AWID_S0(AWID_S0_temp),
        .AWADDR_S0(AWADDR_S0_temp),
        .AWLEN_S0(AWLEN_S0_temp),
        .AWSIZE_S0(AWSIZE_S0_temp),
        .AWBURST_S0(AWBURST_S0_temp),
        .AWVALID_S0(AWVALID_S0_temp),
        .AWID_S1(AWID_S1_temp),
        .AWADDR_S1(AWADDR_S1_temp),
        .AWLEN_S1(AWLEN_S1_temp),
        .AWSIZE_S1(AWSIZE_S1_temp),
        .AWBURST_S1(AWBURST_S1_temp),
        .AWVALID_S1(AWVALID_S1_temp)
    );

    // assign BID_S0_temp = BID_S0;
    // assign BRESP_S0_temp = BRESP_S0;
    // assign BVALID_S0_temp = BVALID_S0;
    // assign BREADY_S0_reg_d = BREADY_M1;
    // assign BID_S1_temp = BID_S1;
    // assign BRESP_S1_temp = BRESP_S1;
    // assign BVALID_S1_temp = BVALID_S1;
    // assign BREADY_S1_reg_d = BREADY_M1;


// //AR
//     logic [`AXI_ID_BITS-1:0] ARID_mux2dec;
// 	logic [`AXI_ADDR_BITS-1:0] ARADDR_mux2dec;
// 	logic [`AXI_LEN_BITS-1:0] ARLEN_mux2dec;
// 	logic [`AXI_SIZE_BITS-1:0] ARSIZE_mux2dec;
// 	logic [1:0] ARBURST_mux2dec;
// 	logic ARVALID_mux2dec;
//     AR_mux Ar_mux(
//         .ARID_M0(ARID_M0_reg_q),
//         .ARADDR_M0(ARADDR_M0_reg_q),
//         .ARLEN_M0(ARLEN_M0_reg_q),
//         .ARSIZE_M0(ARSIZE_M0_reg_q),
//         .ARBURST_M0(ARBURST_M0_reg_q),
//         .ARVALID_M0(ARVALID_M0_reg_q),
//         .ARID_M1(ARID_M1_reg_q),
//         .ARADDR_M1(ARADDR_M1_reg_q),
//         .ARLEN_M1(ARLEN_M1_reg_q),
//         .ARSIZE_M1(ARSIZE_M1_reg_q),
//         .ARBURST_M1(ARBURST_M1_reg_q),
//         .ARVALID_M1(ARVALID_M1_reg_q),
//         .gnt(line_grant), // from arbiter
//         .ARID(ARID_mux2dec), // to decoder
//         .ARADDR(ARADDR_mux2dec),
//         .ARLEN(ARLEN_mux2dec),
//         .ARSIZE(ARSIZE_mux2dec),
//         .ARBURST(ARBURST_mux2dec),
//         .ARVALID(ARVALID_mux2dec)
//     );
//     AR_decoder AR_decoder(
//         .ARID(ARID_mux2dec), 
//         .ARADDR(ARADDR_mux2dec),
//         .ARLEN(ARLEN_mux2dec),
//         .ARSIZE(ARSIZE_mux2dec),
//         .ARBURST(ARBURST_mux2dec),
//         .ARVALID(ARVALID_mux2dec),
//         .ARID_S0(ARID_S0_reg_q),
//         .ARADDR_S0(ARADDR_S0_reg_q),
//         .ARLEN_S0(ARLEN_S0_reg_q),
//         .ARSIZE_S0(ARSIZE_S0_reg_q),
//         .ARBURST_S0(ARBURST_S0_reg_q),
//         .ARVALID_S0(ARVALID_S0_reg_q),
//         .ARID_S1(ARID_S1_reg_q),
//         .ARADDR_S1(ARADDR_S1_reg_q),
//         .ARLEN_S1(ARLEN_S1_reg_q),
//         .ARSIZE_S1(ARSIZE_S1_reg_q),
//         .ARBURST_S1(ARBURST_S1_reg_q),
//         .ARVALID_S1(ARVALID_S1_reg_q)
//     );

// Write Data
    W_mux W_mux_S0(
        // .WDATA_M0(WDATA_M0_reg_q),
        // .WSTRB_M0(WSTRB_M0_reg_q),
        // .WLAST_M0(WLAST_M0_reg_q),
        // .WVALID_M0(WVALID_M0_reg_q),
        .WDATA_M1(WDATA_M1),
        .WSTRB_M1(WSTRB_M1),
        .WLAST_M1(WLAST_M1),
        .WVALID_M1(WVALID_M1),
        .gnt(line_grant), // from arbiter
        .WDATA(WDATA_S0_temp),// to Slave 0
        .WSTRB(WSTRB_S0_temp),
        .WLAST(WLAST_S0_temp),
        .WVALID(WVALID_S0_temp)
    );

    W_mux W_mux_S1(
        // .WDATA_M0(WDATA_M0_reg_q),
        // .WSTRB_M0(WSTRB_M0_reg_q),
        // .WLAST_M0(WLAST_M0_reg_q),
        // .WVALID_M0(WVALID_M0_reg_q),
        .WDATA_M1(WDATA_M1),
        .WSTRB_M1(WSTRB_M1),
        .WLAST_M1(WLAST_M1),
        .WVALID_M1(WVALID_M1),
        .gnt(line_grant), // from arbiter
        .WDATA(WDATA_S1_temp),// to Slave 1
        .WSTRB(WSTRB_S1_temp),
        .WLAST(WLAST_S1_temp),
        .WVALID(WVALID_S1_temp)
    );

// 	R_mux R_mux_M0(
// 		.RID_S1(RID_S1_reg_q),
// 		.RDATA_S1(RDATA_S1_reg_q),
// 		.RRESP_S1(RRESP_S1_reg_q),
// 		.RLAST_S1(RLAST_S1_reg_q),
// 		.RVALID_S1(RVALID_S1_reg_q),
// 		.RID_S0(RID_S0_reg_q),
// 		.RDATA_S0(RDATA_S0_reg_q),
// 		.RRESP_S0(RRESP_S0_reg_q),
// 		.RLAST_S0(RLAST_S0_reg_q),
// 		.RVALID_S0(RVALID_S0_reg_q),
// 		.RID(RID_M0_reg_d),
// 		.RDATA(RDATA_M0_reg_d),
// 		.RRESP(RRESP_M0_reg_d),
// 		.RLAST(RLAST_M0_reg_d),
// 		.RVALID(RVALID_M0_reg_d)
// 	);

// 	R_mux R_mux_M1(
// 		.RID_S1(RID_S1_reg_q),
// 		.RDATA_S1(RDATA_S1_reg_q),
// 		.RRESP_S1(RRESP_S1_reg_q),
// 		.RLAST_S1(RLAST_S1_reg_q),
// 		.RVALID_S1(RVALID_S1_reg_q),
// 		.RID_S0(RID_S0_reg_q),
// 		.RDATA_S0(RDATA_S0_reg_q),
// 		.RRESP_S0(RRESP_S0_reg_q),
// 		.RLAST_S0(RLAST_S0_reg_q),
// 		.RVALID_S0(RVALID_S0_reg_q),
// 		.RID(RID_M1_reg_d),
// 		.RDATA(RDATA_M1_reg_d),
// 		.RRESP(RRESP_M1_reg_d),
// 		.RLAST(RLAST_M1_reg_d),
// 		.RVALID(RVALID_M1_reg_d)
// 	);

assign 


always_ff @(posedge ACLK or negedge ARESETn) begin
	if(!ARESETn) begin
		REQUEST_reg_q <= 0;

		//SLAVE INTERFACE FOR MASTERS
		//WRITE ADDRESS
		AWREADY_M1_reg_q <= 0;

		//WRITE DATA
		// WDATA_M1_reg_q <= 0;
		// WSTRB_M1_reg_q <= 0;
		// WLAST_M1_reg_q <= 0;
		// WVALID_M1_reg_q <= 0;
		WREADY_M1_reg_q <= 0;
		//WRITE RESPONSE
		BID_M1_reg_q <= 0;
		BRESP_M1_reg_q <= 0;
		BVALID_M1_reg_q <= 0;
		// BREADY_M1_reg_q <= 0;

		//READ ADDRESS0
		ARID_M0_reg_q <= 0;
		ARADDR_M0_reg_q <= 0;
		ARLEN_M0_reg_q <= 0;
		ARSIZE_M0_reg_q <= 0;
		ARBURST_M0_reg_q <= 0;
		ARVALID_M0_reg_q <= 0;
		ARREADY_M0_reg_q <= 0;
		//READ DATA0
		RID_M0_reg_q <= 0;
		RDATA_M0_reg_q <= 0;
		RRESP_M0_reg_q <= 0;
		RLAST_M0_reg_q <= 0;
		RVALID_M0_reg_q <= 0;
		RREADY_M0_reg_q <= 0;
		//READ ADDRESS1
		ARID_M1_reg_q <= 0;
		ARADDR_M1_reg_q <= 0;
		ARLEN_M1_reg_q <= 0;
		ARSIZE_M1_reg_q <= 0;
		ARBURST_M1_reg_q <= 0;
		ARVALID_M1_reg_q <= 0;
		ARREADY_M1_reg_q <= 0;
		//READ DATA1
		RID_M1_reg_q <= 0;
		RDATA_M1_reg_q <= 0;
		RRESP_M1_reg_q <= 0;
		RLAST_M1_reg_q <= 0;
		RVALID_M1_reg_q <= 0;
		RREADY_M1_reg_q <= 0;

		//MASTER INTERFACE FOR SLAVES
		//WRITE ADDRESS0
        AWID_S0_reg_q <= 0;
		AWADDR_S0_reg_q <= 0;
		AWLEN_S0_reg_q <= 0;
		AWSIZE_S0_reg_q <= 0;
		AWBURST_S0_reg_q <= 0;

		//WRITE DATA0
		WDATA_S0_reg_q <= 0;
		WSTRB_S0_reg_q <= 0;
		WLAST_S0_reg_q <= 0;
		WVALID_S0_reg_q <= 0;
		// WREADY_S0_reg_q <= 0;
		//WRITE RESPONSE0
		// BID_S0_reg_q <= 0;
		// BRESP_S0_reg_q <= 0;
		// BVALID_S0_reg_q <= 0;
		BREADY_S0_reg_q <= 0;
		
		//WRITE ADDRESS1
        AWID_S1_reg_q <= 0;
		AWADDR_S1_reg_q <= 0;
		AWLEN_S1_reg_q <= 0;
		AWSIZE_S1_reg_q <= 0;
		AWBURST_S1_reg_q <= 0;

		//WRITE DATA1
		WDATA_S1_reg_q <= 0;
		WSTRB_S1_reg_q <= 0;
		WLAST_S1_reg_q <= 0;
		WVALID_S1_reg_q <= 0;
		// WREADY_S1_reg_q <= 0;
		//WRITE RESPONSE1
		// BID_S1_reg_q <= 0;
		// BRESP_S1_reg_q <= 0;
		// BVALID_S1_reg_q <= 0;
		BREADY_S1_reg_q <= 0;
		
		//READ ADDRESS0
		ARID_S0_reg_q <= 0;
		ARADDR_S0_reg_q <= 0;
		ARLEN_S0_reg_q <= 0;
		ARSIZE_S0_reg_q <= 0;
		ARBURST_S0_reg_q <= 0;
		ARVALID_S0_reg_q <= 0;
		ARREADY_S0_reg_q <= 0;
		//READ DATA0
		RID_S0_reg_q <= 0;
		RDATA_S0_reg_q <= 0;
		RRESP_S0_reg_q <= 0;
		RLAST_S0_reg_q <= 0;
		RVALID_S0_reg_q <= 0;
		RREADY_S0_reg_q <= 0;
		//READ ADDRESS1
		ARID_S1_reg_q <= 0;
		ARADDR_S1_reg_q <= 0;
		ARLEN_S1_reg_q <= 0;
		ARSIZE_S1_reg_q <= 0;
		ARBURST_S1_reg_q <= 0;
		ARVALID_S1_reg_q <= 0;
		ARREADY_S1_reg_q <= 0;
		//READ DATA1
		RID_S1_reg_q <= 0;
		RDATA_S1_reg_q <= 0;
		RRESP_S1_reg_q <= 0;
		RLAST_S1_reg_q <= 0;
		RVALID_S1_reg_q <= 0;
		RREADY_S1_reg_q <= 0;
	end

	else begin
		REQUEST_reg_q <= REQUEST_reg_d;

		//SLAVE INTERFACE FOR MASTERS
		//WRITE ADDRESS
		// AWID_M1_reg_q <= AWID_M1_reg_d;
		// AWADDR_M1_reg_q <= AWADDR_M1_reg_d;
		// AWLEN_M1_reg_q <= AWLEN_M1_reg_d;
		// AWSIZE_M1_reg_q <= AWSIZE_M1_reg_d;
		// AWBURST_M1_reg_q <= AWBURST_M1_reg_d;
		// AWVALID_M1_reg_q <= AWVALID_M1_reg_d;
        AWREADY_M1_reg_q <= AWREADY_M1_reg_d;

		//WRITE DATA
		// WDATA_M1_reg_q <= WDATA_M1_reg_d;
		// WSTRB_M1_reg_q <= WSTRB_M1_reg_d;
		// WLAST_M1_reg_q <= WLAST_M1_reg_d;
		// WVALID_M1_reg_q <= WVALID_M1_reg_d;
		WREADY_M1_reg_q <= WREADY_M1_reg_d;
		//WRITE RESPONSE
		BID_M1_reg_q <= BID_M1_reg_d;
		BRESP_M1_reg_q <= BRESP_M1_reg_d;
		BVALID_M1_reg_q <= BVALID_M1_reg_d;
		// BREADY_M1_reg_q <= BREADY_M1_reg_d;

		//READ ADDRESS0
		ARID_M0_reg_q <= ARID_M0_reg_d;
		ARADDR_M0_reg_q <= ARADDR_M0_reg_d;
		ARLEN_M0_reg_q <= ARLEN_M0_reg_d;
		ARSIZE_M0_reg_q <= ARSIZE_M0_reg_d;
		ARBURST_M0_reg_q <= ARBURST_M0_reg_d;
		ARVALID_M0_reg_q <= ARVALID_M0_reg_d;
		ARREADY_M0_reg_q <= ARREADY_M0_reg_d;
		//READ DATA0
		RID_M0_reg_q <= RID_M0_reg_d;
		RDATA_M0_reg_q <= RDATA_M0_reg_d;
		RRESP_M0_reg_q <= RRESP_M0_reg_d;
		RLAST_M0_reg_q <= RLAST_M0_reg_d;
		RVALID_M0_reg_q <= RVALID_M0_reg_d;
		RREADY_M0_reg_q <= RREADY_M0_reg_d;
		//READ ADDRESS1
		ARID_M1_reg_q <= ARID_M1_reg_d;
		ARADDR_M1_reg_q <= ARADDR_M1_reg_d;
		ARLEN_M1_reg_q <= ARLEN_M1_reg_d;
		ARSIZE_M1_reg_q <= ARSIZE_M1_reg_d;
		ARBURST_M1_reg_q <= ARBURST_M1_reg_d;
		ARVALID_M1_reg_q <= ARVALID_M1_reg_d;
		ARREADY_M1_reg_q <= ARREADY_M1_reg_d;
		//READ DATA1
		RID_M1_reg_q <= RID_M1_reg_d;
		RDATA_M1_reg_q <= RDATA_M1_reg_d;
		RRESP_M1_reg_q <= RRESP_M1_reg_d;
		RLAST_M1_reg_q <= RLAST_M1_reg_d;
		RVALID_M1_reg_q <= RVALID_M1_reg_d;
		RREADY_M1_reg_q <= RREADY_M1_reg_d;

		//MASTER INTERFACE FOR SLAVES
		//WRITE ADDRESS0
		AWREADY_S0_reg_q <= AWREADY_S0_reg_d;

		//WRITE DATA0
		WDATA_S0_reg_q <= WDATA_S0_reg_d;
		WSTRB_S0_reg_q <= WSTRB_S0_reg_d;
		WLAST_S0_reg_q <= WLAST_S0_reg_d;
		WVALID_S0_reg_q <= WVALID_S0_reg_d;
		// WREADY_S0_reg_q <= WREADY_S0_reg_d;
		//WRITE RESPONSE0
		// BID_S0_reg_q <= BID_S0_reg_d;
		// BRESP_S0_reg_q <= BRESP_S0_reg_d;
		// BVALID_S0_reg_q <= BVALID_S0_reg_d;
		BREADY_S0_reg_q <= BREADY_S0_reg_d;
		
		//WRITE ADDRESS1
		AWREADY_S1_reg_q <= AWREADY_S1_reg_d;

		//WRITE DATA1
		WDATA_S1_reg_q <= WDATA_S1_reg_d;
		WSTRB_S1_reg_q <= WSTRB_S1_reg_d;
		WLAST_S1_reg_q <= WLAST_S1_reg_d;
		WVALID_S1_reg_q <= WVALID_S1_reg_d;
		// WREADY_S1_reg_q <= WREADY_S1_reg_d;
		//WRITE RESPONSE1
		// BID_S1_reg_q <= BID_S1_reg_d;
		// BRESP_S1_reg_q <= BRESP_S1_reg_d;
		// BVALID_S1_reg_q <= BVALID_S1_reg_d;
		BREADY_S1_reg_q <= BREADY_S1_reg_d;
		
		//READ ADDRESS0
		ARID_S0_reg_q <= ARID_S0_reg_d;
		ARADDR_S0_reg_q <= ARADDR_S0_reg_d;
		ARLEN_S0_reg_q <= ARLEN_S0_reg_d;
		ARSIZE_S0_reg_q <= ARSIZE_S0_reg_d;
		ARBURST_S0_reg_q <= ARBURST_S0_reg_d;
		ARVALID_S0_reg_q <= ARVALID_S0_reg_d;
		ARREADY_S0_reg_q <= ARREADY_S0_reg_d;
		//READ DATA0
		RID_S0_reg_q <= RID_S0_reg_d;
		RDATA_S0_reg_q <= RDATA_S0_reg_d;
		RRESP_S0_reg_q <= RRESP_S0_reg_d;
		RLAST_S0_reg_q <= RLAST_S0_reg_d;
		RVALID_S0_reg_q <= RVALID_S0_reg_d;
		RREADY_S0_reg_q <= RREADY_S0_reg_d;
		//READ ADDRESS1
		ARID_S1_reg_q <= ARID_S1_reg_d;
		ARADDR_S1_reg_q <= ARADDR_S1_reg_d;
		ARLEN_S1_reg_q <= ARLEN_S1_reg_d;
		ARSIZE_S1_reg_q <= ARSIZE_S1_reg_d;
		ARBURST_S1_reg_q <= ARBURST_S1_reg_d;
		ARVALID_S1_reg_q <= ARVALID_S1_reg_d;
		ARREADY_S1_reg_q <= ARREADY_S1_reg_d;
		//READ DATA1
		RID_S1_reg_q <= RID_S1_reg_d;
		RDATA_S1_reg_q <= RDATA_S1_reg_d;
		RRESP_S1_reg_q <= RRESP_S1_reg_d;
		RLAST_S1_reg_q <= RLAST_S1_reg_d;
		RVALID_S1_reg_q <= RVALID_S1_reg_d;
		RREADY_S1_reg_q <= RREADY_S1_reg_d;
	end
end


        // AWID_M1_reg_d = AWID_M1_reg_q;
		// AWADDR_M1_reg_d = AWADDR_M1_reg_q;
		// AWLEN_M1_reg_d = AWLEN_M1_reg_q;
		// AWSIZE_M1_reg_d = AWSIZE_M1_reg_q;
		// AWBURST_M1_reg_d = AWBURST_M1_reg_q;
		// AWVALID_M1_reg_d = AWVALID_M1_reg_q;
//AW channel
always_comb begin
    unique if(AWREADY_S0 == 0 && AWVALID_S0 == 1) begin
        AWID_S0_reg_d = AWID_S0_reg_q;
		AWADDR_S0_reg_d = AWADDR_S0_reg_q;
		AWLEN_S0_reg_d = AWLEN_S0_reg_q;
		AWSIZE_S0_reg_d = AWSIZE_S0_reg_q;
		AWBURST_S0_reg_d = AWBURST_S0_reg_q;
		AWVALID_S0_reg_d = AWVALID_S0_reg_q;
    end
    else begin
        AWID_S0_reg_d = AWID_S0_temp;
		AWADDR_S0_reg_d = AWADDR_S0_temp;
		AWLEN_S0_reg_d = AWLEN_S0_temp;
		AWSIZE_S0_reg_d = AWSIZE_S0_temp;
		AWBURST_S0_reg_d = AWBURST_S0_temp;
		AWVALID_S0_reg_d = AWVALID_S0_temp;
    end
end

always_comb begin
    unique if(AWREADY_S1 == 0 && AWVALID_S1 == 1) begin
        AWID_S1_reg_d = AWID_S1_reg_q;
		AWADDR_S1_reg_d = AWADDR_S1_reg_q;
		AWLEN_S1_reg_d = AWLEN_S1_reg_q;
		AWSIZE_S1_reg_d = AWSIZE_S1_reg_q;
		AWBURST_S1_reg_d = AWBURST_S1_reg_q;
		AWVALID_S1_reg_d = AWVALID_S1_reg_q;
    end
    else begin
        AWID_S1_reg_d = AWID_S1_temp;
		AWADDR_S1_reg_d = AWADDR_S1_temp;
		AWLEN_S1_reg_d = AWLEN_S1_temp;
		AWSIZE_S1_reg_d = AWSIZE_S1_temp;
		AWBURST_S1_reg_d = AWBURST_S1_temp;
		AWVALID_S1_reg_d = AWVALID_S1_temp;
    end
end

always_comb begin
    unique if(AWREADY_S1 == 1 && AWVALID_S1 == 1) begin
        AWREADY_M1_reg_d = AWREADY_S1;
    end
    else if(AWREADY_S0 == 1 && AWVALID_S0 == 1) begin
        AWREADY_M1_reg_d = AWREADY_S0;
    end
    else begin
        AWREADY_M1_reg_d = 0; 
    end
end


//AW channel
always_comb begin
    unique if(WREADY_S0 == 0 && WVALID_S0 == 1) begin
		WDATA_S0_reg_d = WDATA_S0_reg_q;
		WSTRB_S0_reg_d = WSTRB_S0_reg_q;
		WLAST_S0_reg_d = WLAST_S0_reg_q;
		WVALID_S0_reg_d = WVALID_S0_reg_q;
    end
    else begin
        WDATA_S0_reg_d = WDATA_S0_temp;
		WSTRB_S0_reg_d = WSTRB_S0_temp;
		WLAST_S0_reg_d = WLAST_S0_temp;
		WVALID_S0_reg_d = WVALID_S0_temp;
    end
end

always_comb begin
    unique if(WREADY_S1 == 0 && WVALID_S1 == 1) begin
        WDATA_S1_reg_d = WDATA_S1_reg_q;
		WSTRB_S1_reg_d = WSTRB_S1_reg_q;
		WLAST_S1_reg_d = WLAST_S1_reg_q;
		WVALID_S1_reg_d = WVALID_S1_reg_q;
    end
    else begin
        WDATA_S1_reg_d = WDATA_S1_temp;
		WSTRB_S1_reg_d = WSTRB_S1_temp;
		WLAST_S1_reg_d = WLAST_S1_temp;
		WVALID_S1_reg_d = WVALID_S1_temp;
    end
end

always_comb begin
    unique if(WREADY_S1 == 1 && WVALID_S1 == 1) begin
        WREADY_M1_reg_d = WREADY_S1;
    end
    else if(AWREADY_S0 == 1 && AWVALID_S0 == 1) begin
        WREADY_M1_reg_d = WREADY_S0;
    end
    else begin
        WREADY_M1_reg_d = 0; 
    end
end


assign BREADY_S0_reg_d = BREADY_M1;
assign BREADY_S1_reg_d = BREADY_M1;

always_comb begin
    unique if(BVALID_S0 == 1 && BREADY_S0 == 1) begin
        BID_M1_reg_d = BID_S0[3:0];
        BRESP_M1_reg_d = BRESP_S0;
        BVALID_M1_reg_d = BVALID_S0;
    end
    else if (BVALID_S1 == 1 && BREADY_S1 == 1)begin
        BID_M1_reg_d = BID_S0[3:0];
        BRESP_M1_reg_d = BRESP_S0;
        BVALID_M1_reg_d = BVALID_S0;
    end
    else begin
        BID_M1_reg_d = BID_S0_reg_q;
        BRESP_M1_reg_d = BRESP_S0_reg_q;
        BVALID_M1_reg_d = BVALID_S0_reg_q;
    end
end

endmodule