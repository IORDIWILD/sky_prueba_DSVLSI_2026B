<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a fully playable Blackjack game using a hardware Finite State Machine (FSM). The design is composed of three main parts:

Game Core (blackjack_core.v): Handles the game logic (dealing, hitting, standing, doubling, and settling). It uses a 16-bit Linear Feedback Shift Register (LFSR) to generate pseudo-random card values. It also tracks the player's balance and converts it to BCD (Binary-Coded Decimal) for display.

VGA Controller (vga_controller.v): Generates the standard 640x480 @ 60Hz synchronization signals (HSYNC, VSYNC) and tracks the current X/Y pixel coordinates.

VGA Renderer (blackjack_table.v): A combinational logic block that takes the current pixel coordinates and the game state to draw the table. It draws the green felt, white cards with red diamonds, and uses a custom 5x7 pixel font engine to display card ranks (2-10, J, Q, K, A) and the current balance.

## How to test

To play the game, you need to connect the VGA outputs to a monitor and use the input buttons to control the game.

Press the START button (ui[4]) to deal the initial 2 cards to the player and 1 card to the dealer.

Press HIT (ui[0]) to draw another card.

Press STAND (ui[1]) to end your turn and let the dealer draw cards until they reach 17 or higher.

Press DOUBLE (ui[2]) on your first turn to double your bet, draw exactly one more card, and automatically stand.

You can press RESET (ui[3]) at any time to restart the game and reset your balance to 500.

The game will display the result at the end of each round (Win, Lose, or Push) by updating the BALANCE counter at the bottom left of the screen.

## External hardware

Tiny VGA PMOD: Required to convert the digital R, G, B, HSYNC, and VSYNC signals into a standard VGA output.

VGA Monitor: Any standard monitor capable of displaying 640x480 resolution at 60Hz.

Push Buttons: 5 active-high push buttons are required for the inputs (HIT, STAND, DOUBLE, RESET, START).
