.import QtQuick.LocalStorage 2.7 as Sql

/* Name: get_quadrant_difference
* This function will return total of spent amount based on quadrants from timesheet entries
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
        var urgent_important = tx.executeSql('select sum(unit_amount) as total from account_analytic_line_app where quadrant_id=0');
        if (urgent_important.rows.length) {
            quadrant_data[0] = urgent_important.rows.item(0).total;
        }

        var important_not_urgent = tx.executeSql('select sum(unit_amount) as total from account_analytic_line_app where quadrant_id=1');
        if (important_not_urgent.rows.length) {
            quadrant_data[1] = important_not_urgent.rows.item(0).total;
        }

        var not_important_urgent = tx.executeSql('select sum(unit_amount) as total from account_analytic_line_app where quadrant_id=2');
        if (not_important_urgent.rows.length && not_important_urgent.rows.item(0).total != null) {
            quadrant_data[2] = not_important_urgent.rows.item(0).total;
        }

        var not_important_not_urgent = tx.executeSql('select sum(unit_amount) as total from account_analytic_line_app where quadrant_id=3');
        if (not_important_not_urgent.rows.length) {
            quadrant_data[3] = not_important_not_urgent.rows.item(0).total;
        }
    });
    return quadrant_data;
}
