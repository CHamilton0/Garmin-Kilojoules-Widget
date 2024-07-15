import Toybox.WatchUi;
import Toybox.Graphics;
using Toybox.Application;

(:glance)
class WidgetGlanceView extends WatchUi.GlanceView {
  var data as Data;

  var barHeight = 0;
  var barStartY = 0;
  var titleStartY = 0;
  var numbersStartY = 0;

  function initialize() {
    GlanceView.initialize();

    data = new Data();
  }

  function onLayout(dc) {
    barHeight = dc.getHeight() / 8;
    barStartY = 7 * dc.getHeight() / 16;
    titleStartY = dc.getHeight() / 16;
    numbersStartY = 5 * dc.getHeight() / 8;
  }

  function onUpdate(dc) {
    // Draw active kilojoules bar
    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    var activeWidth = dc.getWidth() * data.getActiveRatio().toFloat();
    dc.fillRectangle(0, barStartY, activeWidth, barHeight);

    // Draw other kilojoules bar
    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    var inactiveWidth = dc.getWidth() * (1 - data.getActiveRatio().toFloat());
    dc.fillRectangle(activeWidth, barStartY, inactiveWidth, barHeight);

    // Draw text
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(0, titleStartY, Graphics.FONT_SMALL, "Kilojoules", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(0, numbersStartY, Graphics.FONT_SMALL, data.getActiveKj().format("%d"), Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(dc.getWidth(), numbersStartY, Graphics.FONT_SMALL, data.getInactiveKj().format("%d"), Graphics.TEXT_JUSTIFY_RIGHT);
  }

  function onHide() {
  }

  function onShow() {
  }
}
