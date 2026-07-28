// Test = top-level test case. Later, if you want MULTIPLE tests
// (e.g. test_random, test_directed_only), you'd make more classes like this.
class test;
    environment env;

    function new(virtual cache_if vif);
        env = new(vif);
    endfunction

    task run();
        env.run();
    endtask

    function void report();
        env.report();
    endfunction
endclass
