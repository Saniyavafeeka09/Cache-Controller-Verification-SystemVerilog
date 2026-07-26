interface cache_if (input logic clk);
    logic        rst;
    logic        cpu_read;
    logic        cpu_write;
    logic [7:0]  cpu_address;
    logic [7:0]  cpu_write_data;
    logic [7:0]  cpu_read_data;
    logic        hit;
    logic        miss;
endinterface
