class generator;
    mailbox #(transaction) gen2drv;
    int num_random_txns = 20;
    event   done;

    function new(mailbox #(transaction) gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        transaction t;

        // ---- Reset ----
        t = new(); t.rst=1; t.read=0; t.write=0; t.addr=0; t.wdata=0;
        gen2drv.put(t);

        // ---- Directed: write 0x04 then read it back (expect HIT) ----
        t = new(); t.rst=0; t.write=1; t.read=0; t.addr=8'h04; t.wdata=8'hAA;
        gen2drv.put(t);

        t = new(); t.rst=0; t.write=0; t.read=1; t.addr=8'h04; t.wdata=0;
        gen2drv.put(t);

        // ---- Directed: write 0x08 (same index, forces eviction of dirty 0x04) ----
        t = new(); t.rst=0; t.write=1; t.read=0; t.addr=8'h08; t.wdata=8'h55;
        gen2drv.put(t);

        // ---- Directed: reread 0x04 -> expect MISS, but memory holds 0xAA via writeback ----
        t = new(); t.rst=0; t.write=0; t.read=1; t.addr=8'h04; t.wdata=0;
        gen2drv.put(t);

        // ---- Random traffic for broader coverage ----
        repeat (num_random_txns) begin
            t = new();
            assert(t.randomize());
            t.rst = 0;
            gen2drv.put(t);
        end

        $display("[GEN] Done generating transactions.");
        ->done;
    endtask
endclass
