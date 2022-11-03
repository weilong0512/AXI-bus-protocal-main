//================================================
// Auther:      Yang Chun-Wen (Willie)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//=================================================
`include "AXI_define.svh"
`include "AW_mux.sv"
`include "AR_mux.sv"
`include "AW_decoder.sv"
`include "AR_decoder.sv"
`include "W_mux.sv"
`include "R_mux.sv"
`include "RRarbiter.sv"

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
	output logic  AWREADY_M1,
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic  WREADY_M1,
	//WRITE RESPONSE
	output logic  [`AXI_ID_BITS-1:0] BID_M1,
	output logic  [1:0] BRESP_M1,
	output logic  BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic  ARREADY_M0,
	//READ DATA0
	output logic  [`AXI_ID_BITS-1:0] RID_M0,
	output logic  [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic  [1:0] RRESP_M0,
	output logic  RLAST_M0,
	output logic  RVALID_M0,
	input RREADY_M0,
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic  ARREADY_M1,
	//READ DATA1
	output logic  [`AXI_ID_BITS-1:0] RID_M1,
	output logic  [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic  [1:0] RRESP_M1,
	output logic  RLAST_M1,
	output logic  RVALID_M1,
	input RREADY_M1,

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,
	
	//WRITE ADDRESS1
	output logic  [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic  [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic  [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic  [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic  [1:0] AWBURST_S1,
	output logic  AWVALID_S1,
	input AWREADY_S1,
	//WRITE DATA1
	output logic  [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic  [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic  WLAST_S1,
	output logic  WVALID_S1,
	input WREADY_S1,
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic  BREADY_S1,
	
	//READ ADDRESS0
	output logic  [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic  [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic  [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic  [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic  [1:0] ARBURST_S0,
	output logic  ARVALID_S0,
	input ARREADY_S0,
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic  RREADY_S0,
	//READ ADDRESS1
	output logic  [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic  [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic  [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic  [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic  [1:0] ARBURST_S1,
	output logic  ARVALID_S1,
	input ARREADY_S1,
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1 
	
);

    logic m0_arhs, m0_rhs;
    logic m1_arhs, m1_awhs, m1_whs, m1_rhs, m1_bhs;
    logic s0_arhs, s0_awhs, s0_whs, s0_rhs, s0_bhs;
    logic s1_arhs, s1_awhs, s1_whs, s1_rhs, s1_bhs;

    assign m0_arhs = ARREADY_M0 & ARVALID_M0;
    assign m0_rhs  = RREADY_M0 & RVALID_M0;
    assign m1_arhs = ARREADY_M1 & ARVALID_M1;
    assign m1_awhs = AWREADY_M1 & AWVALID_M1;
    assign m1_whs  = WREADY_M1 & WVALID_M1;
    assign m1_rhs  = RREADY_M1 & RVALID_M1;
    assign m1_bhs  = BREADY_M1 & BVALID_M1;
    assign s0_arhs = ARREADY_S0 & ARVALID_S0;
    assign s0_awhs = AWREADY_S0 & AWVALID_S0;
    assign s0_whs  = WREADY_S0 & WVALID_S0;
    assign s0_rhs  = RREADY_S0 & RVALID_S0;
    assign s0_bhs  = BREADY_S0 & BVALID_S0;
    assign s1_arhs = ARREADY_S1 & ARVALID_S1;
    assign s1_awhs = AWREADY_S1 & ARVALID_S1;
    assign s1_whs  = WREADY_S1 & WVALID_S1;
    assign s1_rhs  = RREADY_S1 & RVALID_S1;
    assign s1_bhs  = BREADY_S1 & BVALID_S1;

enum logic[4:0] {
    M0_TOP = 5'd1,
    M1_TOP,
    M0_VALID_R,
    M1_VALID_R,
    M1_VALID_W,
    S0_RREADY,
    S1_RREADY,
    S0_WREADY,
    S1_WREADY,
    S0_RVALID,
    S1_RVALID,
    S0_WVALID,
    S1_WVALID,
    S0_BREADY,
    S1_BREADY,
    S0_BVALID,
    S1_BVALID
} abt_s, abt_ns;

struct packed {
    logic [`AXI_IDS_BITS-1:0]  id;
    logic [`AXI_ADDR_BITS-1:0] addr;
    logic [`AXI_LEN_BITS-1:0]  len;
    logic [`AXI_SIZE_BITS-1:0] size;
    logic [1:0]                burst;
} aw_buf;

assign AWID_S0    = aw_buf.id;
assign AWADDR_S0  = aw_buf.addr;
assign AWLEN_S0   = aw_buf.len;
assign AWSIZE_S0  = aw_buf.size;
assign AWBURST_S0 = aw_buf.burst;
assign AWID_S1    = aw_buf.id;
assign AWADDR_S1  = aw_buf.addr;
assign AWLEN_S1   = aw_buf.len;
assign AWSIZE_S1  = aw_buf.size;
assign AWBURST_S1 = aw_buf.burst;


assign AWREADY_M1 = ((abt_s == M0_TOP) || (abt_s == M1_TOP));
assign ARREADY_M1 = ((abt_s == M0_TOP) || (abt_s == M1_TOP));
assign ARREADY_M0 = ((abt_s == M0_TOP) || (abt_s == M1_TOP));
assign WREADY_M1 = ((abt_s == S0_WREADY) ||(abt_s == S1_WREADY));

assign RREADY_S0 = (abt_s == S0_RREADY);
assign RREADY_S1 = (abt_s == S1_RREADY);
assign BREADY_S0 = (abt_s == S0_BREADY);
assign BREADY_S1 = (abt_s == S1_BREADY);


//aw hs and pass data in
always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        aw_buf.id    <= `AXI_IDS_BITS'd0;
        aw_buf.addr  <= `AXI_ADDR_BITS'd0;
        aw_buf.len   <= `AXI_LEN_BITS'd0;
        aw_buf.size  <= `AXI_SIZE_BITS'd0;
        aw_buf.burst <= 2'd0;
    end else begin
        // read in data when handshaking
        if (((abt_s == M0_TOP && !m0_arhs) || abt_s == M1_TOP ) && m1_awhs) begin
            aw_buf.id    <= { 4'd1, AWID_M1 };
            aw_buf.addr  <= AWADDR_M1;
            aw_buf.len   <= AWLEN_M1;
            aw_buf.size  <= AWSIZE_M1;
            aw_buf.burst <= AWBURST_M1;
        end
    end
end

always_comb begin : aw_decoder

	AWVALID_S0 = 1'b0;
	AWVALID_S1 = 1'b0;
    if(abt_s == M1_VALID_W) begin
        unique if (aw_buf.addr >= 32'h0002_0000) begin
            // dec err
            AWVALID_S0 = 1'b0;
            AWVALID_S1 = 1'b0;
        end else if (aw_buf.addr >= 32'h0001_0000 && aw_buf.addr < 32'h0002_0000) begin
            AWVALID_S1 = 1'b1;
            AWVALID_S0 = 1'b0;
        end else if (aw_buf.addr < 32'h0001_0000) begin
            AWVALID_S0 = 1'b0;
            AWVALID_S1 = 1'b1;
        end
    end
end



struct packed {
    logic [`AXI_DATA_BITS-1:0] data;
    logic [`AXI_STRB_BITS-1:0] strb;
    logic                      last;
} w_buf;


assign WDATA_S0 = w_buf.data;
assign WSTRB_S0 = w_buf.strb;
assign WLAST_S0 = w_buf.last;
assign WDATA_S1 = w_buf.data;
assign WSTRB_S1 = w_buf.strb;
assign WLAST_S1 = w_buf.last;

always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        w_buf.data <= `AXI_DATA_BITS'd0;
        w_buf.strb <= `AXI_STRB_BITS'd0;
        w_buf.last <= 1'b0;
    end else begin
        // read in data when handshaking
        if (m1_whs && (abt_s == S0_WREADY || abt_s == S1_WREADY)) begin
            w_buf.data <= WDATA_M1;
            w_buf.strb <= WSTRB_M1;
            w_buf.last <= WLAST_M1;
        end
    end
end


always_comb begin : w_decoder
    WVALID_S0 = 1'b0;
    WVALID_S1 = 1'b0;
    if(abt_s == S0_WVALID || abt_s == S1_WVALID) begin
        unique if (aw_buf.addr >= 32'h0002_0000) begin
            // dec err
            WVALID_S0 = 1'b0;
            WVALID_S1 = 1'b0;
        end else if (aw_buf.addr >= 32'h0001_0000 && aw_buf.addr < 32'h0002_0000) begin
            WVALID_S1 = 1'b1;
            WVALID_S0 = 1'b0;
        end else if (aw_buf.addr < 32'h0001_0000) begin
            WVALID_S0 = 1'b0;
            WVALID_S1 = 1'b1;
        end
    end
end





struct packed {
    logic [`AXI_ID_BITS-1:0]  id;
    logic [1:0]               resp;
} b_buf;

