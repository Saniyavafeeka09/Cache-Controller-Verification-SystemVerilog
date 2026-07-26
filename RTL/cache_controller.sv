`timescale 1ns/1ps

module cache_controller
(
    input clk,
    input rst,

    input cpu_read,
    input cpu_write,

    input [7:0] cpu_address,
    input [7:0] cpu_write_data,

    output reg [7:0] cpu_read_data,

    output reg hit,
    output reg miss
);

    //----------------------------------------------------------
    // Cache Parameters
    //----------------------------------------------------------

    parameter CACHE_LINES = 4;
    parameter ADDRESS_WIDTH = 8;
    parameter DATA_WIDTH = 8;
    parameter INDEX_BITS = 2;
    parameter TAG_BITS = 6;

    //----------------------------------------------------------
    // Main Memory (256 Bytes)
    //----------------------------------------------------------

    reg [DATA_WIDTH-1:0] memory [0:255];

    //----------------------------------------------------------
    // Cache Arrays
    //----------------------------------------------------------

    reg [DATA_WIDTH-1:0] data_array [0:CACHE_LINES-1];
    reg [TAG_BITS-1:0] tag_array [0:CACHE_LINES-1];
    reg valid_array [0:CACHE_LINES-1];
    reg dirty_array [0:CACHE_LINES-1];

    //----------------------------------------------------------
    // Internal Signals
    //----------------------------------------------------------

    wire [INDEX_BITS-1:0] index;
    wire [TAG_BITS-1:0] tag;
    wire [7:0] old_address;

    integer i;

    //----------------------------------------------------------
    // Address Decoder
    //----------------------------------------------------------

    assign index = cpu_address[1:0];
    assign tag = cpu_address[7:2];
    assign old_address = {tag_array[index],index};

    //----------------------------------------------------------
    // Memory Initialization
    //----------------------------------------------------------

    initial
    begin

        for(i=0;i<256;i=i+1)
        begin
            memory[i]=i;
        end

        for(i=0;i<CACHE_LINES;i=i+1)
        begin
            data_array[i]=0;
            tag_array[i]=0;
            valid_array[i]=0;
            dirty_array[i]=0;
        end

    end

    //----------------------------------------------------------
    // Cache Controller
    //----------------------------------------------------------

    always @(posedge clk)
    begin

        if(rst)
        begin

            for(i=0;i<CACHE_LINES;i=i+1)
            begin
                data_array[i] <= 0;
                tag_array[i] <= 0;
                valid_array[i] <= 0;
                dirty_array[i] <= 0;
            end

            cpu_read_data <= 0;
            hit <= 0;
            miss <= 0;

        end

        else
        begin

            hit <= 0;
            miss <= 0;

            //--------------------------------------------------
            // CPU READ OPERATION
            //--------------------------------------------------

            if(cpu_read)
            begin

                //------------------------------------------
                // Cache Hit
                //------------------------------------------

                if(valid_array[index] &&
                   (tag_array[index] == tag))
                begin

                    hit <= 1'b1;
                    miss <= 1'b0;
                    cpu_read_data <= data_array[index];

                end

                //------------------------------------------
                // Cache Miss
                //------------------------------------------

                else
                begin

                    hit <= 1'b0;
                    miss <= 1'b1;

                    //----------------------------------
                    // Write Back if Dirty
                    //----------------------------------

                    if(valid_array[index] &&
                       dirty_array[index])
                    begin
                        memory[old_address]
                        <= data_array[index];
                    end

                    //----------------------------------
                    // Allocate New Block
                    //----------------------------------

                    data_array[index]
                    <= memory[cpu_address];

                    tag_array[index]
                    <= tag;

                    valid_array[index]
                    <= 1'b1;

                    dirty_array[index]
                    <= 1'b0;

                    //----------------------------------
                    // Send Data to CPU
                    //----------------------------------

                    cpu_read_data
                    <= memory[cpu_address];

                end

            end

            //--------------------------------------------------
            // CPU WRITE OPERATION
            //--------------------------------------------------

            if(cpu_write)
            begin

                //------------------------------------------
                // Cache Hit
                //------------------------------------------

                if(valid_array[index] &&
                   (tag_array[index] == tag))
                begin

                    hit <= 1'b1;
                    miss <= 1'b0;

                    //----------------------------------
                    // Update Cache Data
                    //----------------------------------

                    data_array[index] <= cpu_write_data;

                    //----------------------------------
                    // Set Dirty Bit
                    //----------------------------------

                    dirty_array[index] <= 1'b1;

                end

                //------------------------------------------
                // Cache Miss
                //------------------------------------------

                else
                begin

                    hit <= 1'b0;
                    miss <= 1'b1;

                    //----------------------------------
                    // Write Back Old Block
                    //----------------------------------

                    if(valid_array[index] &&
                       dirty_array[index])
                    begin
                        memory[old_address]
                        <= data_array[index];
                    end

                    //----------------------------------
                    // Write Allocate
                    //----------------------------------

                    data_array[index]
                    <= cpu_write_data;

                    tag_array[index]
                    <= tag;

                    valid_array[index]
                    <= 1'b1;

                    dirty_array[index]
                    <= 1'b1;

                end

            end
        end

    end

endmodule
