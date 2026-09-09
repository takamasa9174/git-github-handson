**free

ctl-opt   datedit(*ymd);
ctl-opt   text('得意先マスター照会');

dcl-f   TECSMP disk(*ext) usage(*input) keyed;
dcl-f   INT03RD workstn(*ext);

dou  *in03 = *on;

     write     fmt90;
     exfmt     fmt01;

     if   *in03;
          leave;
     endif;     

     chain x1bang tecsmp;
     if %found(tecsmp);
          write     fmt90;
          write     fmt01;
          exfmt     fmt02;
     endif;

enddo;

*inlr = *on;