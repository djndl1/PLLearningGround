' Section 1
CLS
TYPE employeeType
  firstname AS STRING * 30
  lastname AS STRING * 30
  age AS INTEGER
  wage AS SINGLE
END TYPE
DIM employee AS employeeType

' Section 2
PRINT "1.) Create new recordset"
PRINT "2.) View existing recordset"
INPUT "Which option?  ", selection%

' Section 3
IF selection% = 1 THEN
  INPUT "How many employees are in the company?  ", numRecords%
  recordLen# = LEN(employee)
  OPEN "database.dat" FOR RANDOM AS #1 LEN = recordLen#
    FOR i% = 1 TO numRecords%
      CLS
      INPUT "First name:  ", employee.firstname
      INPUT "Last name:   ", employee.lastname
      INPUT "Age:         ", employee.age
      INPUT "Wage:        ", employee.wage
      PUT #1, ,employee
    NEXT i%
    CLS
  CLOSE #1
  PRINT "Recordset creation complete"
  END
END IF

' Section 4
IF selection% = 2 THEN
  recordLen# = LEN(employee)
  OPEN "database.dat" FOR RANDOM AS #1 LEN = recordLen#
    format$ = "\                \,\                \   ###  $$##.##"
        PRINT "Last name          First name           Age  Wage   "
        PRINT "------------------ ------------------   ---  -------"
    DO WHILE NOT EOF(1)
      GET #1, ,employee     'Sorry about the length of this line!!!
      PRINT USING format$; employee.lastname; employee.firstname; employee.age; employee.wage
    LOOP
  CLOSE #1
  END
END IF
