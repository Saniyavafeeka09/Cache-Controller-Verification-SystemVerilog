// Environment = agent + scoreboard, connected together.
class environment;
    agent      agt;
    scoreboard scb;

    function new(virtual cache_if vif);
        agt = new(vif);
        scb = new(agt.mon2scb);   // scoreboard listens on the agent's monitor mailbox
    endfunction

    task run();
        fork
            agt.run();
            scb.run();
        join_none
    endtask

    function void report();
        scb.report();
    endfunction
endclass
