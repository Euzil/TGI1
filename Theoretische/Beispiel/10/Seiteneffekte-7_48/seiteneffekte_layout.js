
for(let i=0; i<8; i++) 
    new LED(i*40 + 10, 10, IrqManager.getPinIrq(/* Port Index */ 1, /* Pin Index */ i), "rgb(149,188,14)");

