     H****************************************************************
     H*BCH01R得意先マスター一覧表
     H****************************************************************
     H DATEDIT(*YMD)
     H****************************************************************
     FTECSMP    IF   E           K DISK
     FQPRINT    O    F  132        PRINTER OFLIND(OVERFLOW)                     *
     D****************************************************************
     D** DEFINE
     D****************************************************************
     D KENSU           S              5  0
     D TTGEND          S             11  0
     C****************************************************************
     C*メインルーチン
     C****************************************************************
     C*見出し印刷
     C                   EXCEPT    HED01
     C*繰り返し
     C                   DOU       %EOF(TECSMP)
     C                   READ      TECSMP
     C                   IF        NOT %EOF(TECSMP)
     C                   EXSR      @TOKSB
     C                   ENDIF
     C                   ENDDO
     C*終了処理
     C                   EXCEPT    TTL01
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C*****************************************************************
     C*サブルーチン
     ******************************************************************
     C*明細処理
     C     @TOKSB        BEGSR
     C**
     C                   IF        OVERFLOW
     C                   EXCEPT    HED01
     C                   EVAL      OVERFLOW = *OFF
     C                   ENDIF
     C                   EXCEPT    DTL01
     C**
     C                   EVAL      KENSU  += 1
     C                   EVAL      TTGEND += CSGEND
     C**
     C                   ENDSR
     C*****************************************************************
     O*見出し行
     OQPRINT    E            HED01          2 02
     O                                            7 'BCH010R'
     O                                           20 '＊＊'
     O                                           42 '得意先マスター一覧表'
     O                                           48 '＊＊'
     O                       *DATE         Y     66
     O                       PAGE          Z     71
     O                                           75 '頁'
     O          E            HED01          1
     O                                            8 '得意先'
     O                                           26 '得意先名－漢字'
     O                                           37 '郵便'
     O                                           58 '信用限度額'
     O          E            HED01          2
     O                                            8 '番　号'
     O                                           37 '番号'
     O*明細行
     O          E            DTL01          2
     O                       CSCSCD               6
     O                       CSCSKJ              30
     O                       CSPOST              39
     O                       CSGEND        1     57
     O*最終計行
     O          E            TTL01
     O                                           10 '最終合計'
     O                                           29 'レコード件数'
     O                       KENSU         1     38
     O                       TTGEND        1     57
