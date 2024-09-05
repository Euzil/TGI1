
for(let i=0; i<8; i++) 
    new LED(i*40 + 10, 10, IrqManager.getPinIrq(/* Port Index */ 3, /* Pin Index */ 7-i));

new ToggleButton(10, 70, IrqManager.getIrqFromName("PA7"), Key.KeyA);
new ToggleButton(50, 70, IrqManager.getIrqFromName("PA6"), Key.KeyS);
new ToggleButton(90, 70, IrqManager.getIrqFromName("PA5"), Key.KeyD);
new ToggleButton(130, 70, IrqManager.getIrqFromName("PA4"), Key.KeyF);
new ToggleButton(170, 70, IrqManager.getIrqFromName("PA3"), Key.KeyG);
new ToggleButton(210, 70, IrqManager.getIrqFromName("PA2"), Key.KeyH);
new ToggleButton(250, 70, IrqManager.getIrqFromName("PA1"), Key.KeyJ);
new ToggleButton(290, 70, IrqManager.getIrqFromName("PA0"), Key.KeyK);

new ToggleButton(10, 130, IrqManager.getIrqFromName("PB7"), Key.KeyQ);
new ToggleButton(50, 130, IrqManager.getIrqFromName("PB6"), Key.KeyW);
new ToggleButton(90, 130, IrqManager.getIrqFromName("PB5"), Key.KeyE);
new ToggleButton(130, 130, IrqManager.getIrqFromName("PB4"), Key.KeyR);
new ToggleButton(170, 130, IrqManager.getIrqFromName("PB3"), Key.KeyT);
new ToggleButton(210, 130, IrqManager.getIrqFromName("PB2"), Key.KeyU);
new ToggleButton(250, 130, IrqManager.getIrqFromName("PB1"), Key.KeyI);
new ToggleButton(290, 130, IrqManager.getIrqFromName("PB0"), Key.KeyO);

