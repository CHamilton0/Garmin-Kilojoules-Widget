import Toybox.WatchUi;
import Toybox.Graphics;
using Toybox.Application;
import Toybox.System;
import Toybox.ActivityMonitor;
using Toybox.UserProfile;
import Toybox.Math;
import Toybox.Lang;
using Toybox.Time.Gregorian;

(:glance)
class WidgetGlanceView extends WatchUi.GlanceView {
  var activeKj = 0;
  var inactiveKj = 0;
  var activeRatio = 0;

  var barHeight = 0;
  var barStartY = 0;
  var titleStartY = 0;
  var numbersStartY = 0;

  function initialize() {
    GlanceView.initialize();

    var totalCalories = ActivityMonitor.getInfo().calories; // Total calories burnt for the day

    // Use profile data to calculate BMR and estimate inactive calories
    var profile = UserProfile.getProfile();
    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var age = today.year - profile.birthYear; // Age in years
    var weight = profile.weight / 1000; // Weight in kg
    var height = profile.height; // Height in cm
    
    var bmr = 10 * weight.toFloat() + 6.25 * height.toFloat() - 5 * age.toFloat() - 161;

    var timeThroughDay = (today.hour.toFloat() + (today.min.toFloat() / 60))/24;

    var totalCaloriesUsedSoFar = bmr.toFloat() * timeThroughDay.toFloat();

    var activeCalories = totalCalories.toFloat() - totalCaloriesUsedSoFar.toFloat();
    // Ensure active calories is at least 0
    activeCalories = activeCalories > 0 ? activeCalories : 0;

    activeKj = activeCalories.toFloat() * 4.2;
    var totalKj = totalCalories.toFloat() * 4.2;
    activeRatio = totalCalories == 0 ? 0 : activeCalories.toFloat() / totalCalories.toFloat();

    inactiveKj = totalKj - activeKj;
  }

  function onLayout(dc) {
    barHeight = dc.getHeight() / 8;
    barStartY = 7 * dc.getHeight() / 16;
    titleStartY = dc.getHeight() / 16;
    numbersStartY = 5 * dc.getHeight() / 8;
  }

  function onUpdate(dc) {
    // Draw active calories bar
    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    var activeWidth = dc.getWidth() * activeRatio.toFloat();
    dc.fillRectangle(0, barStartY, activeWidth, barHeight);

    // Draw other calories bar
    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
    var inactiveWidth = dc.getWidth() * (1 - activeRatio.toFloat());
    dc.fillRectangle(activeWidth, barStartY, inactiveWidth, barHeight);

    // Draw text
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(0, titleStartY, Graphics.FONT_SMALL, "Kilojoules", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(0, numbersStartY, Graphics.FONT_SMALL, activeKj.format("%d"), Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(dc.getWidth(), numbersStartY, Graphics.FONT_SMALL, inactiveKj.format("%d"), Graphics.TEXT_JUSTIFY_RIGHT);
  }

  function onHide() {
  }

  function onShow() {
  }
}
