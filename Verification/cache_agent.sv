// Agent = generator + driver + monitor, wired together with mailboxes.
// This is the reusable "unit" that talks to one interface.
class agent;
    virtual cache_if vif;

    generator gen;
    driver    drv;
    monitor   mon;

    mailbox #(transaction) gen2drv;
    mailbox #(transaction) drv2mon;
    mailbox #(result_pkt)  mon2scb;   // exposed so env can hand it to scoreboard

    function new(virtual cache_if vif);
        this.vif = vif;

        gen2drv = new();
        drv2mon = new();
        mon2scb = new();

        gen = new(gen2drv);
        drv = new(vif, gen2drv, drv2mon);
        mon = new(vif, drv2mon, mon2scb);
    endfunction

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
        join_none
    endtask
