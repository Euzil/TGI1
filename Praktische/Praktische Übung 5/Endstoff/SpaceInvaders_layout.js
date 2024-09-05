
var lcd = new LCDModule(10, 10, IrqManager.getIrqFromName("PD"), {width: 16, height: 2}, 4.0);
var adc = new ADC(10, 120, IrqManager.getIrqFromName("ADC0"), 2.0);

new Button(160, 120, IrqManager.getIrqFromName("PB2"), Key.ArrowUp)

var width = lcd.dom.width();
lcd.dom.mousemove(function(e) {
    var value = Math.max(0, Math.min(e.offsetX, width)) / width;
    adc.dom.val(value * 3300 * 16/14);
    adc.dom.trigger('input');
})
