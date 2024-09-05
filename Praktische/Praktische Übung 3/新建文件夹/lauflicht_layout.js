
for(let i=0; i< 4; i++) 
    new LED(i*40 + 10, 10, IrqManager.getPinIrq(/* Port Index */ 3, /* Pin Index */ 3-i), "rgb(149,188,14)");

for(let i=4; i< 8; i++) 
    new LED(i*40 + 10, 10, IrqManager.getPinIrq(/* Port Index */ 0, /* Pin Index */ 11-i), "rgb(250,187,0)");

for(let i=0; i< 4; i++) 
    new LED((i+8)*40 + 10, 10, IrqManager.getPinIrq(/* Port Index */ 0, /* Pin Index */ 3-i), "rgb(228,32,50)");

new Button(10, 70, IrqManager.getIrqFromName("PD4"), Key.ArrowUp);
new Button(50, 70, IrqManager.getIrqFromName("PD5"), Key.ArrowDown);

new PrintPort(10, 130, IrqManager.getIrqFromName("PB"));