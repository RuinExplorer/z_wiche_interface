/* Formatted on 7/25/2017 2:49:11 PM (QP5 v5.300) */
--z_secured_procs entry

/*
PROCEDURE ZSPPASS (one_up_no IN NUMBER)
AS
BEGIN
   verify_access ('ZSPPASS'); -- call security
   baninst1.z_wiche_interface.ZSPPASS (one_up_no);
   revoke_access;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
*/

--JOBSUB Entries

--create banner object and set current version

INSERT INTO bansecr.guraobj (GURAOBJ_OBJECT,
                             GURAOBJ_DEFAULT_ROLE,
                             GURAOBJ_CURRENT_VERSION,
                             GURAOBJ_SYSI_CODE,
                             GURAOBJ_ACTIVITY_DATE,
                             GURAOBJ_CHECKSUM,
                             GURAOBJ_USER_ID)
     VALUES ('ZSPPASS',
             'BAN_DEFAULT_M',
             '9.1',                                                  --version
             'S',                                                     --module
             SYSDATE,
             NULL,
             'Z_CARL_ELLSWORTH');

--create GENERAL object base table entry

INSERT INTO GUBOBJS (GUBOBJS_NAME,
                     GUBOBJS_DESC,
                     GUBOBJS_OBJT_CODE,
                     GUBOBJS_SYSI_CODE,
                     GUBOBJS_USER_ID,
                     GUBOBJS_ACTIVITY_DATE,
                     GUBOBJS_HELP_IND,
                     GUBOBJS_EXTRACT_ENABLED_IND)
     VALUES ('ZSPPASS',
             'Batch Load Transcript Events',
             'JOBS',
             'S',                                                     --module
             'LOCAL',
             SYSDATE,
             'N',
             'B');

--create job definition

INSERT INTO gjbjobs (GJBJOBS_NAME,
                     GJBJOBS_TITLE,
                     GJBJOBS_ACTIVITY_DATE,
                     GJBJOBS_SYSI_CODE,
                     GJBJOBS_JOB_TYPE_IND,
                     GJBJOBS_DESC,
                     GJBJOBS_COMMAND_NAME,
                     GJBJOBS_PRNT_FORM,
                     GJBJOBS_PRNT_CODE,
                     GJBJOBS_LINE_COUNT,
                     GJBJOBS_VALIDATION)
         VALUES (
                    'ZSPPASS',
                    'Batch Load Transcript Events',
                    SYSDATE,
                    'S',                                              --module
                    'P',                                            --job type
                    'Creates student transcript events for the WICHE Passport in batch from a specified POPSEL.',
                    NULL,
                    NULL,
                    'DATABASE',
                    NULL,
                    NULL);

--create job parameter definition

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZSPPASS',
             '01',                                          --parameter number
             'POPSEL Application',                     --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the name of the POPSEL Application (functional area)', --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZSPPASS',
             '02',                                          --parameter number
             'POPSEL Selection',                       --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the name of the POPSEL Selection (POPSEL name)', --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZSPPASS',
             '03',                                          --parameter number
             'POPSEL Creator ID',                      --parameter description
             32,                                                      --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Enter the Banner ID of the POPSEL Creator',          --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZSPPASS',
                    '04',                                   --parameter number
                    'POPSEL User ID',                  --parameter description
                    32,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Enter the Banner ID of the POPSEL User with the correct population', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZSPPASS',
                    '05',                                   --parameter number
                    'Event Code',                      --parameter description
                    3,                                                --length
                    'C',                    --Character, Integer, Date, Number
                    'O',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Three character event code from STVEVEN (null if Description is populated)', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZSPPASS',
                    '06',                                   --parameter number
                    'Origin Code',                     --parameter description
                    4,                                                --length
                    'C',                    --Character, Integer, Date, Number
                    'R',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Four character origination code from STVORIG - source of transcript event', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZSPPASS',
             '07',                                          --parameter number
             'Level Code',                             --parameter description
             2,                                                       --length
             'C',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Level code from STVLEVL for transcript event',       --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZSPPASS',
                    '08',                                   --parameter number
                    'Description',                     --parameter description
                    30,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'O',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'Open text description of transcript event (null if Event Code is populated)', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
         VALUES (
                    'ZSPPASS',
                    '09',                                   --parameter number
                    'OPE ID',                          --parameter description
                    10,                                               --length
                    'C',                    --Character, Integer, Date, Number
                    'O',                                   --Optional/Required
                    'S',                                     --Single/Multiple
                    SYSDATE,
                    NULL,                                          --low range
                    NULL,                                         --high range
                    'OPE ID of the awarding Institution (Decision field of transcript event)', --help text
                    NULL,
                    NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZSPPASS',
             '10',                                          --parameter number
             'Grade',                                  --parameter description
             6,                                                       --length
             'C',                           --Character, Integer, Date, Number
             'O',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Open text grade of the transcript event',            --help text
             NULL,
             NULL);

