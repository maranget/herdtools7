(*********************************************************************)
(*                        Herd                                       *)
(*                                                                   *)
(* Luc Maranget, INRIA Paris-Rocquencourt, France.                   *)
(* Jade Alglave, University College London, UK.                      *)
(* John Wickerson, Imperial College London, UK.                      *)
(* Tyler Sorensen, University College London                         *)
(*                                                                   *)
(*  Copyright 2013 Institut National de Recherche en Informatique et *)
(*  en Automatique and the authors. All rights reserved.             *)
(*  This file is distributed  under the terms of the Lesser GNU      *)
(*  General Public License.                                          *)
(*********************************************************************)

(** Define Bell architecture *)

module Make (C:Arch.Config) (V:Value.S) = struct
    include BellBase

  let get_id_and_list i = match i with
  | Pld(_,_,s) -> (BellName.r,s)
  | Pst(_,_,s) -> (BellName.w,s)
  | Pfence (Fence s) -> (BellName.f,s)      
  | Prmw2_op(_,_,_,_,s) | Prmw3_op(_,_,_,_,_,s) ->
    (BellName.rmw,s)
  | _ -> raise Not_found


    module V = V

    include ArchExtra.Make(C)        
	(struct
	  module V = V 

	  type arch_reg = reg
	  let pp_reg = pp_reg
	  let reg_compare = reg_compare

	  type arch_instruction = instruction
	end)
  end