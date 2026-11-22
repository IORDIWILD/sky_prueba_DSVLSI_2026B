/*
 * Copyright (c) 2024 AmitChen1415
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_AmitChen1415 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path (unused)
    output wire [7:0] uio_out,  // IOs: Output path (unused)
    output wire [7:0] uio_oe,   // IOs: Enable path (unused)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock (replaces clk_basys)
    input  wire       rst_n     // reset_n - low to reset
);

    // ------------------------------------------------------------
    // Tiny Tapeout Standard Ports Setup
    // ------------------------------------------------------------
    // Tie off unused IO ports to prevent warnings and floating nets
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, uio_in, 1'b0};

    // ------------------------------------------------------------
    // Your Blackjack Core Instantiation
    // ------------------------------------------------------------
    
    // En tu código original usabas ~ui_in[3] como reset.
    // Lo mantenemos pero lo combinamos con el rst_n del sistema.
    wire sys_rst_n = rst_n & ~ui_in[3]; 

    wire clk_25mhz;
    
    // Divisor de reloj
    clk_div_25mhz divisor(
        .rst_n( sys_rst_n ),        
        .clk( clk ),
        .clk_div( clk_25mhz )
    );

    wire clk_in_rst_n_sync;

    // Botones
    wire start, hit, stand, double_bet;
    assign hit        = ui_in[0];
    assign stand      = ui_in[1];
    assign double_bet = ui_in[2];
    assign start      = ui_in[4];     

    // Señales internas del juego
    wire [9:0] user_balance;
    wire [5:0] game_user_total;
    wire [5:0] game_dealer_total;
    wire [2:0] game_state;
    wire [2:0] game_p_cards;
    wire [2:0] game_d_cards;
    wire       game_doubled;
    
    // Variables BCD para la tabla
    wire [3:0] bal_d3, bal_d2, bal_d1, bal_d0;

    // Cartas (salidas del core hacia la tabla)
    wire [3:0] dealer_card1, dealer_card2, dealer_card3, dealer_card4, dealer_card5;
    wire [3:0] player_card1, player_card2, player_card3, player_card4, player_card5; 

    // VGA signals
    wire hsync, vsync;
    wire [1:0] red, green, blue;

    // Supresión de warnings para variables no utilizadas (debug)
    wire _unused_internal = &{1'b0, user_balance,
                              game_user_total, game_dealer_total, game_state,
                              game_p_cards, game_d_cards, game_doubled};

    // ------------------------------------------------------------
    // Instanciación de los módulos de tu diseño
    // ------------------------------------------------------------
    
    // Renderizador de la tabla VGA
    blackjack_table gfx (
       .clk_25MHz    (clk_25mhz),
       .rst_n        (sys_rst_n),
       .vga_hsync    (hsync),
       .vga_vsync    (vsync),
       .vga_r        (red),
       .vga_g        (green),
       .vga_b        (blue),
       .dealer_card1 (dealer_card1),
       .dealer_card2 (dealer_card2),
       .dealer_card3 (dealer_card3),
       .dealer_card4 (dealer_card4),
       .dealer_card5 (dealer_card5),
       .player_card1 (player_card1),
       .player_card2 (player_card2),
       .player_card3 (player_card3),
       .player_card4 (player_card4),
       .player_card5 (player_card5),
       .bal_d3       (bal_d3),
       .bal_d2       (bal_d2),
       .bal_d1       (bal_d1),
       .bal_d0       (bal_d0)
    );

    // Lógica del juego
    blackjack_core game_inst (
        .clk            (clk_25mhz),
        .rst_n          (clk_in_rst_n_sync),
        .btn_hit        (hit),
        .btn_stand      (stand),
        .btn_double     (double_bet),
        .btn_start      (start),
        .user_total     (game_user_total),
        .dealer_total   (game_dealer_total),
        .balance        (user_balance),
        .bal_d3         (bal_d3),
        .bal_d2         (bal_d2),
        .bal_d1         (bal_d1),
        .bal_d0         (bal_d0),
        .dealer_card1_o (dealer_card1),
        .dealer_card2_o (dealer_card2),
        .dealer_card3_o (dealer_card3),
        .dealer_card4_o (dealer_card4),
        .dealer_card5_o (dealer_card5),
        .player_card1_o (player_card1),  
        .player_card2_o (player_card2),  
        .player_card3_o (player_card3),
        .player_card4_o (player_card4),
        .player_card5_o (player_card5),
        .state_dbg      (game_state),
        .p_cards_dbg    (game_p_cards),
        .d_cards_dbg    (game_d_cards),
        .doubled_dbg    (game_doubled),
        .rng_load       (1'b0),
        .rng_seed       (16'hACE1)
    );

    // Sincronizador de encendido
    pwrup_synchronizer pwrup_sync_inst (
        .clk_in            (clk_25mhz),
        .rst_n             (sys_rst_n),
        .clk_in_rst_n_sync (clk_in_rst_n_sync)
    );

    // ------------------------------------------------------------
    // Mapeo de salidas VGA a los pines de Tiny Tapeout
    // ------------------------------------------------------------
    assign uo_out[0] = red[1];
    assign uo_out[1] = green[1];
    assign uo_out[2] = blue[1];
    assign uo_out[3] = vsync;
    assign uo_out[4] = red[0];
    assign uo_out[5] = green[0];
    assign uo_out[6] = blue[0];
    assign uo_out[7] = hsync;

endmodule
