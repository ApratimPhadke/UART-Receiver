
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025 06:23:38 PM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/*module uart_rx #(
parameter clk_per_bit = 5280


    )(
    input wire clk ,
    input wire rx_serial ,
    output reg rx_d,
    output reg [7:0] rx_rec);
    
    
    localparam  s_IDLE = 3'b000;
    localparam  s_START = 3'b001;
    localparam  s_DATA = 3'b010;
    localparam  s_STOP = 3'b011;
    localparam  s_DONE = 3'b100;
    
    reg[2:0] r_SM_Main = s_IDLE ;
    reg[12:0] r_clk_count = 13'd0;
    reg[2:0] r_bit_index = 3'd0;
    reg[7:0] rx_byte = 8'd0;
    reg rx_data = 1'b1;
    
    always @(posedge clk) begin 
    rx_data<= rx_serial;
    case(r_SM_Main) 
    s_IDLE: begin 
    rx_d<=1'b0;
    r_clk_count<=13'd0;
    r_bit_index <= 3'd0;
    
    
    if(rx_data==1'b0)begin 
    r_SM_Main<=s_START;
    end 
    end 
    
    s_START: begin 
    if(r_clk_count == (clk_per_bit -1)/2)begin 
    r_clk_count <=13'd0;
    r_SM_Main <= s_DATA;
    end else begin 
    r_clk_count <= r_clk_count + 1'b1;
    end 
    end 
    
    s_DATA: begin 
    if(r_clk_count < clk_per_bit-1) begin 
    r_clk_count <= r_clk_count + 1'b1 ;
    end else begin 
    r_clk_count <= 13'd0;
    rx_byte [r_bit_index] <=rx_data;
    if(r_bit_index<3'd7)begin 
    r_bit_index <= r_bit_index + 1'b1;
    end else begin
    r_bit_index <= 3'd0;
    r_SM_Main <=  s_STOP;
    end 
    end 
    s_STOP: begin 
    if(r_clk_count < clk_per_bit -1)begin 
    r_clk_count <= r_clk_count +1'b1;
    end else begin 
    rx_d <= 1'b1 ;
    rx_rec <= rx_byte ;
    r_clk_count <= 13'd0;
    r_SM_Main <= s_DONE ;
    end 
    end 
    s_DONE: begin 
    s_SM_Main <= s_IDLE;
    rx_d <=1'b0;
    end 
    default :  r_SM_Main <= s_IDLE;
    endcase 
    end 
    
    endmodule
*/
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2025
// Design Name: UART Receiver
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: UART Receiver FSM
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_rx #(
    parameter clk_per_bit = 5280   // clocks per bit (depends on clk & baud)
)(
    input  wire       clk,        // system clock
    input  wire       rx_serial,  // UART RX input
    output reg        rx_d,       // data valid flag
    output reg [7:0]  rx_rec      // received byte
);

    // FSM states
    localparam  s_IDLE  = 3'b000;
    localparam  s_START = 3'b001;
    localparam  s_DATA  = 3'b010;
    localparam  s_STOP  = 3'b011;
    localparam  s_DONE  = 3'b100;
    
    reg [2:0]  r_SM_Main   = s_IDLE;
    reg [12:0] r_clk_count = 13'd0;
    reg [2:0]  r_bit_index = 3'd0;
    reg [7:0]  rx_byte     = 8'd0;
    reg        rx_data     = 1'b1;  // sampled input
    
    always @(posedge clk) begin 
        rx_data <= rx_serial;  // sample RX line

        case (r_SM_Main)
        
            // Wait for start bit
            s_IDLE: begin 
                rx_d        <= 1'b0;
                r_clk_count <= 13'd0;
                r_bit_index <= 3'd0;
                
                if (rx_data == 1'b0) begin  // start bit detected
                    r_SM_Main <= s_START;
                end
            end 

            // Validate start bit
            s_START: begin 
                if (r_clk_count == (clk_per_bit-1)/2) begin 
                    r_clk_count <= 13'd0;
                    r_SM_Main   <= s_DATA;
                end else begin 
                    r_clk_count <= r_clk_count + 1'b1;
                end 
            end 
            
            // Shift in data bits
            s_DATA: begin 
                if (r_clk_count < clk_per_bit-1) begin 
                    r_clk_count <= r_clk_count + 1'b1;
                end else begin 
                    r_clk_count <= 13'd0;
                    rx_byte[r_bit_index] <= rx_data; // LSB first
                    
                    if (r_bit_index < 3'd7) begin 
                        r_bit_index <= r_bit_index + 1'b1;
                    end else begin
                        r_bit_index <= 3'd0;
                        r_SM_Main   <= s_STOP;
                    end 
                end 
            end 

            // Check stop bit
            s_STOP: begin 
                if (r_clk_count < clk_per_bit -1) begin 
                    r_clk_count <= r_clk_count + 1'b1;
                end else begin 
                    rx_d        <= 1'b1;     // data valid
                    rx_rec      <= rx_byte;  // output byte
                    r_clk_count <= 13'd0;
                    r_SM_Main   <= s_DONE;
                end 
            end 

            // Cleanup and go idle
            s_DONE: begin 
                r_SM_Main <= s_IDLE;
                rx_d      <= 1'b0;
            end 
            
            default: r_SM_Main <= s_IDLE;
        endcase 
    end 
endmodule
