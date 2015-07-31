PROCEDURE Milestones_obj
*LOCAL objMilestones 
loadData()
objMilestones = .f.
objMilestones = CreateObject("Milestones")

*formatmilestonesschedule()
SET CENTURY ON 
SET DATE DMY 
*startdate = DTOC({01.08.07})
*enddate = DTOC({02.08.07})
startdate = '01.07.07'
enddate = '02.08.07'
SELECT rv_ResursJrn 
GO TOP
objMilestones.Activate
LoadTasks()
**objMilestones.Template("Employee Attendance.MTP")
**1	objMilestones.Template("Hours Required, Available.MTP")
**	objMilestones.Template("Law Office Case Assignments.MTP")
**	objMilestones.Template("Manpower Forecast.MTP")
**	objMilestones.Template("Resource Costs, Status.MTP")
**!	objMilestones.Template("Resource Leveling.MTP")
*!*	objMilestones.Template("AccessTemplate.mtp")
objMilestones.SetTitle1( "«јЌя“ќ—“№ »Ќ—“–” “ќ–ј")
objMilestones.SetTitle2( "на объекте 7 пол€на")
objMilestones.SetEndDate( enddate )
objMilestones.SetStartDate( startdate )
objMilestones.SetSummaryBarDisplay(1)
objMilestones.Refresh
USE IN rv_ResursJrn 
*!*	KEYBOARD '{CTRL+F}'
READ EVENTS
 

ENDPROC 
******************************************
PROCEDURE loadData()
*OPEN DATABASE 
SET DATABASE TO BASIS
USE BASIS!rv_ResursJrn IN 0 
ENDPROC 
******************************************
PROCEDURE formatmilestonesschedule()
   * FormatMilestones Schedule
   objmilestones.Activate
   objmilestones.use20columns
   objmilestones.setlegendheight(0)
   For x = 1 To 10
      objmilestones.setcolumnproperty( x, "Smartcolumn", "none")
      objmilestones.setcolumnproperty( x, "Width", 0)
      objmilestones.setcolumnproperty( x, "ColumnHeadingLine1", "")
      objmilestones.setcolumnproperty( x, "ColumnHeadingLine2", "")
      objmilestones.setcolumnproperty( x, "HeadingBackgroundColor", 11)
      objmilestones.setcolumnproperty( x, "TextAlign", 1)
   Next 
   objmilestones.settoolboxsymbolproperty( 1, "DatePosition", 13)
   objmilestones.settoolboxsymbolproperty( 2, "DatePosition", 13)
   objmilestones.setcolumnproperty( 1, "Width", 1)
   objmilestones.setcolumnproperty( 1, "ColumnHeadingLine1", "Manager")
 
   objmilestones.setcolumnproperty( 2, "Width", 1.6)
   objmilestones.setcolumnproperty( 2, "ColumnHeadingLine1", "Task")
   objmilestones.setcolumnproperty( 2, "Indent", 0.2)
   objmilestones.setcolumnproperty( 2, "TextAlign", 0)
    
   objmilestones.setcolumnproperty( 11, "Width", 1)
   objmilestones.setcolumnproperty( 11, "ColumnHeadingLine1", "Year 1")
   objmilestones.setcolumnproperty( 11, "ColumnHeadingLine2", "Funding")
   
   objmilestones.setcolumnproperty( 12, "Width", 1)
   objmilestones.setcolumnproperty( 12, "ColumnHeadingLine1", "Year 2")
   objmilestones.setcolumnproperty( 12, "ColumnHeadingLine2", "Funding")
   objmilestones.SetSummaryBarDisplay(0)
 ENDPROC 
 
PROCEDURE CreateSchedule()
LOCAL schedulestartdate ,schedulefinishdate 
schedulestartdate = "12/31/2399"
schedulefinishdate = "1/1/1100"

* this function updates the schedule using data from a table

