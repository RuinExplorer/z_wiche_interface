CREATE OR REPLACE PACKAGE BODY BANINST1.Z_WICHE_INTERFACE
AS
    /***************************************************************************
    REVISIONS:
    Date      Author           Description
    --------  ---------------  ----------------------------------------------
    20170712  Carl Ellsworth   Created this package
    20170720  Carl Ellsworth   added conditional logic to avoid duplicate events
    ***************************************************************************/

    --GLOBAL VARIABLES
    gv_data_origin   VARCHAR2 (30) := 'WICHE_INTERFACE';

    /**
     * Creates a transcript event
     * <p>
     * With no aparent table api for SHREVNT, this procedure was created to
     * insert the events. Validation is not done within the procedure for
     * efficency. This must be done in the calling procedure.
     *
     * @param param_pidm            pidm of the student to add event
     * @param param_even_code       even code from stveven for event
     * @param param_levl_code       levl code from stvlevl for event
     * @param param_desc            open description of event
     * @param param_effective_date  date of event
     * @param param_activity_date   date event records was last updated
     * @param param_decision        open decision field
     * @param param_grade           open grade field
     * @param param_user_id         open user_id field
     */
    PROCEDURE p_insert_shrevnt (param_pidm              NUMBER,
                                param_even_code         VARCHAR2,
                                param_orig_code         VARCHAR2,
                                param_levl_code         VARCHAR,
                                param_desc              VARCHAR2,
                                param_effective_date    DATE,
                                param_activity_date     DATE,
                                param_decision          VARCHAR2,
                                param_grade             VARCHAR2,
                                param_user_id           VARCHAR2)
    AS
        lv_count   NUMBER (5) := 0;
    BEGIN
        SELECT COUNT (shrevnt_pidm)
          INTO lv_count
          FROM shrevnt
         WHERE     shrevnt_pidm = param_pidm
               AND shrevnt_even_code = param_even_code;

        IF lv_count < 1
        THEN
            INSERT INTO SHREVNT (shrevnt_pidm,
                                 shrevnt_even_code,
                                 shrevnt_orig_code,
                                 shrevnt_levl_code,
                                 shrevnt_desc,
                                 shrevnt_effective_date,
                                 shrevnt_activity_date,
                                 shrevnt_decision,
                                 shrevnt_grade,
                                 shrevnt_user_id,
                                 shrevnt_data_origin)
                 VALUES (param_pidm,
                         param_even_code,
                         param_orig_code,
                         param_levl_code,
                         param_desc,
                         param_effective_date,
                         param_activity_date,
                         param_decision,
                         param_grade,
                         param_user_id,
                         gv_data_origin);
        ELSE
            DBMS_OUTPUT.put_line (
                   'NOTE: pidm '
                || param_pidm
                || ' already has a passport record.');
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            DBMS_OUTPUT.put_line (
                   'NOTE: pidm '
                || param_pidm
                || ' already has a passport record.');
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line (
                'EXCEPTION in p_insert_shrevnt: ' || SQLERRM);
    END;

    /**
      * This procedure does batch student transcript events from a POPSEL.
      *
      */
    PROCEDURE p_batch_load (param_application       VARCHAR2,
                            param_selection         VARCHAR2,
                            param_creator_id        VARCHAR2,
                            param_user_id           VARCHAR2,
                            param_even_code         VARCHAR2,
                            param_orig_code         VARCHAR2,
                            param_levl_code         VARCHAR2,
                            param_desc              VARCHAR2,
                            param_decision          VARCHAR2,
                            param_grade             VARCHAR2,
                            param_effective_date    DATE,
                            param_activity_date     DATE DEFAULT SYSDATE)
    AS
        CURSOR cur_student (
            p_application    VARCHAR2,
            p_selection      VARCHAR2,
            p_creator_id     VARCHAR2,
            p_user_id        VARCHAR2)
        IS
            SELECT glbextr_key pidm
              FROM glbextr
             WHERE     glbextr_application = UPPER (param_application)
                   AND glbextr_selection = UPPER (param_selection)
                   AND glbextr_creator_id = UPPER (param_creator_id)
                   AND glbextr_user_id = UPPER (param_user_id);

        lv_count       NUMBER (5) := 0;

        lv_even_flag   NUMBER (1);
        lv_orig_flag   NUMBER (1);
    BEGIN
        --check for event code
        SELECT COUNT (stveven_code)
          INTO lv_even_flag
          FROM stveven
         WHERE stveven_code = param_even_code;

        --check for origination code
        SELECT COUNT (stvorig_code)
          INTO lv_orig_flag
          FROM stvorig
         WHERE stvorig_code = param_orig_code;

        IF (lv_even_flag = 1 AND lv_orig_flag = 1)
        THEN
            FOR i_student IN cur_student (param_application,
                                          param_selection,
                                          param_creator_id,
                                          param_user_id)
            LOOP
                --insert event
                p_insert_shrevnt (
                    param_pidm             => i_student.pidm,
                    param_even_code        => param_even_code,
                    param_orig_code        => param_orig_code,
                    param_levl_code        => param_levl_code,
                    param_desc             => param_desc,
                    param_effective_date   => param_effective_date,
                    param_activity_date    => param_activity_date,
                    param_decision         => param_decision,
                    param_grade            => param_grade,
                    param_user_id          => param_user_id);

                lv_count := lv_count + 1;
            END LOOP;

            DBMS_OUTPUT.put_line (
                'COMPLETION: ' || lv_count || ' records processed . ');
        ELSE
            DBMS_OUTPUT.put_line (
                'EXCEPTION: even_code or orig_code note found in spective validation table.');
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line ('EXCEPTION in p_batch_load: ' || SQLERRM);
    END;

    /**
      * This procedure is just a wrapper to allow the P_BATCH_LOAD
      * procedure to gather parameters from the JOBSUB entries
      *
      * @param one_up_no jobsub number used for parameter lookup
      */
    PROCEDURE ZSPPASS (one_up_no IN NUMBER)
    AS
        lv_application       VARCHAR2 (32);
        lv_selection         VARCHAR2 (32);
        lv_creator_id        VARCHAR2 (32);
        lv_user_id           VARCHAR2 (32);

        lv_even_code         VARCHAR2 (3);
        lv_orig_code         VARCHAR2 (4);
        lv_levl_code         VARCHAR2 (2);
        lv_desc              VARCHAR2 (30);
        lv_decision          VARCHAR2 (10);
        lv_grade             VARCHAR2 (6);
        lv_effective_date    DATE;
        lv_eff_date_string   VARCHAR2 (32);
    BEGIN
        BEGIN
            SELECT gjbprun_value
              INTO lv_application
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '01';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_application := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_selection
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '02';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_selection := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_creator_id
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '03';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_creator_id := NULL;
        END;


        BEGIN
            SELECT gjbprun_value
              INTO lv_user_id
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '04';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_user_id := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_even_code
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '05';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_even_code := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_orig_code
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '06';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_orig_code := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_levl_code
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '07';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_levl_code := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_desc
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '08';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_desc := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_decision
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '09';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_decision := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_grade
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '10';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_grade := NULL;
        END;

        BEGIN
            SELECT gjbprun_value
              INTO lv_effective_date
              FROM gjbprun
             WHERE     gjbprun_one_up_no = one_up_no
                   AND gjbprun_job = 'ZSPPASS'
                   AND gjbprun_number = '11';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lv_effective_date := NULL;
        END;

        IF lv_even_code IS NOT NULL AND lv_desc IS NOT NULL
        THEN
            lv_desc := NULL;
        END IF;

        p_batch_load (param_application      => lv_application,
                      param_selection        => lv_selection,
                      param_creator_id       => lv_creator_id,
                      param_user_id          => lv_user_id,
                      param_even_code        => lv_even_code,
                      param_orig_code        => lv_orig_code,
                      param_levl_code        => lv_levl_code,
                      param_desc             => lv_desc,
                      param_decision         => lv_decision,
                      param_grade            => lv_grade,
                      param_effective_date   => lv_effective_date);
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line ('EXCEPTION: ' || SQLERRM);
    END zsppass;
END Z_WICHE_INTERFACE;
/