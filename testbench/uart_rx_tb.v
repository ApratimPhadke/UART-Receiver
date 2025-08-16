`timescale 1ns / 1ps

module uart_rx_tb;

    // Clock = 50 MHz → 20ns period
    parameter CLK_PERIOD  = 20;
    parameter BAUD_RATE   = 9600;
    parameter CLKS_PER_BIT = 5208;   // 50e6 / 9600 ≈ 5208

    // DUT signals
    reg clk;
    reg rx_serial;
    wire rx_d;
    wire [7:0] rx_rec;

    // Instantiate DUT
    uart_rx #(.clk_per_bit(CLKS_PER_BIT)) uut (
        .clk(clk),
        .rx_serial(rx_serial),
        .rx_d(rx_d),
        .rx_rec(rx_rec)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Task to send UART byte
    task UART_WRITE_BYTE;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rx_serial <= 1'b0;
            #(CLKS_PER_BIT * CLK_PERIOD);

            // Data bits (LSB first)
            for (i=0; i<8; i=i+1) begin
                rx_serial <= data[i];
                #(CLKS_PER_BIT * CLK_PERIOD);
            end

            // Stop bit
            rx_serial <= 1'b1;
            #(CLKS_PER_BIT * CLK_PERIOD);
        end
    endtask

    // Test sequence
    initial begin
        // Init
        clk = 0;
        rx_serial = 1;   // idle high
        #(100*CLK_PERIOD);

        // Send a few bytes
        UART_WRITE_BYTE(8'hA5); // 1010_0101
        #(CLKS_PER_BIT * CLK_PERIOD * 2);

        UART_WRITE_BYTE(8'h3C); // 0011_1100
        #(CLKS_PER_BIT * CLK_PERIOD * 2);

        UART_WRITE_BYTE(8'hF0); // 1111_0000
        #(CLKS_PER_BIT * CLK_PERIOD * 5);

        $stop;
    end

    // Optional debug print
    always @(posedge clk) begin
        if (rx_d) begin
            $display("Time=%t : Received Byte = %h",$time,rx_rec);
        end
    end

endmodule
