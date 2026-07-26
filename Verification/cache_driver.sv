class driver;
    virtual cache_if        vif;
    mailbox #(transaction)  gen2drv;
    mailbox #(transaction)  drv2mon;

    function new(virtual cache_if vif,
                 mailbox #(transaction) gen2drv,
                 mailbox #(transaction) drv2mon);
        this.vif     = vif;
        this.gen2drv = gen2drv;
        this.drv2mon = drv2mon;
    endfunction

    task run();
        transaction t;
        forever begin
            gen2drv.get(t);

            @(negedge vif.clk);
            vif.rst            <= t.rst;
            vif.cpu_read       <= t.read;
            vif.cpu_write      <= t.write;
            vif.cpu_address    <= t.addr;
            vif.cpu_write_data <= t.wdata;

            drv2mon.put(t);   // tell monitor what was just driven
        end
    endtask
endclass
