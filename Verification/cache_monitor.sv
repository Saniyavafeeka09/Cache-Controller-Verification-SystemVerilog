class monitor;
    virtual cache_if          vif;
    mailbox #(transaction)    drv2mon;
    mailbox #(result_pkt)     mon2scb;

    function new(virtual cache_if vif,
                 mailbox #(transaction) drv2mon,
                 mailbox #(result_pkt) mon2scb);
        this.vif     = vif;
        this.drv2mon = drv2mon;
        this.mon2scb = mon2scb;
    endfunction

    task run();
        transaction t;
        result_pkt  r;
        forever begin
            drv2mon.get(t);

            @(posedge vif.clk);   // outputs are registered -> valid after this edge
            #1;

            r           = new();
            r.req       = t;
            r.act_hit   = vif.hit;
            r.act_miss  = vif.miss;
            r.act_rdata = vif.cpu_read_data;

            mon2scb.put(r);
        end
    endtask
endclass
