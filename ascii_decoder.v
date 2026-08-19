module ascii_decoder (
    input clk,
    input reset,
    input [7:0] rx_data,
    input rx_done,
    input run_state,
    output reg o_run_stop,
    output reg o_clear,
    output reg o_mode,
    output reg o_left,
    output reg o_right,
    output reg o_up,
    output reg o_down,
    output reg o_get,
    output reg o_save_load
);
    parameter get_idle = 2'd0, get_g = 2'd1, get_ge = 2'd2;
    reg [1:0] get_st;

    wire set = (rx_data == " ") || (rx_data == 8'h0D) || (rx_data == 8'h0A);


    always @(posedge clk, posedge reset) begin
        if (reset) begin
            o_run_stop <= 1'b0;
            o_clear <= 1'b0;
            o_mode <= 1'b0;
            o_left <= 1'b0;
            o_right <= 1'b0;
            o_up <= 1'b0;
            o_down <= 1'b0;
            o_get <= 1'b0;
            get_st <= get_idle;
            o_save_load <= 1'b0;
        end else begin
            o_run_stop <= 1'b0;
            o_clear <= 1'b0;
            o_mode <= 1'b0;
            o_left <= 1'b0;
            o_right <= 1'b0;
            o_up <= 1'b0;
            o_down <= 1'b0;
            o_get <= 1'b0;
            o_save_load <= 1'b0;

            if (rx_done) begin
                case (get_st)
                    get_idle: get_st <= (rx_data == "g") ? get_g : get_idle;
                    get_g:    get_st <= (rx_data == "e") ? get_ge : get_idle;
                    get_ge: begin
                        if (rx_data == "t") o_get <= 1'b1;
                        get_st <= get_idle;
                    end
                endcase


                case (rx_data)
                    "r": if (!run_state) o_run_stop <= 1'b1;
                    "s": if (run_state) o_run_stop <= 1'b1;
                    "c": o_clear <= 1'b1;
                    "m": o_mode <= 1'b1;
                    "a": o_left <= 1'b1;
                    "n": o_right <= 1'b1;
                    "u": o_up <= 1'b1;
                    "d": o_down <= 1'b1;
                    "v": o_save_load <= 1'b1;
                    default: ;
                endcase
            end
        end
    end
endmodule
