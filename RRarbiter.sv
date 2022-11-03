`include "fixed_priority.sv"

module RR_ARBITER #(
    parameter REQ_WIDTH = 2
)(
    input logic clk,
    input logic rst,
    //input [1:0] BRESP, RRESP,
    // input logic AWVALID_M1, AWREADY_S0, AWREADY_S1,
    // input logic ARVALID_M0, ARVALID_M1, ARREADY_S0, ARREADY_S1,
    // input logic WVALID_M1, WVALID_M0, WREADY_S1, WREADY_S1,
    input logic BVALID_S0, BVALID_S1, BREADY_M1,
    input logic RVALID_S0, RVALID_S1, RREADY_M1, RREADY_M0,
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] gnt
);
    logic en;
    logic [REQ_WIDTH-1:0] req_unmasked;    
    logic [REQ_WIDTH-1:0] req_masked;
    logic [REQ_WIDTH-1:0] mask_higher_pri_reqs;
    logic [REQ_WIDTH-1:0] grant_masked;
    logic [REQ_WIDTH-1:0] unmask_higher_pri_reqs;
    logic [REQ_WIDTH-1:0] grant_unmasked;
    logic no_req_masked;
    logic [REQ_WIDTH-1:0] pointer_reg;
    logic [REQ_WIDTH - 1:0] grant;
    //logic [REQ_WIDTH - 1:0] gnt_LOCK;

    /*
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] gnt
    */
    
    assign en = (BVALID_S0 & BREADY_M1) | (BVALID_S1 & BREADY_M1) | (RVALID_S0 & RREADY_M1) | (RVALID_S1 & RREADY_M1) | (RVALID_S0 & RREADY_M0) | (RVALID_S1 & RREADY_M0);

    always_comb begin
        if(en) req_unmasked = req;
        else ; // 這裡compiler會修掉
    end

    // for unmasked part
    FIXED_PRI unmsked(
        .req(req_unmasked),
        .gnt(grant_unmasked),
        .pre_req_out(unmask_higher_pri_reqs)
    ); 

    // for masked part
    assign req_masked = req_unmasked & pointer_reg ;
    FIXED_PRI msked(
        .req(req_masked),
        .gnt(grant_masked),
        .pre_req_out(mask_higher_pri_reqs)
    ); 

    // Select grant for next
    assign no_req_masked = ~(|req_masked);
    assign grant = ({REQ_WIDTH{no_req_masked}} & grant_unmasked ) | grant_masked;

    //Update Pointer reg
    always @ (posedge clk, negedge rst) begin
        if(!rst) begin
            pointer_reg <= {REQ_WIDTH{1'b1}};
        end

        else begin
            if(en) begin

                if(|req_masked) begin // which arbiter was be used ???? 
                    pointer_reg <= mask_higher_pri_reqs;
                end

                else begin
                    if(|req) begin
                        pointer_reg <= unmask_higher_pri_reqs;
                    end

                    else begin
                        pointer_reg <= pointer_reg; // 沒有request pointer就不用動
                    end
                end
            end

            else pointer_reg <= pointer_reg; // req locked 然後不change priority

        end
    end

endmodule