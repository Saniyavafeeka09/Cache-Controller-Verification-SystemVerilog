class transaction;
    rand bit       rst;
    rand bit       read;
    rand bit       write;
    rand bit [7:0] addr;
    rand bit [7:0] wdata;

    // never randomize read & write high at the same time
    constraint c_one_op { !(read && write); }

    function transaction copy();
        copy      = new();
        copy.rst  = this.rst;
        copy.read = this.read;
        copy.write= this.write;
        copy.addr = this.addr;
        copy.wdata= this.wdata;
    endfunction

    function void display(string tag);
        $display("[%0s] rst=%0b read=%0b write=%0b addr=%0h wdata=%0h",
                   tag, rst, read, write, addr, wdata);
    endfunction
endclass

// carries the transaction PLUS the DUT's actual response, for scoreboard use
class result_pkt;
    transaction req;
    bit         act_hit;
    bit         act_miss;
    bit [7:0]   act_rdata;
endclass
