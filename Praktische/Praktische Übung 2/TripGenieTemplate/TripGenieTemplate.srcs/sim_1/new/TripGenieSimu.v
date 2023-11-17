`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2019 11:52:00
// Design Name: 
// Module Name: TripGenieSimu
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


module TripGenieSimu();

// Varaiblen definieren:
    reg[3:0] counter;
    wire  hwy1;
    wire  hwy2;
    wire  hwy3;
    wire  hwy4;
    wire  hwy5;
    wire  hwy6;
    wire  Hooterville;
    wire  Mayberry;
    wire  SilerCity;
    wire  MtPilot;

// TripGenie instanziieren:
    TripGenies TripGenie(
        .Hooterville(Hooterville),
        .Mayberry(Mayberry),
        .SilerCity(SilerCity),
        .MtPilot(MtPilot),
        .Hwy1(hwy1),
        .Hwy2(hwy2),
        .Hwy3(hwy3),
        .Hwy4(hwy4),
        .Hwy5(hwy5),
        .Hwy6(hwy6)
        );
// weise counterbits ihren korrespondieren Städten zu
    assign Hooterville = counter[0]; 
    assign Mayberry = counter[1]; 
    assign SilerCity = counter[2]; 
    assign MtPilot = counter[3]; 
// initial Block, eigentliche Simulation
    initial begin
        counter = 0;
        #10;
// Alle Eingangskombinatione durchlaufen
        while(counter != 'b1111) begin
            counter = counter + 1;
            #10;
        end
    end
endmodule
