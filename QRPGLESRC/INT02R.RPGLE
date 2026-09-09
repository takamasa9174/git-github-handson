     H************************************************************************
     H** PGM ID    - INT02R
     H**     TITLE -受注入力(SFL)
     H************************************************************************
     H DATEDIT(*YMD)
     F*******************************************************
     F** FILE DESCRIPTION
     F*******************************************************
     FTEITMP    IF   E           K DISK
     FTEJUTP    UF A E           K DISK
     FINT02RD   CF   E             WORKSTN
     F                                     SFILE(SFL01:#RRN01)
     F                                     INFDS(D#INF)
     D*******************************************************
     D** ARRAY  / FIELD DEFINE
     D*******************************************************
     D ERR             S             60    DIM(3) CTDATA PERRCD(1)
     D #RRN01          S              4  0
     D #CTL            S              3
     D*******************************************************
     D** FEED BACK INFO
     D*******************************************************
     D D#INF           DS
     D  W#LC                 370    371B 0
     D  W#TOP                378    379B 0
     C*******************************************************
     C** MAIN ROUTINE
     C*******************************************************
     C     #CTL          CASEQ     'HED'         @HED
     C     #CTL          CASEQ     'DTL'         @DTL
     C     #CTL          CASEQ     'END'         @END
     C                   ENDCS
     C*******************************************************
     C** 指示画面
     C*******************************************************
     C     @HED          BEGSR
     C**指示画面表示
     C                   EVAL      *IN41 = *OFF
     C                   WRITE     FMT90
     C                   EXFMT     FMT01
     C                   EXSR      @RST
     C                   SELECT
     C** F3=終了
     C                   WHEN      *IN03 = *ON
     C                   EVAL      #CTL  = 'END'                                * --> END
     C**実行キー
     C                   OTHER
     C                   EXSR      @CHKH                                        * INP CHECK
     C                   IF        *IN60 = *OFF                                 * NO ERR
     C                   EXSR      @SETSF                                       * SFL DATA SET
     C                   EVAL      #CTL  = 'DTL'                                * --> DTL
     C                   ENDIF
     C                   ENDSL
     C**
     C                   ENDSR
     C*******************************************************
     C** データ処理画面
     C*******************************************************
     C     @DTL          BEGSR
     C**応答画面表示
     C                   EVAL      *IN41 = *ON
     C                   MOVEA     '11'          *IN(33)
     C                   EVAL      *IN36 = *ON
     C                   WRITE     FMT90
     C                   WRITE     FMT01
     C                   EXFMT     CTL01
     C                   EVAL      *IN36 = *OFF
     C                   MOVEA     '00'          *IN(33)
     C**
     C                   EXSR      @RST
     C                   EVAL       H1RCDN = W#TOP                              * SFLRCDNBR
     C                   SELECT
     C** F3=終了
     C                   WHEN      *IN03 = *ON
     C                   EVAL      #CTL  = 'END'                                * --> END
     C** F12=前画面
     C                   WHEN      *IN12 = *ON
     C                   EVAL      #CTL  = 'HED'                                * --> HED
     C**実行キー
     C                   OTHER
     C                   EXSR      @CHKD                                        * INP CHECK
     C** エラー無くF5=処理
     C                   IF        *IN60 = *OFF   AND                           * NO ERR
     C                             *IN05 = *ON
     C                   EXSR      @PRC
     C                   EVAL      #CTL  = 'HED'                                * --> HED
     C                   ENDIF
     C                   ENDSL
     C**
     C                   ENDSR
     C*******************************************************
     C** 入力チェックHEADER
     C*******************************************************
     C     @CHKH         BEGSR
     C**
     C**入力必須チェック
     C                   IF        X1BANG = *ZERO
     C                   EVAL      X9MSG = ERR(1)
     C                   MOVEA     '11'          *IN(60)
     C**
     C                   ELSE
     C     X1BANG        CHAIN(N)  TEJUTP
     C                   IF        NOT %FOUND(TEJUTP)
     C                   EVAL      X1MODE = '登録'
     C                   ELSE
     C                   EVAL      X1MODE = '変更'
     C                   ENDIF
     C                   ENDIF
     C**
     C                   ENDSR
     C*******************************************************
     C** 入力チェックDETAIL
     C*******************************************************
     C     @CHKD         BEGSR
     C**
     C                   DO        15            X                 2 0
     C                   MOVEA     '00'          *IN(62)
     C     X             CHAIN     SFL01
     C                   IF        %FOUND(INT02RD)
     C                   IF        Y1HINB = *BLANK
     C                   CLEAR                   SFL01
     C                   ELSE
     C                   EXSR      @CHKSF
     C                   ENDIF
     C                   UPDATE    SFL01
     C                   ENDIF
     C                   ENDDO
     C**
     C                   ENDSR
     C*******************************************************
     C** 入力チェック(SFL)
     C*******************************************************
     C     @CHKSF        BEGSR
     C**
     C**品番チェック
     C     Y1HINB        CHAIN     TEITMP
     C                   IF        %FOUND(TEITMP)
     C                   EVAL      Y1NAKN = ITITKN                              *品名
     C                   EVAL      Y1UTAN = ITPRIC                              *定価
     C                   ELSE
     C                   EVAL      *IN62  = *ON
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN60  = *ON
     C                   EVAL      X9MSG  = ERR(2)
     C                   EVAL      H1RCDN = #RRN01                              * SFLRCDNBR
     C                   ENDIF
     C                   ENDIF
     C**
     C**数量チェック
     C                   IF        Y1SURY  <= *ZERO
     C                   EVAL      *IN63  = *ON
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN60  = *ON
     C                   EVAL      X9MSG  = ERR(3)
     C                   EVAL      H1RCDN = #RRN01                              * SFLRCDNBR
     C                   ENDIF
     C                   ENDIF
     C**金額計算
     C                   EVAL      Y1KING = Y1UTAN * Y1SURY
     C**
     C                   ENDSR
     C*******************************************************
     C** データセット
     C*******************************************************
     C     @SETSF        BEGSR
     C**
     C                   EVAL      #RRN01 = *ZERO
     C**
     C                   EVAL      *IN32  = *ON                                 * SFLCLR
     C                   WRITE     CTL01
     C                   EVAL      *IN32  = *OFF                                * SFLCLR
     C**
     C     X1BANG        SETLL     TEJUTP
     C                   DO        15
     C                   CLEAR                   SFL01
     C     X1BANG        READE(N)  TEJUTP
     C                   IF        NOT %EOF(TEJUTP)
     C                   EVAL      Y1HINB = JUHINB                              *品番
     C     Y1HINB        CHAIN     TEITMP
     C                   IF        %FOUND(TEITMP)
     C                   EVAL      Y1NAKN = ITITKN                              *品名
     C                   ENDIF
     C                   EVAL      Y1SURY = JUSURY                              *数量
     C                   EVAL      Y1UTAN = JUUTAN                              *定価
     C                   EVAL      Y1KING = Y1SURY  * Y1UTAN                    *金額
     C                   ENDIF
     C                   EVAL      #RRN01 += 1                                  * RRN
     C                   WRITE     SFL01
     C                   ENDDO
     C**
     C                   EVAL      H1RCDN = 1                                   * SFLRCDNBR
     C**
     C                   ENDSR
     C*******************************************************
     C** データ処理
     C*******************************************************
     C     @PRC          BEGSR
     C**
     C**受注データ削除
     C     X1BANG        SETLL     TEJUTP
     C                   DOU       %EOF(TEJUTP)
     C     X1BANG        READE     TEJUTP
     C                   IF        NOT %EOF(TEJUTP)
     C                   DELETE    TEJUTPR
     C                   ENDIF
     C                   ENDDO
     C**
     C                   CLEAR                   TEJUTPR
     C                   DO        15            X
     C     X             CHAIN     SFL01
     C                   IF        %FOUND(INT02RD)
     C                             AND Y1HINB <> *BLANK
     C                   EVAL      JUCHUB = X1BANG                              *受注番号
     C                   EVAL      JUGYOB += 1                                  *行番号
     C                   EVAL      JUHINB = Y1HINB                              *品番
     C                   EVAL      JUUTAN = Y1UTAN                              *定価
     C                   EVAL      JUSURY = Y1SURY                              *受注数量
     C                   WRITE     TEJUTPR
     C                   ENDIF
     C                   ENDDO
     C**
     C                   ENDSR
     C*******************************************************
     C** エラー・リセット
     C*******************************************************
     C     @RST          BEGSR
     C**
     C                   MOVEA     '0000'        *IN(60)                        *エラー標識
     C                   EVAL      X9MSG = *BLANK                               * ERR FLD
     C**
     C                   ENDSR
     C*******************************************************
     C** 終了処理
     C*******************************************************
     C     @END          BEGSR
     C**
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C**
     C                   ENDSR
     C*******************************************************
     C** 初期処理
     C*******************************************************
     C     *INZSR        BEGSR
     C**
     C                   EVAL      #CTL  = 'HED'                                 * --> HED
     C**
     C                   ENDSR
** ERR
入力必須項目です。
該当の品番が存在しません。
ゼロ以下の入力はできません。
