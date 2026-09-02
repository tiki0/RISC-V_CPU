// These test cases were AI generated

`timescale 1ns/1ps
module tb;
    reg         clk;
    reg         we;
    reg  [4:0]  rs1, rs2, rd;
    reg  [31:0] wdata;
    wire [31:0] rd1, rd2;

    registers dut (
        .clk(clk), .we(we),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wdata(wdata), .rd1(rd1), .rd2(rd2)
    );

    integer errors = 0;

    // clock: period 10
    always #5 clk = ~clk;

    // write helper: set up a write, pulse through one posedge
    task write_reg;
        input [4:0]  addr;
        input [31:0] val;
        begin
            @(negedge clk);      // change inputs off-edge to avoid races
            we    = 1'b1;
            rd    = addr;
            wdata = val;
            @(posedge clk);      // write commits here
            @(negedge clk);
            we    = 1'b0;         // deassert
        end
    endtask

    // check rd1 for a given rs1 address (async read, combinational)
    task check_rd1;
        input [4:0]  addr;
        input [31:0] expected;
        begin
            rs1 = addr;
            #1;                  // let combinational read settle
            if (rd1 !== expected) begin
                $display("*** FAIL: read x%0d via rd1 = %h, expected %h", addr, rd1, expected);
                errors = errors + 1;
            end else
                $display("OK: x%0d via rd1 = %h", addr, rd1);
        end
    endtask

    task check_rd2;
        input [4:0]  addr;
        input [31:0] expected;
        begin
            rs2 = addr;
            #1;
            if (rd2 !== expected) begin
                $display("*** FAIL: read x%0d via rd2 = %h, expected %h", addr, rd2, expected);
                errors = errors + 1;
            end else
                $display("OK: x%0d via rd2 = %h", addr, rd2);
        end
    endtask

    initial begin
        clk = 0; we = 0; rs1 = 0; rs2 = 0; rd = 0; wdata = 0;
        @(negedge clk);

        $display("=== basic write then read ===");
        write_reg(5,  32'hDEADBEEF);
        check_rd1(5,  32'hDEADBEEF);

        write_reg(10, 32'h12345678);
        check_rd1(10, 32'h12345678);

        $display("=== both read ports independently ===");
        check_rd1(5,  32'hDEADBEEF);
        check_rd2(10, 32'h12345678);

        $display("=== same register on both ports ===");
        check_rd1(5,  32'hDEADBEEF);
        check_rd2(5,  32'hDEADBEEF);

        $display("=== x0 is hardwired zero (read) ===");
        check_rd1(0, 32'h00000000);
        check_rd2(0, 32'h00000000);

        $display("=== x0 cannot be written ===");
        write_reg(0, 32'hFFFFFFFF);   // attempt to write x0
        check_rd1(0, 32'h00000000);   // must still read 0
        $display("=== write-enable off does nothing ===");
        write_reg(7, 32'h11111111);        // establish a known value in x7
        check_rd1(7, 32'h11111111);        // confirm it's there
        // now attempt a "write" with we=0 — should NOT change x7
        @(negedge clk);
        we = 1'b0; rd = 7; wdata = 32'hCAFEBABE;
        @(posedge clk);
        @(negedge clk);
        check_rd1(7, 32'h11111111);        // still the old value, we=0 did nothing

        $display("=== overwrite an existing register ===");
        write_reg(5, 32'hAAAAAAAA);
        check_rd1(5, 32'hAAAAAAAA);

        $display("=== read-during-write: read sees OLD value same cycle ===");
        // x10 currently holds 0x12345678; begin writing new value, read same cycle
        @(negedge clk);
        we = 1'b1; rd = 10; wdata = 32'hBBBBBBBB;
        rs1 = 10;
        #1;
        // BEFORE the posedge, rd1 should still be the OLD value
        if (rd1 !== 32'h12345678) begin
            $display("*** FAIL: read-during-write rd1=%h, expected OLD 12345678", rd1);
            errors = errors + 1;
        end else
            $display("OK: read-during-write sees old value %h", rd1);
        @(posedge clk);   // write commits
        @(negedge clk);
        we = 1'b0;
        check_rd1(10, 32'hBBBBBBBB);  // now new value

        $display("");
        if (errors == 0) $display("ALL PASS");
        else             $display("%0d FAILURE(S)", errors);
        $finish;
    end
endmodule
