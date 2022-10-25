`include "AXI_define.svh"

module SRAM_wrapper(
	input ACLK,
	input ARESETn,

    // AW channel
    input [`AXI_IDS_BITS-1:0] AWID,
    input [`AXI_ADDR_BITS-1:0] AWADDR,
    input [`AXI_LEN_BITS-1:0] AWLEN,
    input [`AXI_SIZE_BITS-1:0] AWSIZE,
    input [1:0] AWBURST,
    input AWVALID,
    output logic AWREADY,

    // Write channel
    input [`AXI_DATA_BITS-1:0] WDATA,
	input [`AXI_STRB_BITS-1:0] WSTRB,
	input WLAST,
	input WVALID,
	output logic WREADY,

    // Write RESP
	output logic [`AXI_IDS_BITS-1:0] BID,
	output logic [1:0] BRESP,
	output logic BVALID,
	input BREADY,

    // AR channel
	input [`AXI_IDS_BITS-1:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
	output logic ARREADY,
	// Read channel
	output logic [`AXI_IDS_BITS-1:0] RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0] RRESP,
	output logic RLAST,
	output logic RVALID,
	input RREADY

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

enum logic [1:0]{
    AW_INIT = 2'b00,
    AW_WAIT = 2'b01,
    AW_START = 2'b10,
} AW_STATE, AW_NEXTSTATE;

logic [`AXI_IDS_BITS-1:0] AWID_reg;
logic [`AXI_ADDR_BITS-1:0] AWADDR_reg;
logic [`AXI_LEN_BITS-1:0] AWLEN_reg;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_reg;
logic [1:0] AWBURST_reg;



always_ff @(posedge ACLK or negedge ARESETn) begin 

    if(!ARESETn) begin
        AW_STATE <= AW_INIT;
    end
    else begin
        AW_STATE <= AW_NEXTSTATE;
    end

end

always_comb begin

    case (AW_STATE)
        
        AW_INIT:begin
            AWREADY = 1'b1;
            AW_NEXTSTATE = AW_WAIT;
        end

        AW_WAIT:begin
            if(AWVALID == 1)begin
                AW_NEXTSTATE = AW_START;
            end

            else begin
                AW_NEXTSTATE = AW_WAIT;
            end
        end

        AW_START:begin
            AWREADY = 1'b0;
            AW_NEXTSTATE = AW_INIT;
        end

    endcase

end

///////////////////////////FSM for -  Write Data Channel Slave\\\\\\\\\\\\\\\\\\\\\/////////////// 

enum logic [1:0]{
    W_INIT = 2'b00,
    W_WAIT = 2'b01,
    W_START = 2'b10,
    W_FINISH = 2'b11} W_STATE, W_NEXTSTATE;

// [`AXI_IDS_BITS-1:0] AWID_reg;
// [`AXI_ADDR_BITS-1:0] AWADDR_reg;
// [`AXI_LEN_BITS-1:0] AWLEN_reg;
// [`AXI_SIZE_BITS-1:0] AWSIZE_reg;
// [1:0] AWBURST_reg;
logic [`AXI_IDS_BITS-1:0] WID_reg, BID_reg, Write_ID;
logic [`AXI_ADDR_BITS-1:0] WADDR_reg, MasterAddr;
logic [`AXI_LEN_BITS-1:0] WLEN_reg, Write_LEN;
logic [`AXI_SIZE_BITS-1:0] WSIZE_reg, Write_SIZE;
logic [1:0] WBURST_reg, Write_BURST;
logic [`AXI_DATA_BITS-1:0] WDATA_reg, Write_DATA;
logic [`AXI_STRB_BITS-1:0] WSTRB_reg, Write_STRB;
logic WLAST_reg, Write_LAST;
logic W_FLAG;
logic [31:0] write_addr_reg, write_addr;
logic [1:0] BRESP_reg;

parameter [5:0] TOKEN = 6'b000001; 

always_ff @(posedge ACLK or negedge ARESETn) begin 

    if(!ARESETn) begin
        W_STATE <= W_INIT;
    end
    else begin
        W_STATE <= W_NEXTSTATE;
    end

end

