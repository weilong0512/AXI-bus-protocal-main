`include "AXI_define.svh"

module Default_Handler (
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


`ifndef VERILATOR
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
        READ_ERROR,
        READ_LAST,
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
        end

        WRITE_RESP: begin
            AWREADY = 0;
            BVALID  = 1;
            BID     = AWID_reg_q;
            BRESP = 2'b11;

            if (BREADY == 1) begin
                NXSTATE = INIT;
            end else begin
                NXSTATE = WRITE_RESP;
            end
        end


        READ_WAIT: begin
            AWREADY = 0;
            ARLEN_reg_d = ARLEN_reg_q - 1;
            Next_Counter = Counter + 1;
            RRESP_reg_d = 2'b11;

            RVALID = 0;
            NXSTATE = READ_ERROR;

            if (ARLEN_reg_d == 0) begin
                RLAST_reg_d = 1;
            end else begin
                RLAST_reg_d = 0;
            end
        end

        READ_ERROR: begin
            RVALID    = 1;
            RRESP     = RRESP_reg_q;
            RID       = ARID_reg_q;
            RLAST     = RLAST_reg_q;
            RDATA     = 32'd0;
            
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