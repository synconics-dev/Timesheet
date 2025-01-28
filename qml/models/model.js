.import QtQuick.LocalStorage 2.7 as Sql

/* Name: get_quadrant_difference
* This function will return total of spent time based on quadrants from timesheet entries
* 4 quadrants are as following
* 0 -> Urgent and Important
* 1 -> Import but not Urgent
* 2 -> Not Important but Urgent
* 3 -> Not Important and Not Urgent
*/

function get_quadrant_difference() {
    var db = Sql.LocalStorage.openDatabaseSync("timemanagement", "1.0", "Time Management", 1000000);
    var quadrant_data = {0: 0, 1:0, 2:0, 3:0};
    db.transaction(function(tx) {
        var fetch_quadrant = tx.executeSql('select quadrant_id, sum(unit_amount) as total from account_analytic_line_app group by quadrant_id');
        for (var quad=0; quad < fetch_quadrant.rows.length; quad++) {
            quadrant_data[fetch_quadrant.rows.item(quad).quadrant_id] = fetch_quadrant.rows.item(quad).total
        }
    });
    return quadrant_data;
}
