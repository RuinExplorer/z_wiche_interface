CREATE OR REPLACE PACKAGE BANINST1.Z_WICHE_INTERFACE
AS
    /***************************************************************************
    NAME:       Z_WICHE_INTERFACE
    PURPOSE:    Collection of tools for application and removal of WICHE
                passport transcript events.
    ***************************************************************************/
    PROCEDURE ZSPPASS (one_up_no IN NUMBER);
END Z_WICHE_INTERFACE;
/