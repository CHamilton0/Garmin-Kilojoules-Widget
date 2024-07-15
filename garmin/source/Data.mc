import Toybox.System;
import Toybox.ActivityMonitor;
using Toybox.UserProfile;
import Toybox.Math;
import Toybox.Lang;
using Toybox.Time.Gregorian;
import Toybox.Lang;

(:glance)
class Data
{
    private var _activeKj = 0;
    private var _inactiveKj = 0;
    private var _activeRatio = 0;

    public function initialize()
    {
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

        _activeKj = activeCalories.toFloat() * 4.2;
        var totalKj = totalCalories.toFloat() * 4.2;
        _activeRatio = totalCalories == 0 ? 0 : activeCalories.toFloat() / totalCalories.toFloat();

        _inactiveKj = totalKj - _activeKj;
    }

    public function getActiveKj()
    {
        return _activeKj;
    }

    public function getInactiveKj()
    {
        return _inactiveKj;
    }

    public function getActiveRatio()
    {
        return _activeRatio;
    }

    public function getTotalKj()
    {
        return _activeKj + _inactiveKj;
    }
}
