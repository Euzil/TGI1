
for(let i=0; i<8; i++) 
    new LED(i*40 + 10, 10, IrqManager.getPinIrq(/* Port Index */ 1, /* Pin Index */ i));

new Button(50, 100, IrqManager.getIrqFromName("PD2"), Key.ArrowLeft)
new Button(100, 100, IrqManager.getIrqFromName("PD1"), Key.ArrowDown)
new Button(150, 100, IrqManager.getIrqFromName("PD0"), Key.ArrowRight)

