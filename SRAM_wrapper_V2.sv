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

enum logic [2:0]{
    INIT=3'b000,
    WAIT=3'b001,
    WRITE_WAIT=3'b010,
    READ_WAIT=3'b011,
    WRITE_RESP=3'b100,
    WRITE_VALID=3'b101,
    READ_VALID=3'b110,
    READ_ERROR=3'b111
} STATE, NXSTATE;

logic [`AXI_IDS_BITS-1:0] AWID_reg, ARID_reg;
logic [`AXI_ADDR_BITS-1:0] AWADDR_reg_Q, ARADDR_reg_Q, AWADDR_reg_D, ARADDR_reg_D;
logic [`AXI_LEN_BITS-1:0] AWLEN_reg , ARLEN_reg;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_reg, ARSIZE_reg;
logic [1:0] AWBURST_reg, ARBURST_reg;
parameter [5:0] TOKEN = 6'b000001; 
logic [3:0] Counter, Next_Counter;
logic [1:0] BRESP_reg, RRESP_reg;
logic [`AXI_DATA_BITS-1:0] WDATA_reg;
logic [`AXI_STRB_BITS-1:0] WSTRB_reg;
logic WLAST_reg;
logic RLAST_reg;


always_ff @(posedge ACLK or negedge ARESETn) begin

    if(!ARESETn) begin
        STATE <= INIT;
        AWADDR_reg_Q <= 0;
        ARADDR_reg_Q <= 0;
        Counter <= 0;
        //ARLEN_reg_Q <= 0;
        //AWLEN_reg_Q <= 0;
    end

    else begin
        STATE <= NXSTATE;
        AWADDR_reg_Q <= AWADDR_reg_D;
        ARADDR_reg_Q <= ARADDR_reg_D;
        Counter <= Next_Counter;
        //ARLEN_reg_Q <= ARLEN_reg_D ;
        //AWLEN_reg_Q <= AWLEN_reg_D ;

    end

end


always_comb begin   



    case (STATE)

        INIT:begin
            BRESP = 2'b00;
            RRESP = 2'b00;
            WREADY = 0;
            RLAST = 0;
            BVALID = 0;
            RVALID = 0;
            AWREADY = 1;
            ARREADY = 1;
            NXSTATE = WAIT;
            // AW_reg
            AWID_reg = 0;
            AWLEN_reg = 0;
            AWSIZE_reg = 0;
            AWBURST_reg = 0;
            // AR_reg
            ARID_reg = 0;
            ARLEN_reg = 0;
            ARSIZE_reg = 0;
            ARBURST_reg = 0;
            //
            Next_Counter = 0;
        end

        WAIT:begin

            unique if (AWVALID == 1)begin
                AWID_reg = AWID;
                AWADDR_reg_D = AWADDR;
                AWLEN_reg = AWLEN;
                AWSIZE_reg = AWSIZE;
                AWBURST_reg = AWBURST;

                NXSTATE = WRITE_WAIT;
            end

            else if (ARVALID == 1) begin
                ARID_reg = ARID;
                ARADDR_reg_D = ARADDR;
                ARLEN_reg = ARLEN;
                ARSIZE_reg = ARSIZE;
                ARBURST_reg = ARBURST;

                NXSTATE = READ_WAIT;
            end
            
            else NXSTATE = WAIT;

        end

        WRITE_WAIT:begin

            ARREADY = 0;
            WREADY = 1;
            if(WVALID == 1)begin
                WDATA_reg = WDATA; 
                WSTRB_reg = WSTRB;
                WLAST_reg = WLAST;
                NXSTATE = WRITE_VALID;
            end
            else NXSTATE = WRITE_WAIT;
        
        end

        WRITE_VALID:begin
            WREADY = 0;
            if(WLAST_reg == 1) begin
                
                NXSTATE = WRITE_RESP;
            end
            else begin
                NXSTATE = WRITE_WAIT;
            end

            //
            if(AWADDR_reg_Q >= 32'h1_0000 && AWADDR_reg_Q < 32'h2_0000 && AWSIZE_reg < 3'b011) begin
                unique case(AWBURST_reg)
                    2'b00:begin 
                        
                        unique case (WSTRB_reg)
                            4'b1111:begin // SW
                                A = AWADDR_reg_Q[15:2];
                                DI = WDATA_reg;
                                WEB = 4'b0000;
                                CS = 1;
                            end

                            4'b0011:begin // SH
                                A = AWADDR_reg_Q[15:2];
                                case(AWADDR_reg_Q[1:0])
                                    2'b00:begin
                                        DI = {{16{1'b0}},{WDATA_reg[15:0]}};
                                        WEB = 4'b1100;
                                        CS = 1;
                                    end
                                    2'b10:begin
                                        DI = {{WDATA_reg[15:0]},{16{1'b0}}};
                                        WEB = 4'b0011;
                                        CS = 1;
                                    end
                                endcase
                            end

                            4'b0001:begin //SB
                                A = AWADDR_reg_Q[15:2];
                                case(AWADDR_reg_Q[1:0])
                                    2'b00:begin
                                        DI = {{24{1'b0}},{WDATA_reg[7:0]}};
                                        WEB = 4'b1110;
                                        CS = 1;
                                    end
                                    2'b01:begin
                                        DI = {{16{1'b0}},{WDATA_reg[7:0]},{8{1'b0}}};
                                        WEB = 4'b1101;
                                        CS = 1;
                                    end
                                    2'b10:begin
                                        DI = {{8{1'b0}},{WDATA_reg[7:0]},{16{1'b0}}};
                                        WEB = 4'b1011;
                                        CS = 1;
                                    end
                                    2'b10:begin
                                        DI = {{WDATA_reg[15:0]},{24{1'b0}}};
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
                        unique case (WSTRB_reg)
                            4'b1111:begin // SW
                                A = AWADDR_reg_Q[15:2];
                                DI = WDATA_reg;
                                WEB = 4'b0000;
                                CS = 1;
                                AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
                            end

                            4'b0011:begin // SH
                                A = AWADDR_reg_Q[15:2];
                                case(AWADDR_reg_Q[1:0])
                                    2'b00:begin
                                        DI = {{16{1'b0}},{WDATA_reg[15:0]}};
                                        WEB = 4'b1100;
                                        CS = 1;
                                        AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
                                    end
                                    2'b10:begin
                                        DI = {{WDATA_reg[15:0]},{16{1'b0}}};
                                        WEB = 4'b0011;
                                        CS = 1;
                                        AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
                                    end
                                endcase
                            end

                            4'b0001:begin //SB
                                A = AWADDR_reg_Q[15:2];
                                case(AWADDR_reg_Q[1:0])
                                    2'b00:begin
                                        DI = {{24{1'b0}},{WDATA_reg[7:0]}};
                                        WEB = 4'b1110;
                                        CS = 1;
                                        AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
                                    end
                                    2'b01:begin
                                        DI = {{16{1'b0}},{WDATA_reg[7:0]},{8{1'b0}}};
                                        WEB = 4'b1101;
                                        CS = 1;
                                        AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
                                    end
                                    2'b10:begin
                                        DI = {{8{1'b0}},{WDATA_reg[7:0]},{16{1'b0}}};
                                        WEB = 4'b1011;
                                        CS = 1;
                                        AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
                                    end
                                    2'b10:begin
                                        DI = {{WDATA_reg[15:0]},{24{1'b0}}};
                                        WEB = 4'b0111;
                                        CS = 1;
                                        AWADDR_reg_D = AWADDR_reg_Q + ( TOKEN << ARSIZE_reg ) ;
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

            else ;
        end

        WRITE_RESP:begin
            AWREADY = 0;
            BVALID = 1;
            BID = AWID_reg;
            //BRESP = BRESP_reg;

            if ( AWADDR_reg_Q > 32'hffff &&  AWADDR_reg_Q <=32'h1_ffff && AWSIZE_reg <3'b011) // ???????????????????????? ??????OK
                BRESP = 2'b00;
            else if( (AWADDR_reg_Q >= 32'h0 &&  AWADDR_reg_Q <=32'hffff) || AWSIZE_reg >= 3'b011) // ?????????read only ????????????????????? ??????size??????line bit size 
                BRESP = 2'b10;
            else 
                BRESP = 2'b11;



            if(BREADY == 1)begin
                //BID = AWID_reg;
                //BRESP = BRESP_reg;
                NXSTATE = INIT;
            end

            else NXSTATE = WRITE_RESP;
        end


        READ_WAIT:begin
            AWREADY = 0;
            if(ARADDR_reg_Q >= 32'h0 && ARADDR_reg_Q < 32'h2_0000 && ARSIZE_reg < 3'b011) begin
                unique case(ARBURST_reg) //??????CYCLE???OE = 1?????????LW???LB???LH???LHU???LBU??????DO?????????
					2'b00:begin // SINGLE
						A = ARADDR_reg_Q[15:2];
						CS = 1;
				 	end

					2'b01:begin //INCR
						
						unique case (ARSIZE_reg)
                            3'b000:begin //LB 
								A = ARADDR_reg_Q[15:2];
								CS = 1;
								ARADDR_reg_D = ARADDR_reg_Q + (TOKEN << ARSIZE_reg);
                            end
                                    
                            3'b001:begin //LH
								A = ARADDR_reg_Q[15:2];
								CS = 1;	
								ARADDR_reg_D = ARADDR_reg_Q + (TOKEN << ARSIZE_reg);
                            end
                                    
                            3'b010:begin // LW
                                A = ARADDR_reg_Q[15:2];
								CS = 1;
								ARADDR_reg_D = ARADDR_reg_Q + (TOKEN << ARSIZE_reg);
                            end

							default:;
                        endcase

					end

					default:;

				endcase
                Next_Counter = Counter + 1;
                RRESP_reg = 2'b00;
                NXSTATE = READ_VALID;
            end

            else begin
                Next_Counter = Counter + 1;
                if( (ARADDR_reg_Q >= 32'h0 &&  ARADDR_reg_Q <=32'hffff) ||  ARSIZE_reg >= 3'b011) // ?????????read only ????????????????????? ??????size??????line bit size 
                    RRESP_reg = 2'b10;
                else 
                    RRESP_reg = 2'b11;
                NXSTATE = READ_ERROR;
            end;
        end



        READ_VALID:begin
            RVALID = 1;
            RRESP = 2'b00;
            RID = ARID_reg;
            RDATA = DO;
            OE = 1;
            CS = 0;
            if(Next_Counter == ARLEN_reg + 1)begin
              RLAST = 1;
              Next_Counter = Counter;
            end
            
            else begin
              RLAST = 0;
            end
            
            
            if(RREADY == 1 && RLAST == 1) begin
              //RLAST = 1;
              NXSTATE = INIT;
            end
            
            else if(RREADY == 1 && RLAST == 0) begin
              NXSTATE = READ_WAIT;
            end
            
            else begin
              NXSTATE = READ_VALID;
            end


        end

        READ_ERROR:begin
            ARREADY = 0;
            RVALID = 1;
            RRESP = RRESP_reg;
            RID = ARID_reg;
            OE = 1;
            CS = 0;
            RDATA = 32'h0;
            if(Next_Counter == ARLEN_reg + 1)begin
              RLAST = 1;
              Next_Counter = Counter;
            end
            
            else begin
              RLAST = 0;
            end
            
            
            if(RREADY == 1 && RLAST == 1) begin
              //RLAST = 1;
              NXSTATE = INIT;
            end
            
            else if(RREADY == 1 && RLAST == 0) begin
              NXSTATE = READ_WAIT;
            end
            
            else begin
              NXSTATE = READ_ERROR;
            end
        end
        
        default:;                

    endcase

end

endmodule
