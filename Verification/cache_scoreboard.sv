class scoreboard;
    mailbox #(result_pkt) mon2scb;

    // reference model (shadow copy, mirrors DUT logic)
    bit [7:0] mem_model   [0:255];
    bit [7:0] data_model  [0:3];
    bit [5:0] tag_model   [0:3];
    bit       valid_model [0:3];
    bit       dirty_model [0:3];

    int pass_count = 0;
    int fail_count = 0;

    function new(mailbox #(result_pkt) mon2scb);
        this.mon2scb = mon2scb;
        for (int i = 0; i < 256; i++) mem_model[i] = i[7:0];
        for (int i = 0; i < 4; i++) begin
            data_model[i]=0; tag_model[i]=0; valid_model[i]=0; dirty_model[i]=0;
        end
    endfunction

    task run();
        result_pkt r;
        forever begin
            mon2scb.get(r);
            check(r);
        end
    endtask

    task check(result_pkt r);
        bit [1:0] idx = r.req.addr[1:0];
        bit [5:0] tg  = r.req.addr[7:2];
        bit       exp_hit, exp_miss;
        bit [7:0] exp_rdata;

        if (r.req.rst) begin
            for (int i = 0; i < 4; i++) begin
                data_model[i]=0; tag_model[i]=0; valid_model[i]=0; dirty_model[i]=0;
            end
            return;
        end

        if (r.req.read) begin
            if (valid_model[idx] && tag_model[idx]==tg) begin
                exp_hit=1; exp_miss=0; exp_rdata=data_model[idx];
            end else begin
                exp_hit=0; exp_miss=1;
                if (valid_model[idx] && dirty_model[idx])
                    mem_model[{tag_model[idx], idx}] = data_model[idx];
                exp_rdata        = mem_model[r.req.addr];
                data_model[idx]  = mem_model[r.req.addr];
                tag_model[idx]   = tg;
                valid_model[idx] = 1;
                dirty_model[idx] = 0;
            end

            if (exp_hit===r.act_hit && exp_miss===r.act_miss && exp_rdata===r.act_rdata) begin
                pass_count++;
                $display("[SCB] PASS(READ) addr=%0h exp=%0h act=%0h", r.req.addr, exp_rdata, r.act_rdata);
            end else begin
                fail_count++;
                $display("[SCB] FAIL(READ) addr=%0h exp_hit=%0b act_hit=%0b exp_data=%0h act_data=%0h",
                           r.req.addr, exp_hit, r.act_hit, exp_rdata, r.act_rdata);
            end
        end
        else if (r.req.write) begin
            if (valid_model[idx] && tag_model[idx]==tg) begin
                exp_hit=1; exp_miss=0;
                data_model[idx]=r.req.wdata; dirty_model[idx]=1;
            end else begin
                exp_hit=0; exp_miss=1;
                if (valid_model[idx] && dirty_model[idx])
                    mem_model[{tag_model[idx], idx}] = data_model[idx];
                data_model[idx]=r.req.wdata; tag_model[idx]=tg;
                valid_model[idx]=1; dirty_model[idx]=1;
            end

            if (exp_hit===r.act_hit && exp_miss===r.act_miss) begin
                pass_count++;
                $display("[SCB] PASS(WRITE) addr=%0h", r.req.addr);
            end else begin
                fail_count++;
                $display("[SCB] FAIL(WRITE) addr=%0h exp_hit=%0b act_hit=%0b", r.req.addr, exp_hit, r.act_hit);
            end
        end
    endtask

    function void report();
        $display("=========================================");
        $display(" SCOREBOARD REPORT: PASS=%0d  FAIL=%0d", pass_count, fail_count);
        $display("=========================================");
    endfunction
endclass
