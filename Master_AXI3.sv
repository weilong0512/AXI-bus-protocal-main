//================================================
// Auther:      Yang Chun-Wen (Willie)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//================================================
`include "AXI_define.svh"
`include "Ax_mux.sv"
`include "Ax_decoder.sv"
`include "W_mux.sv"

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


// AW 
	logic [`AXI_ID_BITS-1:0] AWID_mux2dec,
	logic [`AXI_ADDR_BITS-1:0] AWADDR_mux2dec,
	logic [`AXI_LEN_BITS-1:0] AWLEN_mux2dec,
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_mux2dec,
	logic [1:0] AWBURST_mux2dec,
	logic AWVALID_mux2dec,
    Ax_mux AW_mux(
        .AxID_M0(AWID_M0),
        .AxADDR_M0(AWADDR_M0),
        .AxLEN_M0(AWLEN_M0),
        .AxSIZE_M0(AWSIZE_M0),
        .AxBURST_M0(AWBURST_M0),
        .AxVALID_M0(AWVALID_M0),
        .AxID_M1(AWID_M1),
        .AxADDR_M1(AWADDR_M1),
        .AxLEN_M1(AWLEN_M1),
        .AxSIZE_M1(AWSIZE_M1),
        .AxBURST_M1(AWBURST_M1),
        .AxVALID_M1(AWVALID_M1),
        .gnt(), // from arbiter
        .AxID(AWID_mux2dec), // to decoder
        .AxADDR(AWADDR_mux2dec),
        .AxLEN(AWLEN_mux2dec),
        .AxSIZE(AWSIZE_mux2dec),
        .AxBURST(AWBURST_mux2dec),
        .AxVALID(AWVALID_mux2dec)
    );
    Ax_decoder AW_decoder(
        .AxID(AWID_mux2dec), 
        .AxADDR(AWADDR_mux2dec),
        .AxLEN(AWLEN_mux2dec),
        .AxSIZE(AWSIZE_mux2dec),
        .AxBURST(AWBURST_mux2dec),
        .AxVALID(AWVALID_mux2dec),
        .AxID_S0(AWID_S0),
        .AxADDR_S0(AWADDR_S0),
        .AxLEN_S0(AWLEN_S0),
        .AxSIZE_S0(AWSIZE_S0),
        .AxBURST_S0(AWBURST_S0),
        .AxVALID_S0(AWVALID_S0),
        .AxID_S1(AWID_S1),
        .AxADDR_S1(AWADDR_S1),
        .AxLEN_S1(AWLEN_S1),
        .AxSIZE_S1(AWSIZE_S1),
        .AxBURST_S1(AWBURST_S1),
        .AxVALID_S1(AWVALID_S1)
    );
//AR
    logic [`AXI_ID_BITS-1:0] ARID_mux2dec,
	logic [`AXI_ADDR_BITS-1:0] ARADDR_mux2dec,
	logic [`AXI_LEN_BITS-1:0] ARLEN_mux2dec,
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_mux2dec,
	logic [1:0] ARBURST_mux2dec,
	logic ARVALID_mux2dec,
    Ax_mux AR_mux(
        .AxID_M0(ARID_M0),
        .AxADDR_M0(ARADDR_M0),
        .AxLEN_M0(ARLEN_M0),
        .AxSIZE_M0(ARSIZE_M0),
        .AxBURST_M0(ARBURST_M0),
        .AxVALID_M0(ARVALID_M0),
        .AxID_M1(ARID_M1),
        .AxADDR_M1(ARADDR_M1),
        .AxLEN_M1(ARLEN_M1),
        .AxSIZE_M1(ARSIZE_M1),
        .AxBURST_M1(ARBURST_M1),
        .AxVALID_M1(ARVALID_M1),
        .gnt(), // from arbiter
        .AxID(ARID_mux2dec), // to decoder
        .AxADDR(ARADDR_mux2dec),
        .AxLEN(ARLEN_mux2dec),
        .AxSIZE(ARSIZE_mux2dec),
        .AxBURST(ARBURST_mux2dec),
        .AxVALID(ARVALID_mux2dec)
    );
    Ax_decoder AR_decoder(
        .AxID(ARID_mux2dec), 
        .AxADDR(ARADDR_mux2dec),
        .AxLEN(ARLEN_mux2dec),
        .AxSIZE(ARSIZE_mux2dec),
        .AxBURST(ARBURST_mux2dec),
        .AxVALID(ARVALID_mux2dec),
        .AxID_S0(ARID_S0),
        .AxADDR_S0(ARADDR_S0),
        .AxLEN_S0(ARLEN_S0),
        .AxSIZE_S0(ARSIZE_S0),
        .AxBURST_S0(ARBURST_S0),
        .AxVALID_S0(ARVALID_S0),
        .AxID_S1(ARID_S1),
        .AxADDR_S1(ARADDR_S1),
        .AxLEN_S1(ARLEN_S1),
        .AxSIZE_S1(ARSIZE_S1),
        .AxBURST_S1(ARBURST_S1),
        .AxVALID_S1(ARVALID_S1)
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
        .gnt(), // from arbiter
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
        .gnt(), // from arbiter
        .WDATA(WDATA_S1),// to Slave 1
        .WSTRB(WSTRB_S1),
        .WLAST(WLAST_S1),
        .WVALID(WVALID_S1)
    );

	 
	
	
	
	
endmodule
