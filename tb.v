module tb;

reg clk;
reg rstn;
reg wr_en;
reg rd_en;
reg [7:0] din;
wire [7:0] dout;
wire full;
wire empty;

sync_fifo uut(clk, rstn, wr_en, rd_en, din, dout, full, empty);

always #5 clk=~clk;

initial begin
    clk=0;
    rstn=0;
    wr_en=0;
    rd_en=0;
    din=0;
end


initial begin
    $monitor("TIME=%0t wr=%0b rd=%0b din=%h dout=%h full=%0b empty=%0b", 
        $time, wr_en, rd_en, din, dout, full, empty);
    end

initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

end

initial begin
    #20 rstn=1;

    wr_en=1; din=8'h11; #10;
    din=8'h22; #10;
    din=8'h33; #10;
    wr_en=0;

    #10;

    rd_en=1; #30;
    rd_en=0;

    #10 wr_en = 1; din = 8'h44; rd_en = 1; #10;
    wr_en = 0; rd_en = 0;

    #50 $finish;

    
end
endmodule