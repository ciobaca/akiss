{
  open Parser

  let incr_linenum lexbuf =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <- { pos with
      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
      Lexing.pos_bol = pos.Lexing.pos_cnum;
    }
  ;;
}  
let digit = ['0' - '9']
let digits = digit +
let lower = ['a' - 'z']
let upper = ['A' - 'Z']
let letter = lower | upper
let letters = letter ((letter | digit) * )
rule token = parse
               | "0" { Zero (* :: main lexbuf *) }
	       | "let" { Let (* :: main lexbuf *) }
	       | "symbols" { Symbols (* :: main lexbuf *) }
	       | "private" { Private (* :: main lexbuf *) }
	       | "channels" { Channels (* :: main lexbuf *) }
	       | "evchannels" { EvChannels (* :: main lexbuf *) }
	       | "::" { InnerSequence (* :: main lexbuf *) }
	       | "||" { InnerInterleave (* :: main lexbuf *) }
	       | "interleave" { Interleave (* :: main lexbuf *) }
	       | "interleave_opt" { InterleaveOpt (* :: main lexbuf *) }
	       | "remove_end_tests" { RemoveEndTests (* :: main lexbuf *) }
	       | "print_traces" { PrintTraces (* :: main lexbuf *) }
	       | "sequence" { Sequence (* :: main lexbuf *) }
	       | "print" { Print (* :: main lexbuf *) }
	       | "|-" { Deduc  (* :: main lexbuf *) }
	       | "equivalentft?" { Square (* :: main lexbuf *) }
	       | "fwdequivalentft?" { EvSquare (* :: main lexbuf *) }
	       | "var" { Var (* :: main lexbuf *) }
	       | "equivalentct?" { Equivalent (* :: main lexbuf *) }
	       | "and" { And (* :: main lexbuf *) }
	       | "/*" { comment 1 lexbuf }
	       | "//" { line_comment lexbuf (* :: main lexbuf *) }
	       | "/" { Slash (* :: main lexbuf *) }
	       | "," { Comma (* :: main lexbuf *) }
	       | ";" { Semicolon (* :: main lexbuf *) }
	       | "var" { Var (* :: main lexbuf *) }
	       | "rewrite" { Rewrite (* :: main lexbuf *) }
	       | "evrewrite" { EvRewrite (* :: main lexbuf *) }
	       | "->" { Arrow (* :: main lexbuf *) }
	       | "=" { Equals (* :: main lexbuf *) }
	       | "out" { Out (* :: main lexbuf *) }
	       | "in" { In (* :: main lexbuf *) }
	       | "[" { LeftB (* :: main lexbuf *) }
	       | "]" { RightB (* :: main lexbuf *) }
	       | "(" { LeftP (* :: main lexbuf *) }
	       | ")" { RightP (* :: main lexbuf *) }
	       | "." { Dot (* :: main lexbuf *) }
               | digits as n { Int(int_of_string n) (* :: main lexbuf *) }
	       | letters as s { Identifier s (* :: main lexbuf *) }
	       | '\n' { incr_linenum lexbuf; token lexbuf }
	       | eof { EOF (* [] *) }
	       | _ { token lexbuf }
and comment depth = parse
    | '\n' { incr_linenum lexbuf; comment depth lexbuf }
    | "/*" { comment (depth + 1) lexbuf }
    | "*/" { if depth = 1
      then token lexbuf
      else comment (depth - 1) lexbuf }
    | _ { comment depth lexbuf }
and line_comment = parse
    | '\n' { incr_linenum lexbuf; token lexbuf }
    | _ { line_comment lexbuf }
