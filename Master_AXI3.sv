//================================================
// Auther:      Yang Chun-Wen (Willie)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//================================================
`include "AXI_define.svh"
`include "master.sv"

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

//--------------------------------------------------------------------------
//-----------------------FSM for M1 channel---------------------------------
//--------------------------------------------------------------------------
Master M1();  // call M1 module

//AW channel states of M1
enum logic [1:0] { 
    MWRITE_IDLE=2'b00,
    MWRITE_START=2'b01,
    MWRITE_WAIT=2'b10,
    MWRITE_VALID=2'b11 } MAWRITEState, MAWRITENext_state; 

always_ff @(posedge clk or negedge rst) begin	

        if(!rst) begin
            MAWRITEState <= MWRITE_IDLE;
        end

        else begin
            MAWRITEState <= MAWRITENext_state;
        end	
end

always_comb	 begin	
	case(MAWRITEState)
        MWRITE_IDLE:begin
            M1.AWVALID = 0;
            M1.AWBURST = 0;
            M1.AWSIZE = 0;
            M1.AWLEN = 0;
            M1.AWADDR = 0;
            M1.AWID = 0;
            MAWRITENext_state = MWRITE_START;
        end		
                
        MWRITE_START:begin
			if(AWADDR_M1 > 32'h0)  begin //start state 接收到 ADDR 則 assign 沒有則 回去IDEL等待 CPU Wrapper 的AWADDR assign
			    M1.AWBURST = AWBURST_M1;
			    M1.AWSIZE = AWSIZE_M1;
			    M1.AWLEN = AWLEN_M1;
			    M1.AWADDR = AWADDR_M1;
			    M1.AWID = AWID_M1;
			    M1.AWVALID = 1'b1;
			    MAWRITENext_state = MWRITE_WAIT;	
			end
				 
            else
                MAWRITENext_state = MWRITE_IDLE;
        end
             
	    MWRITE_WAIT:begin	
			if (M1.AWREADY) //收到READY signal則進入VALID
				MAWRITENext_state = MWRITE_VALID;

			else
				MAWRITENext_state = MWRITE_WAIT; //沒有則繼續等待
		end
	
	    MWRITE_VALID:begin
		    M1.AWVALID = 0; //清空VALID signal
		    if(M1.BREADY) // 收到完成 RESPONSE 回到IDEL 等待ADDR assign
		    	MAWRITENext_state = MWRITE_IDLE;

		    else // 等待RESPONSE
		    	MAWRITENext_state = MWRITE_VALID;
	    end
	endcase
end


//W channel states of M1

// Master - Write data Channel  states
logic [4:0] Count, NextCount;
enum logic [2:0] {MWRITE_INIT=3'b000,
    MWRITE_TRANSFER,
    MWRITE_READY, 
    MDWRITE_VALID,
    MWRITE_ERROR} MWRITEState, MWRITENext_state;

always_ff @(posedge clk or negedge rst)begin  // asyncrhonus reset
	if(!rst) begin
		MWRITEState <= MWRITE_INIT;
		Count <= 4'b0;
	end

	else begin
		MWRITEState <= MWRITENext_state;
		Count <= NextCount;
	end
end

always_comb begin
	case(MWRITEState)
    
		MWRITE_INIT:begin
		    M1.WID = 0;
			M1.WDATA = 0;
			M1.WSTRB = 0;
			M1.WLAST = 0;
			M1.WVALID = 0;
			NextCount = 0;
            if(M1.AWREADY == 1) 
                MWRITENext_state = MWRITE_TRANSFER;	
            else 
                MWRITENext_state = MWRITE_INIT;
        end

        MWRITE_TRANSFER:begin	
            if(AWADDR_M1 > 32'hffff && AWADDR_M1 <= 32'h1_ffff && AWSIZE_M1 <3'b100) begin // allow read write
                M1.WID =  M1.AWID;
                M1.WVALID = 1;
                M1.WSTRB = WSTRB_M1;
                M1.WDATA = WDATA_M1;	
                NextCount = Count + 4'b1;
                MWRITENext_state = MWRITE_READY;
			end
			else begin
				NextCount = Count + 4'b1;
				MWRITENext_state = MWRITE_ERROR;
			end
		end

	    MWRITE_READY:begin
			if(M1.WREADY) begin
			    if(NextCount == (AWLEN_M1+1))  // use a counter to pull up  LAST signal
                    M1.WLAST = 1'b1;
				else
                    M1.WLAST = 1'b0;
                    
				MWRITENext_state = MDWRITE_VALID;
			end

			else 
                MWRITENext_state = MWRITE_READY;	
		end
	
	    MDWRITE_VALID:begin
            M1.WVALID = 0;
                      
			if(NextCount == AWLEN_M1+1) begin
				MWRITENext_state = MWRITE_INIT;	
				M1.WLAST=0;
			end
			else 
                MWRITENext_state = MWRITE_TRANSFER;
		end
	  
        MWRITE_ERROR:begin
			if(NextCount == (AWLEN_M1+1)) begin
				M1.WLAST = 1'b1;
				MWRITENext_state = MDWRITE_VALID;
			end
			else begin
				M1.WLAST = 1'b0;
				MWRITENext_state = MWRITE_TRANSFER;
			end
		end	
	endcase
end



    
	
	
	
	
	
endmodule
