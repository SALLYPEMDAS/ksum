-------------------------------------------------------------------------------
--  Copyright (c) 2017, Daniel King
--  All rights reserved.
--
--  This file is part of ksum.
--
--  ksum is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  ksum is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with ksum.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------
with Ada.Text_IO;
with Keccak.Generic_Parallel_Hash;
with Keccak.Types;
with Diagnostics;                  use Diagnostics;

generic
   with package ParallelHash is new Keccak.Generic_Parallel_Hash (<>);
package File_ParallelHash
is

   procedure Hash_File (File   : in     Ada.Text_IO.File_Type;
                        Buffer : in out Keccak.Types.Byte_Array);

   procedure Check_File (File          : in     Ada.Text_IO.File_Type;
                         Buffer        : in out Keccak.Types.Byte_Array;
                         Expected_Hash : in     Keccak.Types.Byte_Array;
                         Result        :    out Diagnostic);

private

   procedure Print_Output (Ctx    : in out ParallelHash.Context;
                           Buffer : in out Keccak.Types.Byte_Array);

   procedure Check_XOF_Output (Ctx           : in out ParallelHash.Context;
                               Buffer        : in out Keccak.Types.Byte_Array;
                               Expected_Hash : in     Keccak.Types.Byte_Array;
                               Result        :    out Diagnostic);

   procedure Check_Normal_Output (Ctx           : in out ParallelHash.Context;
                                  Expected_Hash : in     Keccak.Types.Byte_Array;
                                  Result        :    out Diagnostic);

end File_ParallelHash;
