new LED(10, 10, IrqManager.getPinIrq(/* Port Index */ 1, /* Pin Index */ 5), "rgb(228,32,50)");

new LED(50, 10, IrqManager.getPinIrq(/* Port Index */ 1, /* Pin Index */ 4), "rgb(149,188,14)");

for(let i = 0; i < 4; i++) 
    new LED(i*40 + 90, 10, IrqManager.getPinIrq(/* Port Index */ 1, /* Pin Index */ 3-i), "rgb(250,187,0)");

new Button(10, 70, IrqManager.getIrqFromName("PA7"), Key.ArrowUp, "rgb(0,75,90)");
new Button(50, 70, IrqManager.getIrqFromName("PA0"), Key.ArrowDown, "rgb(0,75,90)");

new PrintPort(10, 130, IrqManager.getIrqFromName("PD"));