module FIXED_PRI#(
    parameter REQ_WIDTH = 2
)(
    input logic[REQ_WIDTH - 1:0] req,
    output logic[REQ_WIDTH - 1:0] pre_req_out,
    output logic[REQ_WIDTH - 1:0] gnt
);

    logic[REQ_WIDTH - 1:0] pre_req;

    always_comb begin
        
        pre_req[0] = 0;
        gnt[0] = 0;

        for(int i = 1; i < REQ_WIDTH; i = i + 1) begin
            gnt[i] = req[i] & !pre_req[i-1];
            pre_req[i] = req[i] | pre_req[i-1];
        end
        pre_req_out = pre_req;
    end


endmodule