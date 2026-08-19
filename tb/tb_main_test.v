`timescale 1ns / 1ps

module tb_sensor_stopwatch_watch_uart_fifo;

    reg clk;
    reg reset;
    reg btn_L, btn_R, btn_UP, btn_DOWN;
    reg [4:0] sw;
    reg rx;
    reg echo;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;
    wire led;
    wire tx;
    wire trigger;
    wire dht11_io;

    reg dht_fake_drive;
    reg dht_fake_out;
    assign dht11_io = dht_fake_drive ? dht_fake_out : 1'bz;

    sensor_stopwatch_watch_uart_fifo U_DUT (
        .clk(clk),
        .reset(reset),
        .btn_L(btn_L),
        .btn_R(btn_R),
        .btn_UP(btn_UP),
        .btn_DOWN(btn_DOWN),
        .sw(sw),
        .rx(rx),
        .echo(echo),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data),
        .led(led),
        .tx(tx),
        .trigger(trigger),
        .dht11_io(dht11_io)
    );

    always #5 clk = ~clk;


    task press_btn_L;
        begin
            btn_L = 1;
            #1000000;  
            btn_L = 0;
            #100000;
        end
    endtask

    task press_btn_R;
        begin
            btn_R = 1;
            #1000000;
            btn_R = 0;
            #100000;
        end
    endtask

    task press_btn_UP;
        begin
            btn_UP = 1;
            #1000000;
            btn_UP = 0;
            #100000;
        end
    endtask

    task press_btn_DOWN;
        begin
            btn_DOWN = 1;
            #1000000;
            btn_DOWN = 0;
            #100000;
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        btn_L = 0; btn_R = 0; btn_UP = 0; btn_DOWN = 0;
        sw = 5'b00000;  
        rx = 1;          
        echo = 0;
        dht_fake_drive = 0;
        dht_fake_out = 1;

        #200;
        reset = 0;
        #200;

     
        press_btn_L;  

        #10000;   

       
        press_btn_DOWN;

        #10000;

  
        press_btn_L;  

     
        sw[4:3] = 2'b01;
        #100;
        press_btn_L;   

         
        sw[4:3] = 2'b10;
        #100;
     
        #500000;
        echo = 1;
        #100000;  
        echo = 0;

        #2000000;

  
        sw[4:3] = 2'b11;
        #100;

        #20000000;   

        #500000;
        $finish;
    end

endmodule


