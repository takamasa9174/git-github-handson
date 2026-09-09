     H DATEDIT(*YMD)
     FTECSMP    IF   E           K DISK
     FINT03RD   CF   E             WORKSTN
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
     C                   WRITE     FMT90
     C                   WRITE     FMT01
     C                   EXFMT     FMT02
     C     *IN03         IFEQ      *ON
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
