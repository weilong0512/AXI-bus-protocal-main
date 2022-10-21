`include "fixed_priority.sv"

module RR_ARBITER #(
    parameter REQ_WIDTH = 2;
)(
    input logic clk,
    input logic rst,
    input [1:0] BRESP, RRESP,
    input []
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] gnt
);
    logic [REQ_WIDTH-1:0] req_unmasked;    
    logic [REQ_WIDTH-1:0] req_masked;
    logic [REQ_WIDTH-1:0] mask_higher_pri_reqs;
    logic [REQ_WIDTH-1:0] grant_masked;
    logic [REQ_WIDTH-1:0] unmask_higher_pri_reqs;
    logic [REQ_WIDTH-1:0] grant_unmasked;
    logic no_req_masked;
    logic [REQ_WIDTH-1:0] pointer_reg;
    logic [REQ_WIDTH - 1:0] gnt;
    logic [REQ_WIDTH - 1:0] gnt_LOCK;

    /*
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] gnt
    */
    
    always_comb begin
        if(en) req_unmasked = req;
        else req_unmasked = req_unmasked; // 這裡compiler會修掉
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
            poiner_res <= {REQ_WIDTH{1'b1}};
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

            else pointer_reg <= unmask_higher_pri_reqs; // req locked 然後不change priority

        end
    end


    enum logic[1:0] {
        IDLE = 2'b00        
        READY = 2'b01,
        WRITE = 2'b10,
        READ = 2'b11

    } ARBITER_STATE, ARBITER_NEXTSTATE;  

    always_ff@(posedge clk, negedge rst) begin
        if (!rst) begin
            ARBITER_STATE <= IDLE ;
        end

        else begin
            ARBITER_STATE <= ARBITER_NEXTSTATE ;
        end
    end

    always_comb begin
        case (ARBITER_STATE)
            IDLE:begin
                gnt = 2'b00;
                ARBITER_NEXTSTATE = READY
            end

            READY:begin
                if (req != 0) begin
                    en = 0;
                    gnt = grant; // en = 0 grant 不會 change
                    if(AWVALID == 1) begin
                        ARBITER_NEXTSTATE = WRITE;
                    end

                    else if (ARVALID == 1) begin
                        ARBITER_NEXTSTATE = READ;
                    end
                end

                else begin
                    ARBITER_NEXTSTATE = READY; // 沒收到req
                end
            end

            WRITE:begin
                if(BRESP == 2'b00 && BRESP == 2'b01) begin
                    ARBITER_NEXTSTATE = READY;
                    en = 1;
                end
                // else if(BRESP == 2'b10 && BRESP == 2'b11) begin  這裡處理 第三第四種error 還沒實作進去
                //     ARBITER_NEXTSTATE = READY;
                // end
                else begin
                    ARBITER_NEXTSTATE = WRITE;
                end
            end

            READ:begin
                if(RRESP == 2'b00 && RRESP == 2'b01) begin
                    ARBITER_NEXTSTATE = READY;
                    en = 1;
                end
                // else if(BRESP == 2'b10 && BRESP == 2'b11) begin 這裡處理 第三第四種error 還沒實作進去
                //     ARBITER_NEXTSTATE = READY;
                // end
                else begin
                    ARBITER_NEXTSTATE = READ;
                end
            end
            default: 
        endcase
    end


    
    
endmodule