With objmilestones
    ' Locate first record in selected Access table
    SELECT rv_ResursJrn 
	GO TOP

    *check Milestones object and see if it has been used.
    *are there any tasks?  If so, delete and make object
    *ready for new user's new table selection
       numpages = .getnumberofpages
      If x > 1 
         For x = numpages To 1
            .setcurrentpage x
            .deletecurrentpage
         Next x
      Else
         numberoftasklines = .getnumberoflines
         If numberoftasklines > 1 Then .deletecurrentpage
      EndIf
      
      
      *color the rows differently depending upon which table is selected
      For x = 0 To 2
         Select Case Milestones1.selectedtable
         Case "table1"
         .SetScheduleGridlinesAndShades x, -1, 0, 15, 0, 4, 0
         Case "table2"
         .SetScheduleGridlinesAndShades x, -1, 0, 16, 0, 4, 0
         Case "table3"
         .SetScheduleGridlinesAndShades x, -1, 0, 17, 0, 4, 0
       End Select
      Next x
      
      
      *Display the tasks
      TaskNumber = 0
      SCAN 

        *On Error GoTo done
        *Use Milestones Etc. OLE Automation calls to add symbols to the schedule
        StartDate = Format(rstTable1!StartDate, "mm/dd/yy")
        xDatediff = DateDiff("d", StartDate, schedulestartdate)
        If xDatediff > 0 Then schedulestartdate = StartDate
        
        finishdate = Format(rstTable1!EndDate, "mm/dd/yy")
        xDatediff = DateDiff("d", finishdate, schedulefinishdate)
        If xDatediff < 0 
        schedulefinishdate = finishdate
        ENDIF
        TaskNumber = TaskNumber + 1

        .AddSymbol( TaskNumber, StartDate, 1, 1, 2)
        .AddSymbol( TaskNumber, finishdate, 2, 1, 2)
        .SetOutlineLevel( TaskNumber, rstTable1!OutlineLevel)
         *Add information to the task columns
        .PutCell( TaskNumber, 1, rstTable1!Manager)
        .PutCell( TaskNumber, 2, rstTable1!Task)
        .PutCell( TaskNumber, 11, "$" + Str(rstTable1!Fundingyear1))
        .PutCell( TaskNumber, 12, "$" + Str(rstTable1!Fundingyear2))
         .refreshtask( TaskNumber)
         *Move to the next record
       ENDSCAN    
   
   * Put up a title and set the schedule's start and end dates
        If TaskNumber > 1  
        .setlinesperpage = TaskNumber
        ENDIF
        .SetTitle1 = title
        .SetTitle2 = "Access Example"
       * .setlinesperpage = TaskNumber
        *.SetStartAndEndDates( schedulestartdate, schedulefinishdate)
         .Refresh()
        
   * Create a bitmap with the new schedule
     .savebitmap( "c:\milestones.bmp")
 
   * pause to give bitmap time to save before going on
   *  timeout
   WAIT WINDOW ' ∆дем чего-то ...' TIMEOUT 5
     
     
 End With

RETURN 
   
ENDPROC 
*******************************
PROCEDURE LoadTasks
LOCAL StartTm, numTask,startHr, startMn
numTask = 1
SELECT rv_ResursJrn 
SCAN
	startTm = SUBSTR(TTOC(NVL(rv_ResursJrn.usestart,DATETIME())),1,10)
	startHr = VAL(SUBSTR(TTOC(NVL(rv_ResursJrn.usestart,DATETIME())),11,2))
	startMn = VAL(SUBSTR(TTOC(NVL(rv_ResursJrn.usestart,DATETIME())),14,2))
	*objMilestones.AddTaskUsingDuration( 1, "7/12/1997", 2, 5, 2, 2, 65, "Day", 12, 0, "Create Using Days")
	*objMilestones.AddTaskUsingDuration( 2, "9/11/1997", 2, 5, 2, 2, 65, "Day", 12, 0, "Create Using Days")
	*objMilestones.AddTaskUsingDuration( 3, "7/12/1997", 2, 5, 2, 2, 480, "Hour", 12, 0, "Create Using Hours")
	**objMilestones.AddTaskUsingDuration( 4, "9/11/1997", 2, 5, 2, 2, 480, "„ас", 12, 0, "—оздано с использованием часов")
	**objMilestones.AddTaskUsingDuration( numTask , startTm , 2, 5, 2, 2, 480, "„ас", 12, 0, "—оздано с использованием часов")
	*objMilestones.AddTaskUsingDuration( 5, "2/1/1997", 2, 5, 2, 2, 4800, "Minute", 12, 0, "Create Using Minutes")
	objMilestones.AddTaskUsingDuration( 1 , startTm , 1, 6, 0, 2, rv_ResursJrn.UseMinute, "Minute", startHr , startMn , "—оздано с использованием минут")
	numTask = numTask+ 1
ENDS
