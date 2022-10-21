`include "SRAM_rtl.sv"

module SRAM_wrapper_S0 ( // read only

    // AW channel
    input [`AXI_IDS_BITS-1:0] AWID_S0,
    input [`AXI_ADDR_BITS-1:0] AWADDR_S0,
    input [`AXI_LEN_BITS-1:0] AWLEN_S0,
    input [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
    input [1:0] AWBURST_S0,
    input AWVALID_S0,
    output AWREADY_S0,

    // Write channel
    input [`AXI_DATA_BITS-1:0] WDATA_S0,
	input [`AXI_STRB_BITS-1:0] WSTRB_S0,
	input WLAST_S0,
	input WVALID_S0,
	output WREADY_S0,

    // Write RESP
	output [`AXI_IDS_BITS-1:0] BID_S0,
	output [1:0] BRESP_S0,
	output BVALID_S0,
	input BREADY_S0,

    // AR channel
	output [`AXI_IDS_BITS-1:0] ARID_S0,
	output [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output [1:0] ARBURST_S0,
	output ARVALID_S0,
	input ARREADY_S0,
	// Read channel
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output RREADY_S0

);


    
/*
  SRAM i_SRAM ( // 改寫舊的wrapper
    .A0   (A[0]  ),
    .A1   (A[1]  ),
    .A2   (A[2]  ),
    .A3   (A[3]  ),
    .A4   (A[4]  ),
    .A5   (A[5]  ),
    .A6   (A[6]  ),
    .A7   (A[7]  ),
    .A8   (A[8]  ),
    .A9   (A[9]  ),
    .A10  (A[10] ),
    .A11  (A[11] ),
    .A12  (A[12] ),
    .A13  (A[13] ),
    .DO0  (DO[0] ),
    .DO1  (DO[1] ),
    .DO2  (DO[2] ),
    .DO3  (DO[3] ),
    .DO4  (DO[4] ),
    .DO5  (DO[5] ),
    .DO6  (DO[6] ),
    .DO7  (DO[7] ),
    .DO8  (DO[8] ),
    .DO9  (DO[9] ),
    .DO10 (DO[10]),
    .DO11 (DO[11]),
    .DO12 (DO[12]),
    .DO13 (DO[13]),
    .DO14 (DO[14]),
    .DO15 (DO[15]),
    .DO16 (DO[16]),
    .DO17 (DO[17]),
    .DO18 (DO[18]),
    .DO19 (DO[19]),
    .DO20 (DO[20]),
    .DO21 (DO[21]),
    .DO22 (DO[22]),
    .DO23 (DO[23]),
    .DO24 (DO[24]),
    .DO25 (DO[25]),
    .DO26 (DO[26]),
    .DO27 (DO[27]),
    .DO28 (DO[28]),
    .DO29 (DO[29]),
    .DO30 (DO[30]),
    .DO31 (DO[31]),
    .DI0  (DI[0] ),
    .DI1  (DI[1] ),
    .DI2  (DI[2] ),
    .DI3  (DI[3] ),
    .DI4  (DI[4] ),
    .DI5  (DI[5] ),
    .DI6  (DI[6] ),
    .DI7  (DI[7] ),
    .DI8  (DI[8] ),
    .DI9  (DI[9] ),
    .DI10 (DI[10]),
    .DI11 (DI[11]),
    .DI12 (DI[12]),
    .DI13 (DI[13]),
    .DI14 (DI[14]),
    .DI15 (DI[15]),
    .DI16 (DI[16]),
    .DI17 (DI[17]),
    .DI18 (DI[18]),
    .DI19 (DI[19]),
    .DI20 (DI[20]),
    .DI21 (DI[21]),
    .DI22 (DI[22]),
    .DI23 (DI[23]),
    .DI24 (DI[24]),
    .DI25 (DI[25]),
    .DI26 (DI[26]),
    .DI27 (DI[27]),
    .DI28 (DI[28]),
    .DI29 (DI[29]),
    .DI30 (DI[30]),
    .DI31 (DI[31]),
    .CK   (CK    ),
    .WEB0 (WEB[0]),
    .WEB1 (WEB[1]),
    .WEB2 (WEB[2]),
    .WEB3 (WEB[3]),
    .OE   (OE    ),
    .CS   (CS    )
  );

*/
///////////////////////////FSM for -  Write Address Channel Slave\\\\\\\\\\\\\\\\\\\\\/////////////// 

enum logic [1:0] { 
	WSLAVE_INIT=2'b00, 
	WSLAVE_WAIT=2'b01, 
	WSLAVE_READY=2'b10 } WRITEADDR_STATE, WRITEADDR_NEXTSTATE;

always_ff @(posedge clock or negedge reset)	 begin	 // asynchronous reset
    if(!reset)	begin
      WRITEADDR_STATE <= WSLAVE_INIT;
    end

    else begin
      WRITEADDR_STATE <= WRITEADDR_NEXTSTATE;
    end	
end


always_comb	begin	
	case(WRITEADDR_STATE)
		WSLAVE_INIT:begin
			AWREADY_S0 = 1'b0;
			WRITEADDR_NEXTSTATE = WSLAVE_WAIT;
		end		
					
		WSLAVE_WAIT:begin
			AWREADY_S0 = 1'b0;
			if(AWVALID_S0) begin
				WRITEADDR_NEXTSTATE = WSLAVE_READY;	
			end

			else begin
				WRITEADDR_NEXTSTATE = WSLAVE_WAIT;
			end
		end
					
		WSLAVE_READY:begin	
			AWREADY_S0 = 1'b1;
			WRITEADDR_NEXTSTATE = WSLAVE_WAIT;
		end
	endcase
end

/////////////////////////////////////////FSM for Write Data Channel of Slave \\\\\\\\\\\\\/////////////////////////////////////
////////////Write Data Channel for slave\\\
logic [31:0]	AWADDR_r;
integer first_time, first_time_next2,wrap_boundary; 
logic [31:0] masteraddress, masteraddress_reg, masteraddress_temp;
enum logic [1:0]{
	WSLAVE_INIT=2'b00, 
	WDSLAVE_WAIT=2'b01, 
	WDSLAVE_READY=2'b10, 
	WDSLAVE_VALID=2'b11} WRITED_STATE, WRITED_NEXTSTATE;

always_ff @(posedge clock or negedge reset) begin
	if(!reset) begin
		WRITED_STATE <= WSLAVE_INIT;	
	end

	else begin
		WRITED_STATE <= WRITED_NEXTSTATE;
		first_time <= first_time_next2;
	end
end

always_comb begin
		if(AWVALID_S0 == 1)
			AWADDR_r =  AWADDR_S0; 
	
    	case(WRITED_STATE)

			WSLAVE_INIT:begin
				WREADY_S0 = 1'b0;
				WRITED_NEXTSTATE = WDSLAVE_WAIT;
				first_time_next2 = 0;
				masteraddress_reg = 0;
				masteraddress = 0;
			end

  			WDSLAVE_WAIT:begin
                if(WVALID_S0) begin //if valid 表示要做寫入
                    WRITED_NEXTSTATE = WDSLAVE_READY;
                    masteraddress = masteraddress_reg; 
                end
                else begin
                    WRITED_NEXTSTATE = WDSLAVE_WAIT;//繼續等待
                end
			end		
	
  			WDSLAVE_READY:begin
				if(WLAST_S0) begin // 收到last 就去INIT
					WRITED_NEXTSTATE = WSLAVE_INIT;
				end
				
				else //沒有收到LAST就回來繼續處理 DATA
                    WRITED_NEXTSTATE = WDSLAVE_READY;
			
				WREADY_S0 = 1'b1; // (繼續)發出ready訊號
                    
                unique case(AWBURST_S0)
                  	2'b00:begin // SINGLE
                            masteraddress = AWADDR_r;
                            
                            unique case (WSTRB_S0)
                            	4'b0001:begin	
                                        A = masteraddress[15:2];
										DI = WDATA_S0[7:0];
                                end
                                    
                            	4'b0010:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[15:8];
                                end
                                    
                            	4'b0100:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[23:16];
                                end
                                    
                            	4'b1000:begin
                                        slave_memory[masteraddress] =  WDATA_S0[31:24];
                                end
                                    
                            	4'b0011:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];
                                        slave_memory[masteraddress+1] =  WDATA_S0[15:8];
                                end
                                    
                            	4'b0101:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];											
                                        slave_memory[masteraddress+1] =  WDATA_S0[23:16];
                                end
                                    
                            	4'b1001:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];											
                                        slave_memory[masteraddress+1] =  WDATA_S0[31:24];
                                end
                                    
                            	4'b0110:begin
                                        slave_memory[masteraddress] =  WDATA_S0[15:0];												
                                        slave_memory[masteraddress+1] =  WDATA_S0[23:16];
                                end
                                    
                            	4'b1010:begin
                                        slave_memory[masteraddress] =  WDATA_S0[15:8];										
                                        slave_memory[masteraddress+1] =  WDATA_S0[31:24];
                                end
                                    
                            	4'b1100:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[23:16];
                                        slave_memory[masteraddress+1] =  WDATA_S0[31:24];
                                end
                                    
                            	4'b0111:begin										
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];
                                        slave_memory[masteraddress+1] =  WDATA_S0[15:8];											
                                        slave_memory[masteraddress+2] =  WDATA_S0[23:16];
                                end
										
								4'b1110:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[15:8];
                                        slave_memory[masteraddress+1] =  WDATA_S0[23:16];										
                                        slave_memory[masteraddress+2] =  WDATA_S0[31:24];
                                end
                                    
                            	4'b1011:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];
                                        slave_memory[masteraddress+1] =  WDATA_S0[15:8];											
                                        slave_memory[masteraddress+2] =  WDATA_S0[31:24];
                                end
                                    
                            	4'b1101:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];										
                                        slave_memory[masteraddress+1] =  WDATA_S0[23:16];											
                                        slave_memory[masteraddress+2] =  WDATA_S0[31:24];
                                end
                                    
                           		4'b1111:begin	
                                        slave_memory[masteraddress] =  WDATA_S0[7:0];										
                                        slave_memory[masteraddress+1] =  WDATA_S0[15:8];										
                                        slave_memory[masteraddress+2] =  WDATA_S0 [23:16];										
                                        slave_memory[masteraddress+3] =  WDATA_S0 [31:24];
                                end
									
                            	default: begin
								end	

                            endcase
					end
									
                  	2'b01:begin // INCR
                            if(first_time == 0) 
                            begin
                                masteraddress = AWADDR_r;
                                first_time_next2 = 1;
                            end	
                            else	
                                first_time_next2 = first_time;
                            
                            if(BREADY_S0 == 1)
                                first_time_next2 = 0;
                            else 
                                first_time_next2 = first_time;
                            
                            unique case (WSTRB_S0)
                            4'b0001:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                        masteraddress_reg = masteraddress + 1;				
                                    end
                                    
                            4'b0010:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [15:8];
                                        masteraddress_reg = masteraddress + 1;
                                    end
                                    
                            4'b0100:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [23:16];
                                        masteraddress_reg = masteraddress + 1;
                                    end
                                    
                            4'b1000:begin
                                        slave_memory[masteraddress] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 1;
                                    end
                                    
                            4'b0011:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [15:8];
                                        masteraddress_reg = masteraddress + 2;
                                    end
                                    
                            4'b0101:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];										
                                        slave_memory[masteraddress+1] =  WDATA_S0 [23:16];
                                        masteraddress_reg = masteraddress + 2;
                                    end
                                    
                            4'b1001:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];													
                                        slave_memory[masteraddress+1] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 2;
                                    end
                                    
                            4'b0110:begin
                                        slave_memory[masteraddress] =  WDATA_S0 [15:0];													
                                        slave_memory[masteraddress+1] =  WDATA_S0 [23:16];
                                        masteraddress_reg = masteraddress + 2;
                                    end
                                    
                            4'b1010:begin
                                        slave_memory[masteraddress] =  WDATA_S0 [15:8];											
                                        slave_memory[masteraddress+1] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 2;
                                    end
                                    
                            4'b1100:begin
                                        slave_memory[masteraddress] =  WDATA_S0 [23:16];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 2;
                                    end
                                    
                            4'b0111:begin										
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [15:8];												
                                        slave_memory[masteraddress+2] =  WDATA_S0 [23:16];
                                        masteraddress_reg = masteraddress + 3;
                                    end
                                    
                            4'b1110:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [15:8];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [23:16];												
                                        slave_memory[masteraddress+2] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 3;
                                    end
                                    
                            4'b1011:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [15:8];												
                                        slave_memory[masteraddress+2] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 3;
                                    end
                                    
                            4'b1101:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [23:16];												
                                        slave_memory[masteraddress+2] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 3;
                                    end
                                    
                            4'b1111:begin	
                                        slave_memory[masteraddress] =  WDATA_S0 [7:0];												
                                        slave_memory[masteraddress+1] =  WDATA_S0 [15:8];													
                                        slave_memory[masteraddress+2] =  WDATA_S0 [23:16];													
                                        slave_memory[masteraddress+3] =  WDATA_S0 [31:24];
                                        masteraddress_reg = masteraddress + 4;
                                    end
			    					default: begin	
									end
                            endcase
                    end
				/*	
 					2'b10:begin // WRAP
                        if(first_time == 0) begin
                            masteraddress = AWADDR_r;
                            first_time_next2 = 1;
                        end	
                        else 
                            first_time_next2 = first_time;	



                        if(BREADY_S0 == 1)
                            first_time_next2 = 0;
                        else 
                            first_time_next2 = first_time;

						
								
                        unique case(AWLEN_S0)

							4'b0001:begin
                                unique case(AWSIZE_S0)
                                    3'b000: begin
                                        wrap_boundary = 2 * 1; 
                                    end
                                    3'b001: begin
                                        wrap_boundary = 2 * 2;																		
                                    end	
                                    3'b010: begin
                                        wrap_boundary = 2 * 4;																		
                                    end
                                    default: ;
                                endcase			
                            end
                                    
                            4'b0011:begin
                                unique case(AWSIZE_S0)
                                	3'b000: begin
                                        wrap_boundary = 4 * 1;
                                    end
                                    3'b001: begin
                                        wrap_boundary = 4 * 2;																		
                                    end	
                                    3'b010: begin
                                        wrap_boundary = 4 * 4;																		
                                    end
                                    default:;
                                endcase			
                            end
													
                            4'b0111:begin
                                unique case(AWSIZE_S0)
                                	3'b000: begin
                                        wrap_boundary = 8 * 1;
                                    end
                                    3'b001: begin
                                        wrap_boundary = 8 * 2;																		
                                    end	
                                    3'b010: begin
                                        wrap_boundary = 8 * 4;																		
                                    end
                                    default:;
                                endcase			
                            end	
											
                            4'b1111:begin
                                unique case(AWSIZE_S0)
                                	3'b000: begin
                                        wrap_boundary = 16 * 1;
                                	end
                                    3'b001: begin
                                        wrap_boundary = 16 * 2;																		
                                    end	
                                    3'b010: begin
                                        wrap_boundary = 16 * 4;																		
                                    end
                                    default:;
                                endcase			
                        	end

                        endcase						
										
                        unique case(WSTRB_S0)    //Write strobe signal is encoded for writing different bit positions to the slave memory.
                            4'b0001:begin	    
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else		
                                    masteraddress_reg = masteraddress_temp;	
                            end
                                    
                            4'b0010:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b0100:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b1000:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b0011:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                    
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                            
                                slave_memory[masteraddress_reg] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b0101:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                	masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;

                                slave_memory[masteraddress_reg] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b1001:begin	
                                slave_memory[masteraddress] =  WDATA_S0WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b0110:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [15:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                     masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b1010:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary== 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b1100:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b0111:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b1110:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                                    
                            4'b1011:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end
                            4'b1101:begin	
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                    
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                        	end
                                    
                            4'b1111: begin	
                                slave_memory[masteraddress] =  WDATA_S0 [7:0];
                                masteraddress_temp = masteraddress + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [15:8];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [23:16];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                                        
                                slave_memory[masteraddress_reg] =  WDATA_S0 [31:24];
                                masteraddress_temp = masteraddress_reg + 1;
                                        
                                if(masteraddress_temp % wrap_boundary == 0)
                                    masteraddress_reg = masteraddress_temp - wrap_boundary;
                                else
                                    masteraddress_reg = masteraddress_temp;
                            end

                            default: ;

                        endcase

                    end
				*/

					default:;

				endcase
						$display("each beat Meme= %p",slave_memory);
			end

  			WDSLAVE_VALID:begin

                WREADY_S0 = 1'b0;
				WRITED_NEXTSTATE = WDSLAVE_WAIT;

			end

		endcase
end

endmodule