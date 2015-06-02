module type S = sig
    include ArchBase.S
  end

module type Parser = sig
    include GenParser.S
    val instr_from_string : string -> pseudo list
  end

module Make
	 (A:S)
	 (P:sig
	      include GenParser.LexParse with type instruction = A.pseudo
	      val instr_parser : 
		(Lexing.lexbuf -> token) -> Lexing.lexbuf ->
		A.pseudo list
	    end) = struct
  include GenParser.Make(GenParser.DefaultConfig)(A)(P)
			
  let instr_from_string s =
    GenParser.call_parser "themes" (Lexing.from_string s) 
			  P.lexer P.instr_parser
		
end

    
let get_arch = function
    | `AArch64 -> (module AArch64Arch : S)
    | `Bell -> (module BellArch : S)


let get_parser = function
  | `AArch64 -> 
     let module AArch64LexParse = struct
       type instruction = AArch64Arch.pseudo
       type token = AArch64Parser.token
       module Lexer = AArch64Lexer.Make(struct let debug = false end)
       let lexer = Lexer.token
       let parser = MiscParser.mach2generic AArch64Parser.main
       let instr_parser = AArch64Parser.instr_option_list
     end in (module Make(AArch64Arch)(AArch64LexParse) : Parser)
 | `Bell ->
    let module BellLexParse = struct
      type instruction = BellArch.pseudo
      type token = BellParser.token
      module Lexer = BellLexer.Make(struct let debug = false end)
      let lexer = Lexer.token
      let parser = BellParser.main
      let instr_parser = BellParser.instr_option_list
    end in (module Make(BellArch)(BellLexParse) : Parser)