// This test case was AI generated (Opus 4.8)

`timescale 1ns/1ps
module tb;
    reg  [31:0] a, b;
    reg         signd;
    wire        lt;

    lessthan dut (.a(a), .b(b), .signd(signd), .lt(lt));

    integer errors = 0;

    // run one case: apply inputs, wait for combinational settle, check vs expected
    task run;
        input [31:0] ta, tb_;
        input        ts;
        input        expected;
        begin
            a = ta; b = tb_; signd = ts;
            #1;  // let combinational logic settle
            $display("signd=%b | a=%b (%0d) | b=%b (%0d) | lt=%b (expected %b) %s",
                     signd,
                     a, ts ? $signed(a) : a,
                     b, ts ? $signed(b) : b,
                     lt, expected,
                     (lt === expected) ? "OK" : "*** FAIL ***");
            if (lt !== expected) errors = errors + 1;
        end
    endtask

    initial begin
        $display("=== UNSIGNED cases (signd=0) ===");
        run(32'd5,          32'd10,         1'b0, 1'b1); // 5 < 10 -> 1
        run(32'd10,         32'd5,          1'b0, 1'b0); // 10 < 5 -> 0
        run(32'd7,          32'd7,          1'b0, 1'b0); // equal -> 0
        run(32'hFFFFFFFF,   32'd0,          1'b0, 1'b0); // 4294967295 < 0 -> 0

        $display("");
        $display("=== SIGNED cases (signd=1) ===");
        run(32'hFFFFFFFF,   32'd0,          1'b1, 1'b1); // -1 < 0 -> 1
        run(32'd0,          32'hFFFFFFFF,   1'b1, 1'b0); // 0 < -1 -> 0
        run(32'hFFFFFFFE,   32'hFFFFFFFF,   1'b1, 1'b1); // -2 < -1 -> 1
        run(32'h7FFFFFFF,   32'h80000000,   1'b1, 1'b0); // 2147483647 < -2147483648 -> 0

        $display("");
        if (errors == 0)
            $display("ALL PASS");
        else
            $display("%0d FAILURE(S)", errors);
        $finish;
    end
endmodule
