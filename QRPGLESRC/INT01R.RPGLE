     H DATEDIT(*YMD)
     FTECSMP    IF   E           K DISK
     FINT01RD   CF   E             WORKSTN
     C                   DO        *HIVAL
     C                   WRITE     FMT90
     C                   EXFMT     FMT01
     C     *IN03         IFEQ      *ON
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C*
     C     X1BANG        CHAIN     TECSMP                             60
     C     *IN60         IFEQ      *OFF
     C                   MOVEL     CSCSKJ        X1CSKJ
     C                   MOVEL     CSPOST        X1POST
     C                   MOVEL     CSADR1        X1ADR1
     C                   MOVEL     CSADR2        X1ADR2
     C                   MOVEL     CSTELE        X1TELE
     C                   MOVEL     CSTIKU        X1TIKU
     C                   WRITE     FMT90
     C                   WRITE     FMT01
     C                   EXFMT     FMT02
     C     *IN03         IFEQ      *ON
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
