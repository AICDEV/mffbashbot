<?php
// Buttons file for Harrys My Free Farm Bash Bot (front end)
// Copyright 2016 Harun "Harry" Basalamah
// Parts of the graphics used are Copyright upjers GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
if ($farm == NULL)
 $farm = 1;
if ($farm == "runbot") {
 exec("script/wakeupthebot.sh " . $gamepath);
 $farm = 1;
}
$dogisset = is_file($gamepath . "/dodog.txt");
$lotisset = is_file($gamepath . "/dolot.txt");
if (is_file($gamepath . "/vehiclemgmt.txt")) {
 $Vehicle2Manage=file_get_contents($gamepath . "/vehiclemgmt.txt");
 $Vehicle2Manage=intval($Vehicle2Manage);
}

function Check4Vehicle($VehicleOption) {
 global $Vehicle2Manage;
 if ($Vehicle2Manage)
  if ($VehicleOption === $Vehicle2Manage)
   print " selected=\"selected\"";
}

$farmFriendlyName = ["1" => "Farm 1", "2" => "Farm 2", "3" => "Farm 3", "4" => "Farm 4", "5" => "Farm 5", "farmersmarket" => "der Bauernmarkt", "forestry" => "die B&auml;umerei", "foodworld" => "die Picknickarea", "city2" => "Teichlingen"];
print "<script type=\"text/javascript\" src=\"script/AJAXqueuefunctions.js\"></script>\n";
print "<small>";
system("cat " . $gamepath . "/../version.txt");
print " - " . $username . "</small>";
print "<h1>Dies ist " . $farmFriendlyName["$farm"] . "</h1>";
print "Letzte Laufzeit: <b><div id=\"lastruntime\" style=\"display:inline\">";
system("cat " . $gamepath . "/lastrun.txt");
print "</div></b> -- Der Bot ist gerade <b><div id=\"botstatus\" style=\"display:inline\">";
system("cat " . $gamepath . "/status.txt");
print "</div></b><form name=\"venueselect\" method=\"post\" action=\"showfarm.php\">\n";
print "<input type=\"hidden\" name=\"farm\" value=\"" . $farm . "\">\n";
print "<input type=\"hidden\" name=\"username\" value=\"" . $username . "\">";
for ($i = 1; $i < 6; $i++)
 print "<input type=\"image\" src=\"image/navi_farm" . $i . ".png\" class=\"navilink\" title=\"Farm " . $i . "\" name=\"" . $i . "\" onclick=\"document.venueselect.farm.value = '" . $i . "'; this.form.submit();\">\n";
print "<input type=\"image\" src=\"image/farmersmarket.png\" class=\"navilink\" title=\"Bauernmarkt\" name=\"farmersmarket\" onclick=\"document.venueselect.farm.value='farmersmarket'; document.venueselect.action='showfarmersmarket.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/forestry.png\" class=\"navilink\" title=\"B&auml;umerei\" name=\"forestry\" onclick=\"document.venueselect.farm.value='forestry'; this.form.action='showforestry.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/foodworld.png\" class=\"navilink\" title=\"Picknickarea\" name=\"foodworld\" onclick=\"document.venueselect.farm.value='foodworld'; this.form.action='showfoodworld.php'; this.form.submit()\">\n";
print "<input type=\"image\" src=\"image/navi_city2.png\" class=\"navilink\" title=\"Teichlingen\" name=\"city2\" onclick=\"document.venueselect.farm.value='city2'; this.form.action='showcity2.php'; this.form.submit()\">\n";
print "<input type=\"button\" name=\"runbot\" value=\"BOT&#13;&#10;START\" title=\"Bot-Durchlauf erzwingen\" onclick=\"document.venueselect.farm.value='runbot'; this.form.submit()\" style=\"text-align:center;\">&nbsp;\n";
print "<input type=\"button\" name=\"logon\" value=\"Anmeldung\" onclick=\"this.form.action='index.php'; this.form.submit()\">\n";
print "<br>";
print "<input type=\"checkbox\" id=\"dogtoggle\" name=\"dogtoggle\" onchange=\"saveMisc();\"  value=\"on\" " . (($dogisset) ? 'checked' : '') . ">&nbsp;Ben t&auml;gl. aktivieren&nbsp;&nbsp;<input type=\"checkbox\" id=\"lottoggle\" name=\"lottoggle\" onchange=\"saveMisc();\" value=\"on\" " . (($lotisset) ? 'checked' : '') . ">&nbsp;Los t&auml;gl. abholen\n";
print "&nbsp;<select id=\"vehiclemgmt\" name=\"vehiclemgmt\" onchange=\"saveMisc();\">";
print "<option value=\"sleep\">Sleep</option>\n";
print "<option value=\"1\""; Check4Vehicle(1); print ">Schafkarren</option>\n";
print "<option value=\"2\""; Check4Vehicle(2); print ">Traktor</option>\n";
print "<option value=\"3\""; Check4Vehicle(3); print ">LKW</option>\n";
print "<option value=\"4\""; Check4Vehicle(4); print ">Sportwagen</option>\n";
print "<option value=\"5\""; Check4Vehicle(5); print ">Truck</option></select>&nbsp;Autom. Transportfahrten\n";
print "</form><hr>\n";
?>
