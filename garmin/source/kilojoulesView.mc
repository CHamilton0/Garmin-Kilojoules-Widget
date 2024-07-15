import Toybox.Graphics;
import Toybox.WatchUi;

class kilojoulesView extends WatchUi.View {
  var data as Data;
  var activeDegrees = 0;
  var centreX = 0;
  var centreY = 0;

  function initialize() {
    View.initialize();

    data = new Data();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    centreX = dc.getWidth() / 2;
    centreY = dc.getHeight() / 2;
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    activeDegrees = data.getActiveRatio().toFloat() * 360;
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);

    // Draw inactive kilojoules arc
    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(centreX, centreY, centreX, Graphics.ARC_COUNTER_CLOCKWISE, 90, 90 - activeDegrees.toFloat());
    // Draw resting bars
    dc.fillRectangle(centreX - 20, (3 * centreY / 2) - 55, 5, 75);
    dc.fillRectangle(centreX + 160, centreY + 25, 5, 30);

    // Draw active kilojoules arc
    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(centreX, centreY, centreX, Graphics.ARC_CLOCKWISE, 90, activeDegrees.toFloat());
    // Draw active bars
    dc.fillRectangle(centreX - 20, (centreY / 2) + 5, 5, 75);
    dc.fillRectangle(centreX + 160, centreY - 15, 5, 30);

    // Draw grey text
    dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawText(centreX, 15, Graphics.FONT_SYSTEM_XTINY, "Today", Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(centreX - 30, (centreY / 2) + 50, Graphics.FONT_SYSTEM_XTINY, "Active", Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(centreX - 30, (3 * centreY / 2) - 10, Graphics.FONT_SYSTEM_XTINY, "Resting", Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(centreX + 150, centreY + 25, Graphics.FONT_SYSTEM_XTINY, "Total", Graphics.TEXT_JUSTIFY_RIGHT);

    // Draw layout objects
    dc.fillRectangle(centreX, centreY / 2, 1, centreY + 25);

    // Draw kilojoules text
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(centreX - 30, centreY / 2, Graphics.FONT_MEDIUM, data.getActiveKj().format("%d"), Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(centreX - 30, (3 * centreY / 2) - 60, Graphics.FONT_MEDIUM, data.getInactiveKj().format("%d"), Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(centreX + 150, centreY - 25, Graphics.FONT_MEDIUM, data.getTotalKj().format("%d"), Graphics.TEXT_JUSTIFY_RIGHT);

  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {
  }

}
