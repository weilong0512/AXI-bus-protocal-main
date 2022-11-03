`include "AXI_define.svh"

module SRAM_wrapper(
	input ACLK,
	input ARESETn,

    // AW channel
    input [`AXI_IDS_BITS-1:0] AWID_S1,
    input [`AXI_ADDR_BITS-1:0] AWADDR_S1,
    input [`AXI_LEN_BITS-1:0] AWLEN_S1,
    input [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
    input [1:0] AWBURST_S1,
    input AWVALID_S1,
    output logic AWREADY_S1,

    // Write channel
    input [`AXI_DATA_BITS-1:0] WDATA_S1,
	input [`AXI_STRB_BITS-1:0] WSTRB_S1,
	input WLAST_S1,
	input WVALID_S1,
	output logic WREADY_S1,

    // Write RESP
	output logic [`AXI_IDS_BITS-1:0] BID_S1,
	output logic [1:0] BRESP_S1,
	output logic BVALID_S1,
	input BREADY_S1,

    // AR channel
	input [`AXI_IDS_BITS-1:0] ARID_S1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	input [`AXI_LEN_BITS-1:0] ARLEN_S1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	input [1:0] ARBURST_S1,
	input ARVALID_S1,
	output logic ARREADY_S1,
	// Read channel
	output logic [`AXI_IDS_BITS-1:0] RID_S1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_S1,
	output logic [1:0] RRESP_S1,
	output logic RLAST_S1,
	output logic RVALID_S1,
	input RREADY_S1

);
logic CS;
logic OE;
logic [3:0] WEB;
logic [13:0] A;
logic [31:0] DI;
logic [31:0] DO;
SRAM i_SRAM (
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
    .CK   (ACLK  ),
    .WEB0 (WEB[0]),
    .WEB1 (WEB[1]),
    .WEB2 (WEB[2]),
    .WEB3 (WEB[3]),
    .OE   (OE    ),
    .CS   (CS    )
  );
    

///////////////////////////FSM for -  Write Address Channel Slave\\\\\\\\\\\\\\\\\\\\\/////////////// 

enum logic [1:0] { 
	AWSLAVE_INIT=2'b00, 
	AWSLAVE_WAIT=2'b01, 
	AWSLAVE_READY=2'b10 } WRITEADDR_STATE, WRITEADDR_NEXTSTATE;

logic [31:0]	AWADDR_reg;
logic [`AXI_IDS_BITS-1:0] AWID_reg;

always_ff @(posedge ACLK or negedge ARESETn)	 begin	 // asynchronous reset
    if(!ARESETn)	begin
      WRITEADDR_STATE <= AWSLAVE_INIT;
    end

    else begin
      WRITEADDR_STATE <= WRITEADDR_NEXTSTATE;
    end	
end


always_comb	begin	
	case(WRITEADDR_STATE)
		AWSLAVE_INIT:begin
			AWREADY_S1 = 1'b0;
			WRITEADDR_NEXTSTATE = AWSLAVE_WAIT;
		end		
					
		AWSLAVE_WAIT:begin
			if(AWVALID_S1) begin  
				AWREADY_S1 = 1'b1;
				AWADDR_reg = AWADDR_S1; //給出ready 並且把addr吃進來， 這個addr要等到下一個AWVALID近來才會被改變，而下個VALID進來須等到下一個request進來(被arbiter控制住)
				WRITEADDR_NEXTSTATE = AWSLAVE_READY;	
        		AWID_reg = AWID_S1 ;
			end

			else begin
				WRITEADDR_NEXTSTATE = AWSLAVE_WAIT;
			end
		end
					
		AWSLAVE_READY:begin	
			
			if(WVALID_S1) begin 
				WRITEADDR_NEXTSTATE = AWSLAVE_INIT;
			end
			else begin
				WRITEADDR_NEXTSTATE = AWSLAVE_READY;
			end
		end
	endcase
end

/////////////////////////////////////////FSM for Write Data Channel of Slave \\\\\\\\\\\\\/////////////////////////////////////
////////////Write Data Channel for slave\\\
integer W_FLAG ; 
logic [1:0] AWBURST_S1_reg;
logic [31:0] masteraddress;
logic [`AXI_IDS_BITS-1:0] WID_reg;
enum logic [1:0]{
	WSLAVE_INIT=2'b00, 
	WSLAVE_WAIT=2'b01, 
	WSLAVE_READY=2'b10 } WRITED_STATE, WRITED_NEXTSTATE;



always_ff @(posedge ACLK or negedge ARESETn) begin
	if(!ARESETn) begin
		WRITED_STATE <= WSLAVE_INIT;	
	end

