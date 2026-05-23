module sync_fifo
#(
    parameter DEPTH = 8, 
    parameter DWIDTH = 8
)

(
    input clk, 
    input rstn, //0=reset fifo and 1=normal operation

    input wr_en, //fifo writes data
    input rd_en, //fifo reads data

    input [7:0] din,
    output reg [7:0] dout,

    output full,
    output empty
);

reg [7:0] fifo [0:7];

reg [2:0] wptr;
reg [2:0] rptr;

reg [3:0] count;

always @(posedge clk) begin //write logic
    
    if(!rstn)
    begin
        wptr<=0; //start writing from 0 location again
    end

    else if(wr_en && !full) begin //write req fifo not full
        fifo[wptr]<=din;
        wptr<=wptr+1;
    end
end
always @(posedge clk)begin //read logic
    if(!rstn)
    begin
        rptr<=0;
        dout<=0;
    end

    else if(rd_en && !empty) begin 
        dout<=fifo[rptr];
        rptr<=rptr+1;
    end

    else if(!wr_en && rd_en && !empty)
    begin
        count <= count-1;
    end
end
    always @(posedge clk) begin
        if(!rstn) begin
            count<=0;
        end
        else if(wr_en && !rd_en && !full) begin
            count<=count+1;
        end
        end
        assign full=(count==8);
        assign empty=(count==0);
  
endmodule