always_comb begin

    if( AWVALID == 1 && AWREADY == 1) begin // handshake 1 次
        AWADDR_reg = AWADDR;
        AWBURST_reg = AWBURST;
        AWID_reg = AWID;
        AWSIZE_reg = AWSIZE;
        AWLEN_reg = AWLEN;
    end

    case (W_STATE)
        
        W_INIT:begin
            WREADY = 1'b1;
            BREADY = 0;
            W_FLAG = 0;
            WADDR_reg = 0;
            WBURST_reg = 0;
            WID_reg = 0;
            WSIZE_reg = 0;
            WLEN_reg = 0;
            WDATA_reg = 0; 
            WSTRB_reg = 0;
            WLAST_reg = 0;
            W_NEXTSTATE = W_WAIT;
        end

        W_WAIT:begin
            if(WVALID == 1)begin
                if(!W_FLAG) begin //這次是第一次HS  、 single會回到這裡
                    WADDR_reg = AWADDR_reg;
                    WBURST_reg = AWBURST_reg;
                    WID_reg = AWID_reg_reg;
                    WSIZE_reg = AWSIZE_reg;
                    WLEN_reg = AWLEN_reg;
                    WDATA_reg = WDATA; 
                    WSTRB_reg = WSTRB;
                    WLAST_reg = WLAST;
                    BREADY = 1;
                end
                else begin //這次不是第一次HS
                    WDATA_reg = WDATA;
                    WLAST_reg = WLAST;
                end

                W_NEXTSTATE = W_START; 
            end

            else begin
                W_NEXTSTATE = W_WAIT;
            end
        end

        W_START:begin
            
            MasterAddr = WADDR_reg;
            Write_BURST = WBURST_reg;
            Write_ID = WID_reg;
            Write_SIZE = WSIZE_reg;
            Write_LEN = WLEN_reg;
            Write_DATA = WDATA_reg; 
            Write_STRB = WSTRB_reg;
            Write_LAST = WLAST_reg;

            if(MasterAddr >= 32'h2_0000 || MasterAddr < 32'h1_0000 || Write_SIZE > 3'b011) begin //錯誤的時候donothing 等待last
                unique case(Write_BURST)
                    2'b00:begin // SINGLE
                        BID_reg = Write_ID;
                        W_NEXTSTATE = W_FINISH;

                    end
                                    
                    2'b01:begin // INCR
                        if(!W_FLAG) begin //第一次進到INCR FLAG 在WAIT STATE被設0
                            write_addr = MasterAddr; //拿到剛剛AWVALID == 1 跟 AWREADY == 1 時拿到的addr
                            W_FLAG = 1'b1; 
                        end
                        else write_addr = write_addr_reg; //第二次開始遵從上一輪 write_addr = write_addr + ( 1 << AWSIZE_S1 ) ;


                        if(Write_LAST == 1) begin
                            BID_reg = Write_ID;
                            W_NEXTSTATE = W_FINISH;
                        end
                        else begin
                            W_NEXTSTATE = W_WAIT;
                        end
                    end
                

                    default:;

                endcase

                if(MasterAddr < 32'h1_0000 || Write_SIZE > 3'b011)begin
                    BRESP_reg = 2'b01;
                end
                else BRESP_reg = 2'b11;

            end

            else begin
                unique case(Write_BURST)
                    2'b00:begin // SINGLE
                        write_addr = MasterAddr;
                        
                        unique case (Write_STRB)
                            4'b1111:begin // SW
                                A = write_addr[15:2];
                                DI = Write_DATA;
                                WEB = 4'b0000;
                                CS = 1;
                            end

                            4'b0011:begin // SH
                                A = write_addr[15:2];
                                case(write_addr[1:0])
                                    2'b00:begin
                                        DI = {{16{1'b0}},{Write_DATA[15:0]}};
                                        WEB = 4'b1100;
                                        CS = 1;
                                    end
                                    2'b10:begin
                                        DI = {{Write_DATA[15:0]},{16{1'b0}}};
                                        WEB = 4'b0011;
                                        CS = 1;
                                    end
                                endcase
                            end

                            4'b0001:begin //SB
                                A = write_addr[15:2];
                                case(write_addr[1:0])
                                    2'b00:begin
                                        DI = {{24{1'b0}},{Write_DATA[7:0]}};
                                        WEB = 4'b1110;
                                        CS = 1;
                                    end
                                    2'b01:begin
                                        DI = {{16{1'b0}},{Write_DATA[7:0]},{8{1'b0}}};
                                        WEB = 4'b1101;
                                        CS = 1;
                                    end
                                    2'b10:begin
                                        DI = {{8{1'b0}},{Write_DATA[7:0]},{16{1'b0}}};
                                        WEB = 4'b1011;
                                        CS = 1;
                                    end
                                    2'b10:begin
                                        DI = {{Write_DATA[15:0]},{24{1'b0}}};
                                        WEB = 4'b0111;
                                        CS = 1;
                                    end
                                endcase
                            end
                                
                            default: begin
                            end	

                        endcase // single結束沒有改寫, FLAG == 0
                        BRESP_reg = 2'b00;
                        BID_reg = Write_ID;
                        W_NEXTSTATE = W_FINISH;

                    end
                                    
                    2'b01:begin // INCR
                        if(!W_FLAG) begin //第一次進到INCR, FLAG == 0
                            write_addr = MasterAddr; //拿到剛剛AWVALID == 1 跟 AWREADY == 1 時拿到的addr
                            W_FLAG = 1'b1; 
                        end
                        else write_addr = write_addr_reg; //第二次開始遵從上一輪 write_addr_reg = write_addr + ( 1 << AWSIZE_S1 ) ;

                        unique case (Write_STRB)
                            4'b1111:begin // SW
                                A = write_addr[15:2];
                                DI = Write_DATA;
                                WEB = 4'b0000;
                                CS = 1;
                                write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                            end

                            4'b0011:begin // SH
                                A = write_addr[15:2];
                                case(write_addr[1:0])
                                    2'b00:begin
                                        DI = {{16{1'b0}},{Write_DATA[15:0]}};
                                        WEB = 4'b1100;
                                        CS = 1;
                                        write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                                    end
                                    2'b10:begin
                                        DI = {{Write_DATA[15:0]},{16{1'b0}}};
                                        WEB = 4'b0011;
                                        CS = 1;
                                        write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                                    end
                                endcase
                            end

                            4'b0001:begin //SB
                                A = write_addr[15:2];
                                case(write_addr[1:0])
                                    2'b00:begin
                                        DI = {{24{1'b0}},{Write_DATA[7:0]}};
                                        WEB = 4'b1110;
                                        CS = 1;
                                        write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                                    end
                                    2'b01:begin
                                        DI = {{16{1'b0}},{Write_DATA[7:0]},{8{1'b0}}};
                                        WEB = 4'b1101;
                                        CS = 1;
                                        write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                                    end
                                    2'b10:begin
                                        DI = {{8{1'b0}},{Write_DATA[7:0]},{16{1'b0}}};
                                        WEB = 4'b1011;
                                        CS = 1;
                                        write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                                    end
                                    2'b10:begin
                                        DI = {{Write_DATA[15:0]},{24{1'b0}}};
                                        WEB = 4'b0111;
                                        CS = 1;
                                        write_addr_reg = write_addr + ( TOKEN << AWSIZE_S1 ) ;
                                    end
                                endcase
                            end
                                
                            default: begin
                            end	

                        endcase

                        if(Write_LAST == 1) begin
                            BRESP_reg = 2'b00;
                            BID_reg = Write_ID;
                            W_NEXTSTATE = W_FINISH;
                        end
                        else begin
                            W_NEXTSTATE = W_WAIT;
                        end
                    end
                endcase
            
            end
        end


        W_FINISH:begin
            WREADY = 1'b0;
            if(BVALID == 1) begin
                BRESP = BRESP_reg;
                BID = BID_reg;
                W_NEXTSTATE = W_INIT;
            end
            else W_NEXTSTATE = W_FINISH;
        end

    endcase

end


//////////////////////////////////////////////FSM for Read Address Channel of Slave \\\\\\\\\\\\\\\\\\\\\\\/////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//
enum logic [1:0] {
	AR_INIT=2'b00, 
	AR_WAIT=2'b01, 
	AR_READY=2'b10} AR_STATE, AR_NEXTSTATE;

always_ff @(posedge ACLK or negedge ARESETn) begin
	if (!ARESETn)	begin
		AR_STATE <= AR_INIT;
	end
	else	begin
		AR_STATE <= AR_NEXTSTATE;
	end
end	

always_comb begin 	
    case (AR_STATE)
  		AR_INIT:begin
            ARREADY_S1 = 1'b1;
            AR_NEXTSTATE = AR_WAIT;
        end
            
  		AR_WAIT:begin
            if (ARVALID_S1) begin
                AR_NEXTSTATE = AR_READY;
			end
            else begin
                AR_NEXTSTATE = AR_WAIT;
            end
        end
            
 		AR_READY:begin
            ARREADY_S1 = 1'b0;
            AR_NEXTSTATE = AR_INIT;
        end
    endcase
end


//////////////////////////////////////////////FSM for Read Data Channel of Slave \\\\\\\\\\\\\\\\\\\\\\\/////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//



enum logic [2:0] {
	R_INIT=3'b000, 
	R_ARWAIT=3'b001,
    R_RWAIT=3'b010,
	R_READY=3'b011,
    R_ERROR=3'b100} R_STATE, R_NEXTSTATE;
logic [31:0]ARADDR_reg;
logic [`AXI_IDS_BITS-1:0] ARID_reg, RID_reg, Read_ID;
logic [`AXI_ADDR_BITS-1:0] ARADDR_reg, RADDR_reg, Read_Addr, Read_Addr_reg;
logic [`AXI_LEN_BITS-1:0] ARLEN_reg, RLEN_reg;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_reg, RSIZE_reg;
logic [1:0] ARBURST_reg, RBURST_reg;
logic R_FLAG, RLAST_reg;
logic [3:0]counter, next_counter; 
logic [1:0] RRESP_reg;



always_comb begin 	
    case (R_STATE)
  		R_INIT:begin
            ARADDR_reg = 0;
            ARID_reg = 0;
            ARLEN_reg = 0;
            ARSIZE_reg = 0;
            ARBURST_reg = 0;
            RRESP_reg = 0;
            RVALID = 0;
            R_FLAG = 0;
            RLAST = 0;
            RLAST_reg = 0;
            OE = 0;
            CS = 0;
            DI = 32'b0;
            WEB = 4'b1111;
            counter = 0;
            next_counter = 0;
            R_NEXTSTATE = R_ARWAIT;
        end
            
  		R_ARWAIT:begin
            if(ARVALID == 1 && ARREADY == 1) begin
                ARADDR_reg = ARADDR;
                ARID_reg = ARID;
                ARLEN_reg = ARLEN;
                ARSIZE_reg = ARSIZE;
                ARBURST_reg = ARBURST;
                R_NEXTSTATE = R_RWAIT;
            end
            else begin
                R_NEXTSTATE = R_ARWAIT;
            end
        end

        R_RWAIT:begin
            RVALID = 1;
            RADDR_reg = ARADDR_reg;
            RSIZE_reg = ARSIZE_reg;
            RBURST_reg = ARBURST_reg;
            RLEN_reg = ARLEN_reg
            Read_ID = ARID_reg;
            if(RADDR_reg >= 32'h0000 && RADDR_reg < 32'h2_0000 && RSIZE_reg < 3'b011) begin
                unique case(RBURST_reg) //下個CYCLE要OE = 1且根據LW、LB、LH、LHU、LBU調整DO是多少
					2'b00:begin // SINGLE
            			RID_reg = Read_ID; //若addr合法(ISRAM or DSRAM 且 transfer size 不超過4 byte)
						Read_Addr = RADDR_reg;
						A =Read_Addr[15:2];
						CS = 1;
                        RLAST_reg = 1;
                        RRESP_reg = 2'b00;
                        R_NEXTSTATE = R_READY;
				 	end

					2'b01:begin //INCR
						if(!R_FLAG) begin
							Read_Addr = RADDR_reg;
                            RID_reg = Read_ID;
							R_FLAG = 1;
						end
						else begin
                            Read_Addr = Read_Addr_reg;
                            counter = next_counter;
						end
						
						unique case (RSIZE_reg)
                            3'b000:begin //LB 
								A = Read_Addr[15:2];
								CS = 1;
								Read_Addr_reg = Read_Addr + (TOKEN << RSIZE_reg);
                                next_counter = counter + 1;
                            end
                                    
                            3'b001:begin //LH
								A = Read_Addr[15:2];
								CS = 1;	
								Read_Addr_reg= Read_Addr + (TOKEN << RSIZE_reg);
                                next_counter = counter + 1;
                            end
                                    
                            3'b010:begin // LW
                                A = Read_Addr[15:2];
								CS = 1;
								Read_Addr_reg = Read_Addr + (TOKEN << RSIZE_reg);
                                next_counter = counter + 1;
                            end

							default:;
                        endcase

                        if(next_counter - 1 == RLEN_reg) begin
                            RLAST_reg = 1;
                            RRESP_reg = 2'b00;
                            R_NEXTSTATE = R_READY;
                        end begin
                            R_NEXTSTATE = R_READY;
                        end


					end

					default:;

				endcase
            end
            
            else begin
                if(RSIZE_reg >= 3'b011 ) begin
                    unique case(RBURST_reg) //下個CYCLE要OE = 1且根據LW、LB、LH、LHU、LBU調整DO是多少
                        2'b00:begin // SINGLE
                            RID_reg = Read_ID; //若addr合法(ISRAM or DSRAM 且 transfer size 不超過4 byte)
                            Read_Addr = RADDR_reg;
                            RLAST_reg = 1;
                            RRESP_reg = 2'b10;
                            R_NEXTSTATE = R_ERROR;
                        end

                        2'b01:begin //INCR
                            if(!R_FLAG) begin
                                Read_Addr = RADDR_reg;
                                RID_reg = Read_ID;
                                R_FLAG = 1;
                            end
                            else begin
                                counter = next_counter;
                            end
                            
                            unique case (RSIZE_reg)
                                3'b000:begin //LB 
                                    next_counter = counter + 1;
                                end
                                        
                                3'b001:begin //LH
                                    next_counter = counter + 1;
                                end
                                        
                                3'b010:begin // LW
                                    next_counter = counter + 1;
                                end

                                default:;
                            endcase

                            if(next_counter - 1 == RLEN_reg) begin
                                RLAST_reg = 1;
                                RRESP_reg = 2'b10;
                                R_NEXTSTATE = R_ERROR;
                            end begin
                                R_NEXTSTATE = R_ERROR;
                            end


                        end

                        default:;

                    endcase
                end
                else begin
                    unique case(RBURST_reg) //下個CYCLE要OE = 1且根據LW、LB、LH、LHU、LBU調整DO是多少
                        2'b00:begin // SINGLE
                            RID_reg = Read_ID; //若addr合法(ISRAM or DSRAM 且 transfer size 不超過4 byte)
                            Read_Addr = RADDR_reg;
                            RLAST_reg = 1;
                            RRESP_reg = 2'b11;
                            R_NEXTSTATE = R_ERROR;
                        end

                        2'b01:begin //INCR
                            if(!R_FLAG) begin
                                Read_Addr = RADDR_reg;
                                RID_reg = Read_ID;
                                R_FLAG = 1;
                            end
                            else begin
                                counter = next_counter;
                            end
                            
                            unique case (RSIZE_reg)
                                3'b000:begin //LB 
                                    next_counter = counter + 1;
                                end
                                        
                                3'b001:begin //LH
                                    next_counter = counter + 1;
                                end
                                        
                                3'b010:begin // LW
                                    next_counter = counter + 1;
                                end

                                default:;
                            endcase

                            if(next_counter - 1 == RLEN_reg) begin
                                RLAST_reg = 1;
                                RRESP_reg = 2'b11;
                                R_NEXTSTATE = R_ERROR;
                            end begin
                                R_NEXTSTATE = R_ERROR;
                            end


                        end

                        default:;

                    endcase
                end

            end
        end
            
 		R_READY:begin
            RID = RID_reg;
            if(RREADY == 1) begin
                OE = 1;
                RDATA = DO; 
                if(RLAST_reg = 1) begin
                    RLAST = 1;
                    RRESP = RRESP_reg;
                    R_NEXTSTATE = R_INIT;
                end
                else begin
                    RLAST = 0;
                    R_NEXTSTATE = R_RWAIT;
                end

            end

            else begin
                R_NEXTSTATE = R_READY;
            end
        end

        R_ERROR:begin
            RID = RID_reg;
            if(RREADY == 1) begin
                if(RLAST_reg = 1) begin
                    RLAST = 1;
                    RRESP = RRESP_reg;
                    R_NEXTSTATE = R_INIT;
                end
                else begin
                    RLAST = 0;
                    R_NEXTSTATE = R_RWAIT;
                end

            end

            else begin
                R_NEXTSTATE = R_ERROR;
            end
        end
    endcase
end


endmodule