	else begin
		WRITED_STATE <= WRITED_NEXTSTATE;
	end
end

always_comb begin
		// if(AWVALID_S1 == 1 && AWREADY_S1 == 1)
		// 	AWADDR_r =  AWADDR_S1; 
	
    	case(WRITED_STATE)

			WSLAVE_INIT:begin
				WREADY_S1 = 1'b0;
				A = 0;
				DI = 32'b0;
				WEB = 4'b1111;
				CS = 0;
				OE = 0;
				WRITED_NEXTSTATE = WSLAVE_WAIT;
				W_FLAG = 1'b0;
				masteraddress = 0;
			end

  			WSLAVE_WAIT:begin
                if(WVALID_S1) begin //if valid 表示要做寫入
					WREADY_S1 = 1'b1; // 發出ready訊號
                    WRITED_NEXTSTATE = WSLAVE_READY; 
					AWBURST_S1_reg = AWBURST_S1; // 回來再吃新的 AWBURST_S1 訊號
					WID_reg = AWID_reg;
                    //masteraddress = masteraddress_reg; 
                end
                else begin
                    WRITED_NEXTSTATE = WSLAVE_WAIT;//繼續等待
                end
			end		
	
  			WSLAVE_READY:begin
				if(WLAST_S1) begin // 收到last 就去INIT
					WRITED_NEXTSTATE = WSLAVE_INIT;
				end
				
				else //沒有收到LAST就回來繼續處理 DATA
                    WRITED_NEXTSTATE = WSLAVE_READY;
			
 
                unique case(AWBURST_S1_reg)
                  	2'b00:begin // SINGLE
                            masteraddress = AWADDR_reg;
                            
                            unique case (WSTRB_S1)
                            	4'b1111:begin // SW
									A = masteraddress[15:2];
									DI = WDATA_S1;
									WEB = 4'b0000;
									CS = 1;
								end