assign BID_M1   = b_buf.id[3:0];
assign BRESP_M1 = b_buf.resp;

always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        b_buf.id    <= `AXI_ID_BITS'd0;
        b_buf.resp  <= 2'd0;
    end else begin
        unique case (abt_s)
        S0_BREADY: begin
            if (s0_bhs) begin
                b_buf.id    <= BID_S0[3:0];
                b_buf.resp  <= BRESP_S0;
            end
        end
        S1_BREADY: begin
            if (s1_bhs) begin
                b_buf.id    <= BID_S1[3:0];
                b_buf.resp  <= BRESP_S1;
            end
        end
        default: begin
        end
        endcase
    end
end



struct packed {
    logic [`AXI_IDS_BITS-1:0]  id;
    logic [`AXI_ADDR_BITS-1:0] addr;
    logic [`AXI_LEN_BITS-1:0]  len;
    logic [`AXI_SIZE_BITS-1:0] size;
    logic [1:0]                burst;
} ar_buf;

// connect payload from buffer to output port directly
assign ARID_S0    = ar_buf.id;
assign ARADDR_S0  = ar_buf.addr;
assign ARLEN_S0   = ar_buf.len;
assign ARSIZE_S0  = ar_buf.size;
assign ARBURST_S0 = ar_buf.burst;
assign ARID_S1    = ar_buf.id;
assign ARADDR_S1  = ar_buf.addr;
assign ARLEN_S1   = ar_buf.len;
assign ARSIZE_S1  = ar_buf.size;
assign ARBURST_S1 = ar_buf.burst;

// AR is valid when state goes to ARVALID state

always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        ar_buf.id    <= `AXI_IDS_BITS'd0;
        ar_buf.addr  <= `AXI_ADDR_BITS'd0;
        ar_buf.len   <= `AXI_LEN_BITS'd0;
        ar_buf.size  <= `AXI_SIZE_BITS'd0;
        ar_buf.burst <= 2'd0;
    end else begin
        // read in data when handshaking
        unique case (abt_s)
        M0_TOP: begin
            priority if (m0_arhs) begin
                ar_buf.id    <= { 4'd0, ARID_M0 };
                ar_buf.addr  <= ARADDR_M0;
                ar_buf.len   <= ARLEN_M0;
                ar_buf.size  <= ARSIZE_M0;
                ar_buf.burst <= ARBURST_M0;
            end else if (m1_arhs) begin
                ar_buf.id    <= { 4'd1, ARID_M1 };
                ar_buf.addr  <= ARADDR_M1;
                ar_buf.len   <= ARLEN_M1;
                ar_buf.size  <= ARSIZE_M1;
                ar_buf.burst <= ARBURST_M1;
            end
        end

        M1_TOP: begin
            priority if (m1_arhs) begin
                ar_buf.id    <= { 4'd1, ARID_M1 };
                ar_buf.addr  <= ARADDR_M1;
                ar_buf.len   <= ARLEN_M1;
                ar_buf.size  <= ARSIZE_M1;
                ar_buf.burst <= ARBURST_M1;
            end else if (m0_arhs) begin
                ar_buf.id    <= { 4'd0, ARID_M0 };
                ar_buf.addr  <= ARADDR_M0;
                ar_buf.len   <= ARLEN_M0;
                ar_buf.size  <= ARSIZE_M0;
                ar_buf.burst <= ARBURST_M0;
            end
        end

        default: begin
        end
        endcase
    end
end

always_comb begin : ar_decoder
	ARVALID_S0 = 1'b0;
    ARVALID_S1 = 1'b0;
    if(abt_s == M1_VALID_R || abt_s == M0_VALID_R) begin
        unique if (ar_buf.addr >= 32'h0002_0000) begin
            // dec err
            ARVALID_S0 = 1'b0;
            ARVALID_S1 = 1'b0;
        end else if (ar_buf.addr >= 32'h0001_0000 && ar_buf.addr < 32'h0002_0000) begin
            ARVALID_S1 = 1'b1;
            ARVALID_S0 = 1'b0;
        end else if (ar_buf.addr < 32'h0001_0000) begin
            ARVALID_S0 = 1'b0;
            ARVALID_S1 = 1'b1;
        end
    end
end


struct packed {
    logic                      valid;
    logic [`AXI_ID_BITS-1:0]   id;
    logic [`AXI_DATA_BITS-1:0] data;
    logic [1:0]                resp;
    logic                      last;
} r_buf0, r_buf1;

// connect payload from buffer to output port directly
assign RID_M0   = r_buf0.id[3:0];
assign RDATA_M0 = r_buf0.data;
assign RRESP_M0 = r_buf0.resp;
assign RLAST_M0 = r_buf0.last;
assign RVALID_M0 = r_buf0.valid;
assign RID_M1   = r_buf1.id[3:0];
assign RDATA_M1 = r_buf1.data;
assign RRESP_M1 = r_buf1.resp;
assign RLAST_M1 = r_buf1.last;
assign RVALID_M1 = r_buf1.valid;

// R is valid when state goes to RVALID state

always_ff @(posedge ACLK or negedge ARESETn) begin
    if (!ARESETn) begin
        r_buf0.valid <= 1'b0;
        r_buf0.id    <= `AXI_ID_BITS'd0;
        r_buf0.data  <= `AXI_DATA_BITS'd0;
        r_buf0.resp  <= 2'd0;
        r_buf0.last  <= 1'b0;
        r_buf1.valid <= 1'b0;
        r_buf1.id    <= `AXI_ID_BITS'd0;
        r_buf1.data  <= `AXI_DATA_BITS'd0;
        r_buf1.resp  <= 2'd0;
        r_buf1.last  <= 1'b0;
    end else begin
        unique case(abt_s)
            S0_RREADY: begin
                if(s0_rhs) begin
                    unique case (RID_S0[7:4])
                    4'b0000: begin
                        r_buf0.valid <= 1'b1;
                        r_buf0.id    <= RID_S0[3:0];
                        r_buf0.data  <= RDATA_S0;
                        r_buf0.resp  <= RRESP_S0;
                        r_buf0.last  <= RLAST_S0;
                    end
                    4'b0001: begin
                        r_buf1.valid <= 1'b1;
                        r_buf1.id    <= RID_S0[3:0];
                        r_buf1.data  <= RDATA_S0;
                        r_buf1.resp  <= RRESP_S0;
                        r_buf1.last  <= RLAST_S0;
                    end
                    default: begin
                        // hit default master
                        r_buf0.valid <= 1'b0;
                        r_buf1.valid <= 1'b0;
                    end
                    endcase
                end
            end

            S1_RREADY:begin
                if(s1_rhs) begin
                    unique case (RID_S1[7:4])
                    4'b0000: begin
                        r_buf0.valid <= 1'b1;
                        r_buf0.id    <= RID_S1[3:0];
                        r_buf0.data  <= RDATA_S1;
                        r_buf0.resp  <= RRESP_S1;
                        r_buf0.last  <= RLAST_S1;
                    end
                    4'b0001: begin
                        r_buf1.valid <= 1'b1;
                        r_buf1.id    <= RID_S1[3:0];
                        r_buf1.data  <= RDATA_S1;
                        r_buf1.resp  <= RRESP_S1;
                        r_buf1.last  <= RLAST_S1;
                    end
                    default: begin
                        // hit default master
                        r_buf0.valid <= 1'b0;
                        r_buf1.valid <= 1'b0;
                    end
                    endcase
                end
            end
            S0_RVALID: begin
                if(m1_rhs || m0_rhs)begin
                    r_buf0.valid <= 1'b0;
                    r_buf1.valid <= 1'b0;
                end
            end

            S1_RVALID: begin
                if(m1_rhs || m0_rhs)begin
                    r_buf0.valid <= 1'b0;
                    r_buf1.valid <= 1'b0;
                end
            end


            
        endcase

        
    end
end

always_ff@(posedge ACLK, negedge ARESETn) begin
	if(!ARESETn) begin
		abt_s <= M0_TOP;
	end else begin
		abt_s <= abt_ns;
	end
end

always_comb begin
    unique case(abt_s)
        M0_TOP: begin
            priority if(m0_arhs) begin
                abt_ns = M0_VALID_R;
            end else if(m1_awhs) begin
                abt_ns = M1_VALID_W;
            end else if(m1_arhs) begin
                abt_ns = M1_VALID_R;
            end else begin
                abt_ns = M0_TOP;
            end
        end

        M1_TOP:begin
            priority if(m1_awhs) begin
                abt_ns = M1_VALID_W;
            end else if(m1_arhs) begin
                abt_ns = M1_VALID_R;
            end else if(m0_arhs) begin
                abt_ns = M0_VALID_R;
            end else begin
                abt_ns = M1_TOP;
            end
        end

        M0_VALID_R:begin
            unique if(s0_arhs) begin
                abt_ns = S0_RREADY;
            end else if(s1_arhs) begin
                abt_ns = S1_RREADY;
            end else begin
                abt_ns = M0_VALID_R;
            end
        end

        M1_VALID_W:begin
            unique if(s0_awhs) begin
                abt_ns = S0_WREADY;
            end else if(s1_awhs)begin
                abt_ns = S1_WREADY;
            end else begin
                abt_ns = M1_VALID_W;
            end
        end

        M1_VALID_R:begin
            unique if(s0_arhs) begin
                abt_ns = S0_RREADY;
            end else if(s1_arhs) begin
                abt_ns = S1_RREADY;
            end else begin
                abt_ns = M1_VALID_R;
            end
        end

        S0_WREADY:begin
            if(m1_whs) begin
                abt_ns = S0_WVALID;
            end else begin
                abt_ns = S0_WREADY;
            end
        end

        S1_WREADY:begin
            if(m1_whs) begin
                abt_ns = S1_WVALID;
            end else begin
                abt_ns = S1_WREADY;
            end
        end

        S0_WVALID:begin
            if(s0_whs) begin
                if(WLAST_S0) begin
                    abt_ns = S0_BREADY;
                end else begin
                    abt_ns = S0_WREADY;
                end
            end else begin
                abt_ns = S0_WVALID;
            end
        end

        S1_WVALID:begin
            if(s1_whs) begin
                if(WLAST_S1) begin
                    abt_ns = S1_BREADY;
                end else begin
                    abt_ns = S1_WREADY;
                end
            end else begin
                abt_ns = S1_WVALID;
            end
        end

        S0_BREADY:begin
            if(s0_bhs) begin
                abt_ns = S0_BVALID;
            end else begin
                abt_ns = S0_BREADY;
            end
        end

        S1_BREADY:begin
            if(s1_bhs) begin
                abt_ns = S1_BVALID;
            end else begin
                abt_ns = S1_BREADY;
            end
        end

        S0_BVALID:begin
            if(m1_bhs) begin
                abt_ns = M0_TOP;
            end else begin
                abt_ns = S0_BVALID;
            end
        end

        S1_BVALID:begin
            if(m1_bhs) begin
                abt_ns = M0_TOP;
            end else begin
                abt_ns = S1_BVALID;
            end
        end



        S0_RREADY:begin
            if(s0_rhs) begin
                abt_ns = S0_RVALID;
            end else begin
                abt_ns = S0_RREADY;
            end
        end

        S1_RREADY:begin
            if(s1_rhs) begin
                abt_ns = S1_RVALID;
            end else begin
                abt_ns = S1_RREADY;
            end
        end

        S0_RVALID:begin
            if(m0_rhs) begin
                if(RLAST_S0) begin
                    abt_ns = M1_TOP;
                end
                else begin
                    abt_ns = S0_RREADY;
                end
            end
            else if(m1_rhs) begin
                if(RLAST_S1) begin
                    abt_ns = M0_TOP;
                end
                else begin
                    abt_ns = S0_RREADY;
                end
            end
            else begin
                abt_ns = S0_RVALID;
            end
        end

        S1_RVALID:begin
            if(m0_rhs) begin
                if(RLAST_S1) begin
                    abt_ns = M1_TOP;
                end
                else begin
                    abt_ns = S1_RREADY;
                end
            end
            else if(m1_rhs) begin
                if(RLAST_S1) begin
                    abt_ns = M0_TOP;
                end
                else begin
                    abt_ns = S1_RREADY;
                end
            end
            else begin
                abt_ns = S1_RVALID;
            end
        end

    endcase
end






endmodule