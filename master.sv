// burst bits size determined by how mamy burst operation you want 
// here use 2 bit 00-> SINGLE   01-> INCR   10-> WRAP4   11-> INCR4
module Master(
//WRITE DATA CHANNEL
	//WRITE ADDRESS
	output [`AXI_ID_BITS-1:0] AWID,
	output [`AXI_ADDR_BITS-1:0] AWADDR,
	output [`AXI_LEN_BITS-1:0] AWLEN,
	output [`AXI_SIZE_BITS-1:0] AWSIZE,
	output [1:0] AWBURST,
	output AWVALID,
	input AWREADY,
	//WRITE DATA
	output [`AXI_DATA_BITS-1:0] WDATA,
	output [`AXI_STRB_BITS-1:0] WSTRB,
	output WLAST,
	output WVALID,
	input WREADY,
	//WRITE RESPONSE
	input [`AXI_ID_BITS-1:0] BID,
	input [1:0] BRESP,
	input BVALID,
	output BREADY,

	//READ ADDRESS1
	output [`AXI_ID_BITS-1:0] ARID,
	output [`AXI_ADDR_BITS-1:0] ARADDR,
	output [`AXI_LEN_BITS-1:0] ARLEN,
	output [`AXI_SIZE_BITS-1:0] ARSIZE,
	output [1:0] ARBURST,
	output ARVALID,
	input ARREADY,
	//READ DATA1
	input [`AXI_ID_BITS-1:0] RID,
	input [`AXI_DATA_BITS-1:0] RDATA,
	input [1:0] RRESP,
	input RLAST,
	input RVALID,
	output RREADY
);





endmodule