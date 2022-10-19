`include "fixed_priority.sv"

module RR_ARBITER #(
    parameter REQ_WIDTH = 2;
)(
    input logic clk,
    input logic rst,
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] grant
);

    logic [REQ_WIDTH-1:0] req_masked;
    logic [REQ_WIDTH-1:0] mask_higher_pri_reqs;
    logic [REQ_WIDTH-1:0] grant_masked;
    logic [REQ_WIDTH-1:0] unmask_higher_pri_reqs;
    logic [REQ_WIDTH-1:0] grant_unmasked;
    logic no_req_masked;
    logic [REQ_WIDTH-1:0] pointer_reg;

    /*
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] gnt
    */
    
    // for unmasked part
    FIXED_PRI unmsked(
        .req(req),
        .gnt(grant_unmasked),
        .pre_req_out(unmask_higher_pri_reqs)
    ); 

    // for masked part
    assign req_masked = req & pointer_reg ;
    FIXED_PRI unmsked(
        .req(req_masked),
        .gnt(grant_masked),
        .pre_req_out(mask_higher_pri_reqs)
    ); 

    // Select grant for next
    assign no_req_masked = ~(|req_masked);
    assign grant = ({REQ_WIDTH{no_req_masked}} & grant_unmasked ) | grant_masked;

    //Update Pointer reg
    always @ (posedge clk) begin
        if(rst) begin
            poiner_res <= {REQ_WIDTH{1'b1}};
        end

        else begin

            if(|req_masked) begin // which arbiter was be used ????
                pointer_reg <= mask_higher_pri_reqs;
            end

            else begin
                if(|req) begin
                    pointer_reg <= unmask_higher_pri_reqs;
                end

                else begin
                    pointer_reg <= pointer_reg;
                end
            end

        end
    end


    
endmodule