
(*
  OCaml HTTP - do it yourself (fully OCaml) HTTP daemon

  Copyright (C) <2011-2012> Anil Madhavapeddy <anil@recoil.org>
  Copyright (C) <2002-2005> Stefano Zacchiroli <zack@cs.unibo.it>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU Library General Public License as
  published by the Free Software Foundation, version 2.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Library General Public License for more details.

  You should have received a copy of the GNU Library General Public
  License along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
  USA
*)

(** HTTP messages parsing *)

open Code

  (** parse 1st line of an HTTP request
  @param inchan input channel from which parse request
  @return a triple meth * url * version, meth is the HTTP method invoked, url is
  the requested url, version is the HTTP version specified or None if no version
  was specified
  @raise Malformed_request if request 1st linst isn't well formed
  @raise Malformed_request_URI if requested URI isn't well formed *)
val parse_request_fst_line: IO.ic -> (meth * Uri.t * version) option IO.M.t

  (** parse 1st line of an HTTP response
   * @param inchan input channel from which parse response
   * @raise Malformed_response if first line isn't well formed
  *)
val parse_response_fst_line: IO.ic -> (version * status_code) option IO.M.t

  (** parse HTTP headers. Consumes also trailing CRLF at the end of header list
  @param inchan input channel from which parse headers
  @return a list of pairs header_name * header_value
  @raise Invalid_header if a not well formed header is encountered *)
val parse_headers: IO.ic -> ((string * string) list) IO.M.t

  (** given an input channel, reads from it a GET HTTP request and
  @return a pair <path, query_params> where path is a string representing the
  requested path and query_params is a list of pairs <name, value> (the GET
  parameters) *)
val parse_request: IO.ic -> (string * (string * string) list) option IO.M.t

  (** parse content-range header in a request
  @return number of bytes to read, or None if all available should be read
  *)
val parse_content_range: (string * string) list -> int option