								4'b0011:begin // SH
									A = masteraddress[15:2];
									case(masteraddress[1:0])
										2'b00:begin
											DI = {{16{1'b0}},{WDATA_S1[15:0]}};
											WEB = 4'b1100;
											CS = 1;
										end
										2'b10:begin
											DI = {{WDATA_S1[15:0]},{16{1'b0}}};
											WEB = 4'b0011;
											CS = 1;
										end
									endcase
								end

								4'b0001:begin //SB
									A = masteraddress[15:2];
									case(masteraddress[1:0])
										2'b00:begin
											DI = {{24{1'b0}},{WDATA_S1[7:0]}};
											WEB = 4'b1110;
											CS = 1;
										end
										2'b01:begin
											DI = {{16{1'b0}},{WDATA_S1[7:0]},{8{1'b0}}};
											WEB = 4'b1101;
											CS = 1;
										end
										2'b10:begin
											DI = {{8{1'b0}},{WDATA_S1[7:0]},{16{1'b0}}};
											WEB = 4'b1011;
											CS = 1;
										end
										2'b10:begin
											DI = {{WDATA_S1[15:0]},{24{1'b0}}};
											WEB = 4'b0111;
											CS = 1;
										end
									endcase
								end
									
                            	default: begin
								end	

                            endcase
					end
									
                  	2'b01:begin // INCR
                            if(!W_FLAG) begin //第一次進到INCR FLAG 在WAIT STATE被設0
								masteraddress = AWADDR_reg; //拿到剛剛AWVALID == 1 跟 AWREADY == 1 時拿到的addr
								W_FLAG = 1'b1; 
							end
							else ; //第二次開始遵從上一輪 masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;

			    			unique case (WSTRB_S1)
                            	4'b1111:begin // SW
									A = masteraddress[15:2];
									DI = WDATA_S1;
									WEB = 4'b0000;
									CS = 1;
									masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
								end

								4'b0011:begin // SH
									A = masteraddress[15:2];
									case(masteraddress[1:0])
										2'b00:begin
											DI = {{16{1'b0}},{WDATA_S1[15:0]}};
											WEB = 4'b1100;
											CS = 1;
											masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
										end
										2'b10:begin
											DI = {{WDATA_S1[15:0]},{16{1'b0}}};
											WEB = 4'b0011;
											CS = 1;
											masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
										end
									endcase
								end

								4'b0001:begin //SB
									A = masteraddress[15:2];
									case(masteraddress[1:0])
										2'b00:begin
											DI = {{24{1'b0}},{WDATA_S1[7:0]}};
											WEB = 4'b1110;
											CS = 1;
											masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
										end
										2'b01:begin
											DI = {{16{1'b0}},{WDATA_S1[7:0]},{8{1'b0}}};
											WEB = 4'b1101;
											CS = 1;
											masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
										end
										2'b10:begin
											DI = {{8{1'b0}},{WDATA_S1[7:0]},{16{1'b0}}};
											WEB = 4'b1011;
											CS = 1;
											masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
										end
										2'b10:begin
											DI = {{WDATA_S1[15:0]},{24{1'b0}}};
											WEB = 4'b0111;
											CS = 1;
											masteraddress = masteraddress + ( 1 << AWSIZE_S1 ) ;
										end
									endcase
								end
									
                            	default: begin
								end	

                            endcase
                    end
				

					default:;

				endcase
			end

		endcase
end



///////////////////////////////////////FSM for Write Response Channel of Slave\\\\\\\\\\\\\\\\\\\\\\\////////////
/////////////////Write Response Channel for slave
enum logic [2:0] { 
RESPONSEB_IDLE=3'b000, 
RESPONSEB_LAST=3'b001, 
RESPONSEB_START=3'b010, 
RESPONSEB_WAIT=3'b011, 
RESPONSEB_VALID=3'b100 } SLAVEB_STATE, SLAVEB_NEXTSTATE;

always_ff @(posedge ACLK or negedge ARESETn)	
begin	
	if(!ARESETn)	begin
		SLAVEB_STATE <= RESPONSEB_IDLE;
	end
	else
		SLAVEB_STATE <= SLAVEB_NEXTSTATE;
end


always_comb 
begin
	case(SLAVEB_STATE)
   RESPONSEB_IDLE:begin
                BID_S1 = 1'b0;
                BRESP_S1 = 1'b0;
                BVALID_S1 = 1'b0;
                SLAVEB_NEXTSTATE = RESPONSEB_LAST;
            end
            
   RESPONSEB_LAST:begin		
   /*
				BID_S1 = 1'b0;
                BRESP_S1 = 1'b0;
                BVALID_S1 = 1'b0;
    */
                if(WLAST_S1) begin
                    SLAVEB_NEXTSTATE = RESPONSEB_START;
                end
                else begin
                    SLAVEB_NEXTSTATE = RESPONSEB_LAST;
                    end
                end

  RESPONSEB_START:begin
                if ( AWADDR_S1 > 32'hffff &&  AWADDR_S1 <=32'h1_ffff && ARSIZE_S1 <3'b011) // 如果沒有寫錯位置 應該OK
                    BRESP_S1 = 2'b00;
                else if( (AWADDR_S1 >= 32'h0 &&  AWADDR_S1 <=32'hffff) || ARSIZE_S1 >= 3'b011) // 位置是read only 會回覆錯誤位置 或是size超過line bit size 
                    BRESP_S1 = 2'b10;
                else 
                    BRESP_S1 = 2'b11;
                BID_S1 =  WID_reg;
                BVALID_S1 = 1'b1;
                SLAVEB_NEXTSTATE = RESPONSEB_WAIT;	//ss
				end
                
   RESPONSEB_WAIT:begin	
				if (BREADY_S1)	begin
					SLAVEB_NEXTSTATE = RESPONSEB_IDLE;
				end
        else SLAVEB_NEXTSTATE = RESPONSEB_WAIT;
			end
	endcase
end	


//////////////////////////////////////////////FSM for Read Address Channel of Slave \\\\\\\\\\\\\\\\\\\\\\\/////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//
/////////////////Read Address Channel for Slave//
enum logic [1:0] {
	RSLAVE_INIT=2'b00, 
	RSLAVE_WAIT=2'b01, 
	RSLAVE_READY=2'b10} RSLAVE_STATE,RSLAVE_NEXTSTATE;

logic [31:0]ARADDR_reg;

always_ff @(posedge ACLK or negedge ARESETn) begin
	if (!ARESETn)	begin
		RSLAVE_STATE <= RSLAVE_INIT;
	end
	else	begin
		RSLAVE_STATE <= RSLAVE_NEXTSTATE;
	end
end	

always_comb begin 	
    case (RSLAVE_STATE)
  		RSLAVE_INIT:begin
            ARREADY_S1 = 1'b0;
            RSLAVE_NEXTSTATE = RSLAVE_WAIT;
        end
            
  		RSLAVE_WAIT:begin
            if (ARVALID_S1) begin
				ARREADY_S1 = 1'b1;
				ARADDR_reg = ARADDR_S1;//給出ready 並且把addr吃進來， 這個addr要等到下一個AWVALID近來才會被改變，而下個VALID進來須等到下一個request進來(被arbiter控制住)
                RSLAVE_NEXTSTATE = RSLAVE_READY;
			end
            else begin
                RSLAVE_NEXTSTATE = RSLAVE_WAIT;
            end
        end
            
 		RSLAVE_READY:begin
            RSLAVE_NEXTSTATE = RSLAVE_INIT;
        end
    endcase
end





////////////////////////////////////////////////////////////////FSM for Read Data Channel of Slave\\\\\\\\\\\\\\\\\\\\\\\\\\////////////////////
//////////////////Read Data Channel for Slave//
enum logic [2:0] {
	RDSLAVE_INIT=3'b000, 
	RDSLAVE_WAIT=3'b001, 
	RDSLAVE_READY=3'b010, 
	RDSLAVE_RWAIT=3'b011,
	RDSLAVE_ERROR=3'b100 } RDSLAVE_STATE, RDSLAVE_NEXTSTATE;
logic R_FLAG;
logic [3:0] Counter, Next_Counter;
logic [31:0] readdata_address, readdata_address_reg;
    
    
always_ff@(posedge ACLK or negedge ARESETn) begin
    if(!ARESETn) begin
        RDSLAVE_STATE    <= RDSLAVE_INIT;
        Counter     <= 4'b0000;
    end
    else begin
        RDSLAVE_STATE    <= RDSLAVE_NEXTSTATE;
        Counter     <= Next_Counter;
    end
end
        
always_comb	begin
        
    unique case(RDSLAVE_STATE)
		RDSLAVE_INIT:begin
			RID_S1 = 0;
			RDATA_S1 = 0;
			RRESP_S1 = 0;
			RLAST_S1 = 0;
			RVALID_S1 = 0;
			readdata_address = 0;
			R_FLAG = 0;
			Next_Counter = 0;
			A = 0;
			DI = 32'b0;
			WEB = 4'b1111;
			CS = 0;
			OE = 0;
			RDSLAVE_NEXTSTATE = RDSLAVE_WAIT;

		end

		RDSLAVE_WAIT:begin
   /*
			if(R_FLAG) begin
				OE = 1; //一開始會是 R_FLAG = 0 但是READ 做完之後(last結束後)會回來等待 ARREADY且R_FLAG = 1故在此處將OE pull up to 1(相當於delay 1個cycle)
				RDATA_S1 = DO;
        RVALID_S1 = 1;
			end

			else begin
        RLAST_S1 = 0;
				OE = 0;
        RID_S1 = 0;
  			RDATA_S1 = 0;
  			RRESP_S1 = 0;
  			A = 0;
  			DI = 32'b0;
  			WEB = 4'b1111;
  			CS = 0;
  			readdata_address = 0;
        RVALID_S1 = 0;
        RID_S1 = 0;
      end

			Next_Counter = 0; // FLAG = 0 代表第一次
   */

			if(ARREADY_S1) begin
				OE = 0; //進入READY STATE時先將OE設定成0 //第一次進也會先被設定成0
				RDSLAVE_NEXTSTATE = RDSLAVE_READY;
			end 

			else
				RDSLAVE_NEXTSTATE = RDSLAVE_WAIT;
		end

		RDSLAVE_READY:begin
			if(ARADDR_reg >= 32'h0 && ARADDR_reg < 32'h2_0000 && ARSIZE_S1 < 3'b011) begin

				unique case(ARBURST_S1) //下個CYCLE要OE = 1且根據LW、LB、LH、LHU、LBU調整DO是多少
					2'b00:begin // SINGLE
            			RID_S1 = ARID_S1; //若addr合法(ISRAM or DSRAM 且 transfer size 不超過4 byte)
						readdata_address = ARADDR_reg;
						A =readdata_address[15:2];
						DI = 32'b0;
						WEB = 4'b1111;
						CS = 1;
				 	end

					2'b01:begin //INCR
						if(!R_FLAG) begin
							readdata_address = ARADDR_reg;
							R_FLAG = 1;
							OE = 0; //第一次進來(第1個cycle)
              				RID_S1 = ARID_S1; //若addr合法(ISRAM or DSRAM 且 transfer size 不超過4 byte)
						end
						else begin
							OE = 1; //第二次進來不透過WAIT STATE那邊去設定OE = 1 (我的想法是會這樣dalay 1 個cycle 取得上一個cycle的正確data ? ) ;
							RDATA_S1 = DO; 
						end
						
						unique case (ARSIZE_S1)
                            3'b000:begin //LB 
								A = readdata_address[15:2];
								DI = 32'b0;
								WEB = 4'b1111;
								CS = 1;
								readdata_address = readdata_address + (1 << ARSIZE_S1);
                            end
                                    
                            3'b001:begin //LH
								A = readdata_address[15:2];
                                DI = 32'b0;
								WEB = 4'b1111;	
								CS = 1;	
								readdata_address = readdata_address + (1 << ARSIZE_S1);
                            end
                                    
                            3'b010:begin // LW
                                A = readdata_address[15:2];
                                DI = 32'b0;
								WEB = 4'b1111;	
								CS = 1;
								readdata_address = readdata_address + (1 << ARSIZE_S1);
                            end

							default:;
                        endcase


					end

					default:;

				endcase

				RVALID_S1 = 1; //取到data 設定VALID = 1
				Next_Counter=Counter+4'b1; // counter + 1
        		RRESP_S1  = 2'b00;
				if(RREADY_S1 == 1) begin //等到RREADY 
					if(Next_Counter == ARLEN_S1+4'b1) begin // 回到WAIT STATE繼續等待ARREADY
						RLAST_S1 = 1;
						R_FLAG = 0; // 然後打R_FLAG pull down to 0
						RDSLAVE_NEXTSTATE = RDSLAVE_INIT;
					end
					else begin // 還沒完成就回到同個STATE繼續做
						RLAST_S1 = 0;
						RDSLAVE_NEXTSTATE = RDSLAVE_READY;
					end
  				end
  				else if(RREADY_S1 == 0) begin
          			RLAST_S1 = 0;
          			RDSLAVE_NEXTSTATE = RDSLAVE_RWAIT; //沒到繼續等
        		end
 
			end


			else begin //如果有error

				if (ARSIZE_S1 >= 3'b011) begin//這個ERROR會直接出錯		
                    RRESP_S1 = 2'b10; //SIZE ERROR
					RDSLAVE_NEXTSTATE = RDSLAVE_WAIT;
				end
                else begin //不確定這個會不會中途ERROR
                    RRESP_S1 = 2'b11; //DECERR
					RDSLAVE_NEXTSTATE = RDSLAVE_WAIT;
				end

			end
		end

		RDSLAVE_RWAIT:begin // wait for RREADY_S1 == 1
			
			if(RREADY_S1 == 1) begin //等到RREADY 
				if(Next_Counter == ARLEN_S1+4'b1) begin // 回到WAIT STATE繼續等待ARREADY
                    RLAST_S1 = 1;
                    R_FLAG = 0; // 然後打R_FLAG pull down to 0 
					RDSLAVE_NEXTSTATE = RDSLAVE_INIT;
                end
                else begin // 還沒完成就回到同個STATE繼續做
                    RLAST_S1 = 0;
					RDSLAVE_NEXTSTATE = RDSLAVE_READY;
				end
			end
			else RDSLAVE_NEXTSTATE = RDSLAVE_RWAIT; //沒到繼續等

		end

	endcase
end

endmodule