// burst bits size determined by how mamy burst operation you want 
// here use 2 bit 00-> SINGLE   01-> INCR   10-> WRAP4   11-> INCR4
module Master(
//WRITE DATA CHANNEL
	output logic WREADY,     //write ready signal from slave
	input logic WVALID,		//valid signal for write 
	input logic WLAST,		//write last signal
	input logic[3:0] WSTRB,		// strobe signal for writing in
	input logic[31:0] WDATA,		//write data
	input logic[7:0] WID,        //write data id

//WRITE RESPONSE CHANNEL
	input logic[7:0] BID, 		//response id
	output logic[3:0] BRESP,	 	//write response signal from slave
	output logic BVALID,     //write response valid signal
	output logic BREADY,     //write response ready signal

//WRITE ADDRESS CHANNEL
	output logic AWREADY,    //write address ready signal from slave
	input logic AWVALID,    // write address valid signal
	input logic[1:0] AWBURST,	//write address channel signal for burst type
	input logic[2:0] AWSIZE,     //size of each transfer in bytes(encoded)
	input logic[3:0] AWLEN,      //burst length- number of transfers in a burst
	input logic[31:0] AWADDR,     //write address signal 
	input logic[7:0] AWID,		// write address id 

//READ ADDRESS CHANNEL
	output logic ARREADY,  //read address ready signal from slave
	input logic[7:0] ARID,      //read address id
	input logic[32:0] ARADDR,		//read address signal
	input logic[3:0] ARLEN,      //length of the burst
	input logic[2:0] ARSIZE,		//number of bytes in a transfer
	input logic[1:0] ARBURST,	//burst type - fixed, incremental, wrapping
	input logic ARVALID,	//address read valid signal

//READ DATA CHANNEL
	output logic[7:0] RID,		//read data id
	output logic[31:0] RDATA,     //read data from slave
 	output logic[1:0] RRESP,		//read response signal
	output logic RLAST,		//read data last signal
	output logic RVALID,		//read data valid signal
	input logic RREADY		//read ready signal
);


endmodule