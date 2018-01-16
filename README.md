# z_wiche_interface
POPSEL based application of WICHE Passport as Transcript Events for Banner by Ellucian.

## Overview
ZSPPASS is a custom Banner JOBSUB process that can batch apply transcript events. This can be used to generate WICHE Interstate Passport records for students. The process requires a populated POPSEL on which to apply the events.

#### Using ZSPPASS
- Start by loading your file of students to assign the advisor to to a POPSEL
  - Then go to the JOBSUB process ZSPPASS
- ZSPPASS has eleven parameters, the first four are used to identify the POPSEL, the last seven are parameters to designate the details of the individual events to apply
  - POPSEL Application
  - POPSEL Selection
  - POPSEL Creator ID
  - POPSEL User ID
  - Event Code - 3 character event code from STVEVEN (null if Description is populated)
  - Origin Code - 4 character origination code from STVORIG representing the source of the transcript event
  - Level Code - Level code from STVLEVL for the transcript evnets (UG is most common)
  - Description - 30 character open text description of the transcript event (null if Event Code is populated). USU established two Events codes, one visible for USU generated passports, one hidden for passports imported from other schools. As such, USU does not use the Description field.
  - OPE ID - OPE ID of the awarding Institution (technically the Decision field of the transcript event, we populating it with the 6-digit OPE ID code of the originating institution).
  - Grade - 6 character open text field - not used for the WICHE Interstate Passport
  - Effective Date - Effective date to record for the transcript event
- Once submitted, the generated .lis file will have a log of any errors encounters and a total number of records affected by the process.

#### Verifying a successful run or making changes
- GLAEXTR/GLIEXTR can be used to review the population of students in the POPSEL
- SHATCMT can be used to review/update/delete transcript events (second tab)
#### Hints Tips Tricks
- Due to the lengthy parameter list, a parameter set is recommended for runs that will be repeated.
- There is no batch way of reversing events made with this process. Use with caution.