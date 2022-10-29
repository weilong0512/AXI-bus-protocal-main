`include "AXI_define.svh"

module SRAM_wrapper (
	input  logic                      ACLK,
	input  logic                      ARESETn,

    // AW channel
    input  logic [`AXI_IDS_BITS-1:0]  AWID,
    input  logic [`AXI_ADDR_BITS-1:0] AWADDR,
    input  logic [`AXI_LEN_BITS-1:0]  AWLEN,
    input  logic [`AXI_SIZE_BITS-1:0] AWSIZE,
    input  logic [1:0]                AWBURST,
    input  logic                      AWVALID,
    output logic                      AWREADY,

    // Write channel
    input  logic [`AXI_DATA_BITS-1:0] WDATA,
	input  logic [`AXI_STRB_BITS-1:0] WSTRB,
	input  logic                      WLAST,
	input  logic                      WVALID,
	output logic                      WREADY,

    // Write RESP
	output logic [`AXI_IDS_BITS-1:0]  BID,
	output logic [1:0]                BRESP,
	output logic                      BVALID,
	input  logic                      BREADY,

    // AR channel
	input  logic [`AXI_IDS_BITS-1:0]  ARID,
	input  logic [`AXI_ADDR_BITS-1:0] ARADDR,
	input  logic [`AXI_LEN_BITS-1:0]  ARLEN,
	input  logic [`AXI_SIZE_BITS-1:0] ARSIZE,
	input  logic [1:0]                ARBURST,
	input  logic                      ARVALID,
	output logic                      ARREADY,
	// Read channel
	output logic [`AXI_IDS_BITS-1:0]  RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0]                RRESP,
	output logic                      RLAST,
	output logic                      RVALID,
	input  logic                      RREADY
);

    logic        CS;
    logic        OE;
    logic [3:0]  WEB;
    logic [13:0] A;
    logic [31:0] DI;
    logic [31:0] DO;

`ifndef VERILATOR
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
`endif

    /*
     * FSM for -  Write Address Channel Slave
     */
    enum logic [3:0] {
        INIT,
        WAIT,
        WRITE_WAIT,
        READ_WAIT,
        WRITE_RESP,
        WRITE_VALID,
        READ_VALID,
        READ_ERROR,
        READ_LAST,
        READ_VALID_WAIT,
        READ_ERROR_WAIT
    } STATE, NXSTATE;

    logic [`AXI_IDS_BITS-1:0]  AWID_reg_q, AWID_reg_d;
    logic [`AXI_IDS_BITS-1:0]  ARID_reg_q, ARID_reg_d;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_reg_q, AWADDR_reg_d;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_reg_q, ARADDR_reg_d;
    logic [`AXI_LEN_BITS-1:0]  ARLEN_reg_q, ARLEN_reg_d;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_reg_q, AWSIZE_reg_d;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_reg_q, ARSIZE_reg_d;
    logic [1:0]                AWBURST_reg_q, AWBURST_reg_d;
    logic [1:0]                ARBURST_reg_q, ARBURST_reg_d;
    logic [1:0]                RRESP_reg_q, RRESP_reg_d;
    logic [`AXI_DATA_BITS-1:0] WDATA_reg_q, WDATA_reg_d;
    logic [`AXI_STRB_BITS-1:0] WSTRB_reg_q, WSTRB_reg_d;
    logic                      WLAST_reg_q, WLAST_reg_d;
    logic                      RLAST_reg_q, RLAST_reg_d;
    logic [3:0]                Counter, Next_Counter;

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            STATE         <= INIT;
            AWID_reg_q    <= `AXI_IDS_BITS'd0;
            ARID_reg_q    <= `AXI_IDS_BITS'd0;
            AWADDR_reg_q  <= `AXI_ADDR_BITS'd0;
            ARADDR_reg_q  <= `AXI_ADDR_BITS'd0;
            ARLEN_reg_q   <= `AXI_LEN_BITS'd0;
            AWSIZE_reg_q  <= `AXI_SIZE_BITS'd0;
            ARSIZE_reg_q  <= `AXI_SIZE_BITS'd0;
            AWBURST_reg_q <= 2'd0;
            ARBURST_reg_q <= 2'd0;
            RRESP_reg_q   <= 2'd0;
            WDATA_reg_q   <= `AXI_DATA_BITS'd0;
            WSTRB_reg_q   <= `AXI_STRB_BITS'd0;
            WLAST_reg_q   <= 1'b0;
            RLAST_reg_q   <= 1'b0;
            Counter       <= 0;
        end else begin
            STATE         <= NXSTATE;
            AWID_reg_q    <= AWID_reg_d;
            ARID_reg_q    <= ARID_reg_d;
            AWADDR_reg_q  <= AWADDR_reg_d;
            ARADDR_reg_q  <= ARADDR_reg_d;
            ARLEN_reg_q   <= ARLEN_reg_d;
            AWSIZE_reg_q  <= AWSIZE_reg_d;
            ARSIZE_reg_q  <= ARSIZE_reg_d;
            AWBURST_reg_q <= AWBURST_reg_d;
            ARBURST_reg_q <= ARBURST_reg_d;
            RRESP_reg_q   <= RRESP_reg_d;
            WDATA_reg_q   <= WDATA_reg_d;
            WSTRB_reg_q   <= WSTRB_reg_d;
            WLAST_reg_q   <= WLAST_reg_d;
            RLAST_reg_q   <= RLAST_reg_d;
            Counter       <= Next_Counter;
        end
    end

    always_comb begin   
        unique case (STATE)
        INIT: begin
            NXSTATE       = WAIT;
            BRESP         = 2'b00;
            RRESP         = 2'b00;
            WREADY        = 0;
            RLAST         = 0;
            BVALID        = 0;
            RVALID        = 0;
            AWREADY       = 1;
            ARREADY       = 1;
            AWID_reg_d    = 0;
            AWSIZE_reg_d  = 0;
            AWBURST_reg_d = 0;
            ARID_reg_d    = 0;
            ARSIZE_reg_d  = 0;
            ARBURST_reg_d = 0;
            Next_Counter  = 0;
            OE            = 0;
            CS            = 0;
            WEB           = 4'b1111;
            DI            = 32'h0;
            RDATA         = 0;
        end

        WAIT: begin
            unique if (AWVALID == 1) begin
                AWID_reg_d     = AWID;
                AWADDR_reg_d = AWADDR;
                AWSIZE_reg_d   = AWSIZE;
                AWBURST_reg_d  = AWBURST;
                NXSTATE      = WRITE_WAIT;
            end else if (ARVALID == 1) begin
                ARID_reg_d     = ARID;
                ARADDR_reg_d = ARADDR;
                ARLEN_reg_d  = ARLEN + 1;
                ARSIZE_reg_d   = ARSIZE;
                ARBURST_reg_d  = ARBURST;
                NXSTATE      = READ_WAIT;
            end else begin
                NXSTATE = WAIT;
            end
        end

        WRITE_WAIT: begin
            ARREADY = 0;
            WREADY  = 1;
            if (WVALID == 1) begin
                WDATA_reg_d = WDATA; 
                WSTRB_reg_d = WSTRB;
                WLAST_reg_d = WLAST;
                NXSTATE   = WRITE_VALID;
            end else begin
                NXSTATE   = WRITE_WAIT;
            end
        end

        WRITE_VALID: begin
            WREADY = 0;
            if (WLAST_reg_q == 1) begin
                NXSTATE = WRITE_RESP;
            end else begin
                NXSTATE = WRITE_WAIT;
            end

            if (AWADDR_reg_q >= 32'h1_0000 && AWADDR_reg_q < 32'h2_0000 && AWSIZE_reg_q < 3'b011) begin
                unique case (AWBURST_reg_q)
                2'b00: begin 
                    unique case (WSTRB_reg_q)
                    4'b1111: begin // SW
                        A   = AWADDR_reg_q[15:2];
                        DI  = WDATA_reg_q;
                        WEB = 4'b0000;
                        CS  = 1;
                    end

                    4'b0011: begin // SH
                        A = AWADDR_reg_q[15:2];
                        case (AWADDR_reg_q[1:0])
                        2'b00: begin
                            DI  = {{16{1'b0}},{WDATA_reg_q[15:0]}};
                            WEB = 4'b1100;
                            CS  = 1;
                        end
                        2'b10: begin
                            DI  = {{WDATA_reg_q[15:0]},{16{1'b0}}};
                            WEB = 4'b0011;
                            CS  = 1;
                        end
                        endcase
                    end

                    4'b0001: begin //SB
                        A = AWADDR_reg_q[15:2];
                        case (AWADDR_reg_q[1:0])
                            2'b00: begin
                                DI = {{24{1'b0}},{WDATA_reg_q[7:0]}};
                                WEB = 4'b1110;
                                CS = 1;
                            end
                            2'b01: begin
                                DI = {{16{1'b0}},{WDATA_reg_q[7:0]},{8{1'b0}}};
                                WEB = 4'b1101;
                                CS = 1;
                            end
                            2'b10: begin
                                DI = {{8{1'b0}},{WDATA_reg_q[7:0]},{16{1'b0}}};
                                WEB = 4'b1011;
                                CS = 1;
                            end
                            2'b11: begin
                                DI = {{WDATA_reg_q[7:0]},{24{1'b0}}};
                                WEB = 4'b0111;
                                CS = 1;
                            end
                        endcase
                    end
                        
                    default: begin
                    end	
                    endcase
                end
                                
                2'b01: begin // INCR
                    unique case (WSTRB_reg_q)
                    4'b1111: begin // SW
                        A   = AWADDR_reg_q[15:2];
                        DI  = WDATA_reg_q;
                        WEB = 4'b0000;
                        CS  = 1;
                        AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                    end

                    4'b0011: begin // SH
                        A = AWADDR_reg_q[15:2];
                        case (AWADDR_reg_q[1:0])
                            2'b00: begin
                                DI = {{16{1'b0}},{WDATA_reg_q[15:0]}};
                                WEB = 4'b1100;
                                CS = 1;
                                AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                            end
                            2'b10: begin
                                DI = { WDATA_reg_q[15:0], 16'd0 };
                                WEB = 4'b0011;
                                CS = 1;
                                AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                            end
                        endcase
                    end

                    4'b0001: begin // SB
                        A = AWADDR_reg_q[15:2];
                        case(AWADDR_reg_q[1:0])
                            2'b00: begin
                                DI = {{24{1'b0}},{WDATA_reg_q[7:0]}};
                                WEB = 4'b1110;
                                CS = 1;
                                AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                            end
                            2'b01: begin
                                DI = {{16{1'b0}},{WDATA_reg_q[7:0]},{8{1'b0}}};
                                WEB = 4'b1101;
                                CS = 1;
                                AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                            end
                            2'b10: begin
                                DI = {{8{1'b0}},{WDATA_reg_q[7:0]},{16{1'b0}}};
                                WEB = 4'b1011;
                                CS = 1;
                                AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                            end
                            2'b11: begin
                                DI = {{WDATA_reg_q[7:0]},{24{1'b0}}};
                                WEB = 4'b0111;
                                CS = 1;
                                AWADDR_reg_d = AWADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                            end
                        endcase
                    end
                        
                    default: begin
                    end	

                    endcase
                end
                default:;
                endcase
            end else;
        end

        WRITE_RESP: begin
            AWREADY = 0;
            BVALID  = 1;
            BID     = AWID_reg_q;

            if (AWADDR_reg_q > 32'hffff && AWADDR_reg_q <= 32'h1_ffff && AWSIZE_reg_q < 3'b011) begin
                // OK if address is correct
                BRESP = 2'b00;
            end else if(AWADDR_reg_q <= 32'hffff || AWSIZE_reg_q >= 3'b011) begin
                // ERR when wrong address
                BRESP = 2'b10;
            end else begin
                BRESP = 2'b11;
            end

            if (BREADY == 1) begin
                NXSTATE = INIT;
            end else begin
                NXSTATE = WRITE_RESP;
            end
        end


        READ_WAIT: begin
            AWREADY = 0;
            if (ARADDR_reg_q < 32'h2_0000 && ARSIZE_reg_q < 3'b011) begin
                unique case (ARBURST_reg_q) // Update BO based on OP and assert OE
                2'b00: begin // SINGLE
                    A  = ARADDR_reg_q[15:2];
                    CS = 1;
                    OE = 0;
                    DI = 0;
                end

                2'b01: begin //INCR
                    unique case (ARSIZE_reg_q)
                    3'b000: begin //LB 
                        A  = ARADDR_reg_q[15:2];
                        CS = 1;
                        DI = 0;
                        OE = 0;
                        ARADDR_reg_d = ARADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                    end
                            
                    3'b001: begin //LH
                        A = ARADDR_reg_q[15:2];
                        CS = 1;	
                        DI = 0;
                        OE = 0;
                        ARADDR_reg_d = ARADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                    end
                            
                    3'b010: begin // LW
                        A  = ARADDR_reg_q[15:2];
                        CS = 1;
                        DI = 0;
                        OE = 0;
                        ARADDR_reg_d = ARADDR_reg_q + (32'd1 << ARSIZE_reg_q);
                    end

                    default:;
                    endcase
                end
                default:;

                endcase
                ARLEN_reg_d = ARLEN_reg_q - 1;
                RVALID = 0;
                NXSTATE = READ_VALID;
                if (ARLEN_reg_d == 0) begin
                    RLAST_reg_d = 1;
                end else begin
                  RLAST_reg_d = 0;
                end
            end else begin
                Next_Counter = Counter + 1;
                if (ARADDR_reg_q <= 32'hffff && ARSIZE_reg_q >= 3'b011) begin
                    RRESP_reg_d = 2'b10;
                end else begin
                    RRESP_reg_d = 2'b11;
                end

                RVALID = 0;
                NXSTATE = READ_ERROR;

                if (ARLEN_reg_d == 0) begin
                  RLAST_reg_d = 1;
                end else begin
                  RLAST_reg_d = 0;
                end
            end
        end

        READ_VALID: begin
            RVALID    = 1;
            RLAST     = RLAST_reg_q;
            RRESP     = 2'b00;
            RID       = ARID_reg_q;
            CS        = 0;
            OE        = 1;
            RDATA     = DO;
            if (RREADY == 1 && RLAST_reg_q == 1) begin
                NXSTATE = READ_LAST;
            end else if(RREADY == 1 && RLAST_reg_q == 0) begin
                NXSTATE = READ_WAIT;
            end else begin
                NXSTATE = READ_VALID_WAIT;
            end
        end
            
        READ_VALID_WAIT: begin
            if (RREADY == 1 && RLAST_reg_q == 1) begin
                NXSTATE = READ_LAST;
            end else if (RREADY == 1 && RLAST_reg_q == 0) begin
                NXSTATE = READ_WAIT;
            end else begin
              NXSTATE = READ_VALID_WAIT;
            end
        end

        READ_ERROR: begin
            RVALID    = 1;
            RRESP     = RRESP_reg_q;
            RID       = ARID_reg_q;
            RLAST     = RLAST_reg_q;
            CS        = 1;
            OE        = 1;
            RDATA     = DO;
            
            if (RREADY == 1 && RLAST_reg_q == 1) begin
                NXSTATE = READ_LAST;
            end else if (RREADY == 1 && RLAST_reg_q == 0) begin
                NXSTATE = READ_WAIT;
            end else begin
                NXSTATE = READ_ERROR_WAIT;
            end
        end
            
        READ_ERROR_WAIT: begin
            if (RREADY == 1 && RLAST_reg_q == 1) begin
                NXSTATE = READ_LAST;
            end else if(RREADY == 1 && RLAST_reg_q == 0) begin
                NXSTATE = READ_WAIT;
            end else begin
                NXSTATE = READ_ERROR_WAIT;
            end
        end
            
        READ_LAST: begin
            RDATA   = DO;
            OE      = 1;
            CS      = 0;        
            RVALID  = 0;
            ARREADY = 0;
            RLAST   = 1;
            NXSTATE = INIT;
        end
            
        default: begin
        end
        endcase
    end

endmodule 