INSERT INTO gjbpdef (GJBPDEF_JOB,
                     GJBPDEF_NUMBER,
                     GJBPDEF_DESC,
                     GJBPDEF_LENGTH,
                     GJBPDEF_TYPE_IND,
                     GJBPDEF_OPTIONAL_IND,
                     GJBPDEF_SINGLE_IND,
                     GJBPDEF_ACTIVITY_DATE,
                     GJBPDEF_LOW_RANGE,
                     GJBPDEF_HIGH_RANGE,
                     GJBPDEF_HELP_TEXT,
                     GJBPDEF_VALIDATION,
                     GJBPDEF_LIST_VALUES)
     VALUES ('ZSPPASS',
             '11',                                          --parameter number
             'Effective Date',                         --parameter description
             30,                                                      --length
             'D',                           --Character, Integer, Date, Number
             'R',                                          --Optional/Required
             'S',                                            --Single/Multiple
             SYSDATE,
             NULL,                                                 --low range
             NULL,                                                --high range
             'Effective date to record for the transcript event',  --help text
             NULL,
             NULL);

--create default parameter values

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '01',
             SYSDATE,
             NULL,
             'REGISTRAR',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '02',
             SYSDATE,
             NULL,
             'WICHE_PASSPORT',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '03',
             SYSDATE,
             NULL,
             'REGISTRAR_OFFICE',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '04',
             SYSDATE,
             NULL,
             'REGISTRAR_OFFICE',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '05',
             SYSDATE,
             NULL,
             'PNS',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '06',
             SYSDATE,
             NULL,
             'REGO',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '07',
             SYSDATE,
             NULL,
             'UG',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '08',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '09',
             SYSDATE,
             NULL,
             '003677',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '10',
             SYSDATE,
             NULL,
             '',
             NULL);

INSERT INTO gjbpdft (GJBPDFT_JOB,
                     GJBPDFT_NUMBER,
                     GJBPDFT_ACTIVITY_DATE,
                     GJBPDFT_USER_ID,
                     GJBPDFT_VALUE,
                     GJBPDFT_JPRM_CODE)
     VALUES ('ZSPPASS',
             '11',
             SYSDATE,
             NULL,
             '',
             NULL);

--create security grants to specific users

INSERT INTO bansecr.guruobj (GURUOBJ_OBJECT,
                             GURUOBJ_ROLE,
                             GURUOBJ_USERID,
                             GURUOBJ_ACTIVITY_DATE,
                             GURUOBJ_USER_ID,
                             GURUOBJ_COMMENTS,
                             GURUOBJ_DATA_ORIGIN)
     VALUES ('ZSPPASS',
             'BAN_DEFAULT_M',
             'BAN_STUDENT_C',
             SYSDATE,
             'Z_CARL_ELLSWORTH',
             NULL,
             NULL);


INSERT INTO bansecr.guruobj (GURUOBJ_OBJECT,
                             GURUOBJ_ROLE,
                             GURUOBJ_USERID,
                             GURUOBJ_ACTIVITY_DATE,
                             GURUOBJ_USER_ID,
                             GURUOBJ_COMMENTS,
                             GURUOBJ_DATA_ORIGIN)
     VALUES ('ZSPPASS',
             'BAN_DEFAULT_M',
             'S_REG_ADMIN_M',
             SYSDATE,
             'Z_CARL_ELLSWORTH',
             NULL,
             NULL);