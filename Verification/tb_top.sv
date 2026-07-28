`timescale 1ns/1ps

module tb_top;

    logic clk = 0;
    always #5 clk = ~clk;

    cache_if vif(clk);

    cache_controller dut (
        .clk            (clk),
        .rst            (vif.rst),
        .cpu_read       (vif.cpu_read),
        .cpu_write      (vif.cpu_write),
        .cpu_address    (vif.cpu_address),
        .cpu_write_data (vif.cpu_write_data),
        .cpu_read_data  (vif.cpu_read_data),
        .hit            (vif.hit),
        .miss           (vif.miss)
    );

    test t;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);

    vif.rst            = 1;
    vif.cpu_read       = 0;
    vif.cpu_write      = 0;
    vif.cpu_address    = 0;
    vif.cpu_write_data = 0;

    t = new(vif);
    t.run();

    #2000;

    t.report();
    $finish;
end

endmodule
