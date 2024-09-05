for(let i=0; i < 8; i++) 
    new LED((7-i)*40 + 10, 70, IrqManager.getPinIrq(/* Port Index */ 1, /* Pin Index */ i), "rgb(60,169,213)");

for(let i=0; i < 8; i++) 
    new LED((7-i)*40 + 10, 130, IrqManager.getPinIrq(/* Port Index */ 2, /* Pin Index */ i), "rgb(228,32,50)");

var adc = new ADC(100, 10, IrqManager.getIrqFromName("ADC0"), 2.0);
adc.dom.val(0);

new ToggleButton(40, 10, IrqManager.getIrqFromName("PA1"), Key.ArrowUp);
