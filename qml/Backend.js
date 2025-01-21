/* Name: Welcome
* Placeholder function in case any data needs to be accessed/read during startup
* Currently just displays "Welcome"  on the console
*/

function welcome()
{
    console.log("Welcome");
}

/* Name: getCategoryTime
* This function should return the total time spent in each quadrant
* the hardcoded values will need to be replaced by reading from the tables
*/ 

function getCategoryTime()
{
    var timecategory = new Object();
    timecategory[0] = 13.5;
    timecategory[1] = 20.9;
    timecategory[2] = 8.6;
    timecategory[3] = 8.2;
    return timecategory;
    
}

/* Name: getTasks
* This function should return the tasks for the user 
* the hardcoded values will need to be replaced by reading from the tasks tables
* The next step would be to add the date as a parameter or return the date along 
* with the Task so that the tasks will be displayed datewise
*/ 


function getTasks()
{
    var tasklists = new Object();
    tasklists[0] = "Meeting";
    tasklists[1] = "Travel";
    tasklists[2] = "Review";
    tasklists[3] = "Training";
    return tasklists;
}

/* Name: getSingleTime
* For future use
* This function should return the total time spent in each quadrant
* the hardcoded values will need to be replaced by reading from the tables
* for the quadrant passed in the parameter
*/ 

function getSingleTime(quadrant)
{
    var timedata = 0;
    switch (quadrant){
        case "Important, Urgent":
            timedata = 15.9;
            break;
        case "Important, Not Urgent":
            timedata = 20.6;
            break;
        case "Not Important, Urgent":
            timedata = 8.6;
            break;
        case "Not Important, Not Urgent":
            timedata = 8.2;
            break;                       
    }
    return timedata;
}
